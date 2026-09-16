import 'dart:io';

class EditProfileParams {
  String? full_name;
  String? mobile;
  String? password;
  List<File>? national_id_images;
  List<File>? passport_images;

  EditProfileParams({
    this.full_name,
    this.mobile,
    this.password,
    this.national_id_images,
    this.passport_images,
  });
}
