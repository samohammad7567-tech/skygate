import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/models/passport_form.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/image_picker_service.dart';
import 'package:skygate/core/services/language_service.dart';
import 'package:skygate/core/utils/app_phone.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/auth/models/auth_user_model.dart';

part 'register_state.dart';
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  RegisterCubit get(BuildContext context) => BlocProvider.of(context);
  int currentStep = 1;

  void goToStep(int step) {
    if (step == currentStep || step < 1 || step > 3) return;
    currentStep = step;
    emit(StepChanged());
  }

  // -- Step 1 - personal info ---------------------------------------------
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(
    text: AppPhone.defaultDialCode,
  );
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  File? profileImage;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(PasswordVisibilityToggled());
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(PasswordVisibilityToggled());
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) return;
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(FileTooLarge());
      return;
    }
    profileImage = file;
    emit(ProfileImagePicked());
  }

  void removeProfileImage() {
    profileImage = null;
    emit(ProfileImagePicked());
  }

  // -- Step 2 - passport ---------------------------------------------------
  final PassportForm passportForm = PassportForm();

  DateTime? get birthDate => passportForm.birthDate;
  String? get gender => passportForm.gender;
  bool get pledgeAccepted => passportForm.pledgeAccepted;
  bool get isScanned => passportForm.isScanned;
  void passportChanged() => emit(PassportFieldChanged());

  void togglePledge(bool? value) {
    passportForm.pledgeAccepted = value ?? false;
    emit(PassportFieldChanged());
  }
  Future<void> scanPassportFrom(ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) {
      emit(PassportScanCancelled());
      return;
    }
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(FileTooLarge());
      return;
    }
    await scanPassport(file);
  }
  Future<void> scanPassport(File image) async {
    emit(PassportScanLoading());
    return DioService.post(
          ApiEndpoints.scanPassport,
          data: FormData.fromMap({
            'passport_image': await MultipartFile.fromFile(image.path),
          }),
        )
        .then((response) {
          final body = response.data['data'];
          passportForm.fillFrom(
            PassportDataModel.fromJson(
              body is Map<String, dynamic> ? body : const {},
            ),
          );
          passportForm.isScanned = true;
          emit(PassportScanned());
        })
        .catchError((error) {
          debugPrint('scanPassport error: $error');
          emit(PassportScanError(message: AuthCubit.messageOf(error)));
        });
  }
  void resetScan() {
    passportForm.resetScan();
    emit(PassportFieldChanged());
  }

  PassportDataModel get passport => passportForm.toModel();

  // -- Step 3 - pilgrim documents ------------------------------------------
  final List<UmrahDocumentModel> documentTypes = UmrahDocumentModel.catalogue;
  final Map<String, File> documents = {};

  Future<void> pickDocument(String id, ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) return;
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(FileTooLarge());
      return;
    }
    documents[id] = file;
    emit(DocumentPicked());
  }

  void removeDocument(String id) {
    documents.remove(id);
    emit(DocumentPicked());
  }

  // -- Submit ---------------------------------------------------------------
  AuthUserModel? user;
  Future<void> submit() async {
    emit(RegisterLoading());
    try {
      final response = await DioService.post(
        ApiEndpoints.register,
        data: registerBody(),
      );
      user = AuthUserModel.fromJson(response.data);
      AuthCubit.persist(user!);

      await _uploadDocuments();
      emit(RegisterSucceeded());
    } catch (error) {
      debugPrint('register error: $error');
      emit(RegisterError(message: AuthCubit.messageOf(error)));
    }
  }
  Map<String, dynamic> registerBody() {
    final passportData = passport;

    return {
      'full_name': nameController.text.trim(),
      'mobile': AppPhone.normalize(phoneController.text),
      'password': passwordController.text,
      'email': emailController.text.trim(),
      'passport_number': passportData.passportNumber,
      'passport_expiry_date': _date(passportData.expiryDate),
      'dob': _date(passportData.birthDate),
      'national_number': passportData.nationalNumber,
      'nationality': passportData.nationality,
      'lang': LanguageService.current,
      'gender': passportData.gender,
      'full_name_ar': passportData.fullNameAr,
      'full_name_en': passportData.fullNameEn,
      'issue_place': passportData.issuePlace,
      'issue_date': _date(passportData.issueDate),
    };
  }
  static String? _date(DateTime? value) =>
      value?.toIso8601String().split('T').first;
  Future<void> skipDocuments() {
    documents.clear();
    return submit();
  }
  Future<void> _uploadDocuments() async {
    if (documents.isEmpty) return;
    final int? pilgrimId =
        user?.pilgrimId ?? (CacheUtil.get(key: AuthCubit.pilgrimIdKey) as int?);

    for (final entry in documents.entries) {
      try {
        await DioService.post(
          ApiEndpoints.uploadDocument,
          data: FormData.fromMap({
            'pilgrim_id': ?pilgrimId,
            'document_type': entry.key,
            'file': await MultipartFile.fromFile(entry.value.path),
          }),
        );
      } catch (error) {
        debugPrint('uploadDocument ${entry.key} error: $error');
      }
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passportForm.dispose();
    return super.close();
  }
}
