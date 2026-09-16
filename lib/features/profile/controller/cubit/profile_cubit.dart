import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/models/passport_form.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/models/user_profile_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/image_picker_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/utils/app_phone.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/profile/models/document_type_model.dart';
import 'package:skygate/features/profile/models/pilgrim_document_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileCubit get(BuildContext context) => BlocProvider.of(context);
  UserProfileModel? user;
  int? get pilgrimId =>
      user?.id ?? (CacheUtil.get(key: AuthCubit.pilgrimIdKey) as int?);
  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final response = await DioService.get(ApiEndpoints.home);
      final body = response.data['data'];
      user = UserProfileModel.of(body is Map ? body['user'] : null);
      _fillForms();
      emit(ProfileLoaded());
    } catch (error) {
      debugPrint('getProfile error: $error');
      emit(ProfileError(message: ApiError.messageOf(error)));
    }
  }

  void _fillForms() {
    final profile = user;
    if (profile == null) return;

    nameController.text = profile.fullName ?? '';
    phoneController.text = profile.mobile ?? AppPhone.defaultDialCode;
    emailController.text = profile.email ?? '';
    passportForm.fillFrom(profile.passport);
    passportForm.isScanned = false;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(
    text: AppPhone.defaultDialCode,
  );
  final TextEditingController emailController = TextEditingController();
  File? profileImage;

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

  void resetAccountForm() {
    profileImage = null;
    _fillForms();
    emit(ProfileLoaded());
  }

  Future<void> saveAccount() async {
    final id = pilgrimId;
    if (id == null) {
      emit(AccountSaveError(message: ApiError.generic));
      return;
    }

    final name = nameController.text.trim();
    final mobile = AppPhone.normalize(phoneController.text);
    final email = emailController.text.trim();

    emit(AccountSaving());
    try {
      await DioService.put(
        ApiEndpoints.pilgrim(id),
        data: UserProfileModel.accountJson(
          fullName: name,
          mobile: mobile,
          email: email,
        ),
      );
      user = user?.copyWith(fullName: name, mobile: mobile, email: email);
      emit(AccountSaved());
    } catch (error) {
      debugPrint('saveAccount error: $error');
      emit(AccountSaveError(message: ApiError.messageOf(error)));
    }
  }

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword = !obscureCurrentPassword;
    emit(PasswordVisibilityToggled());
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword = !obscureNewPassword;
    emit(PasswordVisibilityToggled());
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(PasswordVisibilityToggled());
  }

  void clearPasswordForm() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> changePassword() async {
    emit(PasswordSaving());
    try {
      await DioService.post(
        ApiEndpoints.changePassword,
        data: {
          'current_password': currentPasswordController.text,
          'password': newPasswordController.text,
          'password_confirmation': confirmPasswordController.text,
        },
      );
      clearPasswordForm();
      emit(PasswordSaved());
    } catch (error) {
      debugPrint('changePassword error: $error');
      emit(PasswordSaveError(message: ApiError.messageOf(error)));
    }
  }

  final PassportForm passportForm = PassportForm();
  bool get isScanned => passportForm.isScanned;
  bool scanFailed = false;
  PassportDataModel get passport => user?.passport ?? PassportDataModel();
  void passportChanged() => emit(PassportFieldChanged());
  void resetPassportForm() {
    scanFailed = false;
    _fillForms();
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
          scanFailed = false;
          emit(PassportScanned());
        })
        .catchError((error) {
          debugPrint('scanPassport error: $error');
          passportForm.isScanned = false;
          scanFailed = true;
          emit(PassportScanError(message: ApiError.messageOf(error)));
        });
  }

  void resetScan() {
    passportForm.resetScan();
    scanFailed = false;
    emit(PassportFieldChanged());
  }

  Future<void> savePassport() async {
    final id = pilgrimId;
    if (id == null) {
      emit(PassportSaveError(message: ApiError.generic));
      return;
    }

    final data = passportForm.toModel();
    emit(PassportSaving());
    try {
      await DioService.put(
        ApiEndpoints.pilgrim(id),
        data: data.toPilgrimJson(isSelf: true),
      );
      user = user?.copyWith(passport: data);
      passportForm.isScanned = false;
      scanFailed = false;
      emit(PassportSaved());
    } catch (error) {
      debugPrint('savePassport error: $error');
      emit(PassportSaveError(message: ApiError.messageOf(error)));
    }
  }

  final List<UmrahDocumentModel> documentTypes = UmrahDocumentModel.catalogue;
  List<DocumentTypeModel> documentTypeCatalogue = const [];
  List<PilgrimDocumentModel> documents = const [];
  final Map<String, File> pendingUploads = {};
  PilgrimDocumentModel? uploadFor(UmrahDocumentModel document) {
    final typeId = DocumentTypeModel.idOf(documentTypeCatalogue, document);
    if (typeId == null) return null;
    for (final row in documents) {
      if (row.documentTypeId == typeId) return row;
    }
    return null;
  }

  Future<void> getDocuments() async {
    emit(DocumentsLoading());
    try {
      final responses = await Future.wait([
        DioService.get(ApiEndpoints.pilgrimDocuments),
        DioService.get(ApiEndpoints.documentTypes),
      ]);
      documents = ApiParse.rowsOf(
        responses[0].data['data'],
        PilgrimDocumentModel.fromJson,
      );
      documentTypeCatalogue = ApiParse.rowsOf(
        responses[1].data['data'],
        DocumentTypeModel.fromJson,
      );
      emit(DocumentsLoaded());
    } catch (error) {
      debugPrint('getDocuments error: $error');
      emit(DocumentsError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> pickDocument(String id, ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) return;
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(FileTooLarge());
      return;
    }
    pendingUploads[id] = file;
    emit(DocumentPicked());
  }

  void removeDocument(String id) {
    pendingUploads.remove(id);
    emit(DocumentPicked());
  }

  void resetDocumentsForm() {
    pendingUploads.clear();
    emit(DocumentPicked());
  }

  Future<void> saveDocuments() async {
    if (pendingUploads.isEmpty) {
      emit(DocumentsSaved());
      return;
    }

    emit(DocumentsSaving());
    try {
      for (final entry in pendingUploads.entries) {
        final document = documentTypes.firstWhere(
          (type) => type.id == entry.key,
        );
        await DioService.post(
          ApiEndpoints.pilgrimDocuments,
          data: FormData.fromMap({
            'pilgrim_id': ?pilgrimId,
            'document_type_id': ?DocumentTypeModel.idOf(
              documentTypeCatalogue,
              document,
            ),
            'document_type': entry.key,
            'file': await MultipartFile.fromFile(entry.value.path),
          }),
        );
      }
      pendingUploads.clear();
      emit(DocumentsSaved());
      await getDocuments();
    } catch (error) {
      debugPrint('saveDocuments error: $error');
      emit(DocumentsSaveError(message: ApiError.messageOf(error)));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    passportForm.dispose();
    return super.close();
  }
}
