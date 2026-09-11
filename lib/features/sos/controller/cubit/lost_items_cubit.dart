import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/image_picker_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/sos/models/lost_item_model.dart';

part 'lost_items_state.dart';

enum LostItemsTab {
  all('lost_tab_all'),
  mine('lost_tab_mine');

  const LostItemsTab(this.labelKey);

  final String labelKey;
}

class LostItemsCubit extends Cubit<LostItemsState> {
  LostItemsCubit() : super(LostItemsInitial());

  LostItemsCubit get(BuildContext context) => BlocProvider.of(context);
  List<LostItemModel> _all = [];
  List<LostItemModel> items = [];

  LostItemsTab tab = LostItemsTab.all;
  LostItemStatus? statusFilter;
  int? get _pilgrimId => CacheUtil.get(key: AuthCubit.pilgrimIdKey) as int?;

  void changeTab(LostItemsTab value) {
    print(_pilgrimId);
    if (tab == value) return;
    tab = value;
    _applyFilters();
    emit(LostItemsLoaded());
  }

  void filterByStatus(LostItemStatus? status) {
    if (statusFilter == status) return;
    statusFilter = status;
    _applyFilters();
    emit(LostItemsLoaded());
  }

  Future<void> getItems() async {
    emit(LostItemsLoading());
    try {
      final response = await DioService.get(ApiEndpoints.lostItems);
      _all = ApiParse.rowsOf(response.data['data'], LostItemModel.fromJson);
      _applyFilters();
      emit(LostItemsLoaded());
    } catch (error) {
      debugPrint('getItems error: $error');
      emit(LostItemsError(message: ApiError.messageOf(error)));
    }
  }

  void _applyFilters() {
    final id = _pilgrimId;
    items = [
      for (final item in _all)
        if (tab == LostItemsTab.all || item.isMine(id))
          if (statusFilter == null || item.status == statusFilter) item,
    ];
  }

  // ── "الإبلاغ عن غرض مفقود" ─────────────────────────────────────────────
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime? lostAt;
  File? photo;

  void selectLostAt(DateTime value) {
    lostAt = value;
    emit(LostItemFormChanged());
  }

  Future<void> pickPhoto(ImageSource source) async {
    final picked = await ImagePickerService.pick(source);
    if (picked == null) return;

    if (!await ImagePickerService.isWithinSizeLimit(picked)) {
      emit(LostItemReportError(message: 'file_too_large'));
      return;
    }

    photo = picked;
    emit(LostItemFormChanged());
  }

  void removePhoto() {
    photo = null;
    emit(LostItemFormChanged());
  }

  Future<void> submitReport() async {
    emit(LostItemReportSending());
    try {
      final response = await DioService.post(
        ApiEndpoints.lostItems,
        data: await LostItemModel.body(
          description: descriptionController.text.trim(),
          locationHint: placeController.text.trim(),
          lostAt: lostAt,
          notes: notesController.text.trim(),
          photo: photo,
        ),
      );

      final body = response.data['data'];
      if (body is Map<String, dynamic>) {
        _all = [LostItemModel.fromJson(body), ..._all];
        _applyFilters();
      }

      _clearForm();
      emit(LostItemReported());
    } catch (error) {
      debugPrint('submitReport error: $error');
      emit(LostItemReportError(message: ApiError.messageOf(error)));
    }
  }

  void _clearForm() {
    descriptionController.clear();
    placeController.clear();
    notesController.clear();
    lostAt = null;
    photo = null;
  }

  @override
  Future<void> close() {
    descriptionController.dispose();
    placeController.dispose();
    notesController.dispose();
    return super.close();
  }
}
