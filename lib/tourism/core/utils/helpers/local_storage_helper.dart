import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class LocalStorageHelper {
  SharedPreferences? preferences;

  LocalStorageHelper();

  Future<bool> store({required String path, required String data}) async {
    preferences ??=await SharedPreferences.getInstance();
    return preferences!.setString(path, data);
  }

  Future<void> storeUserData({required UserModel? userModel}) async {
    SharedClass.apiToken = userModel!.access_token!;
    SharedClass.userId = userModel.user_id!;
    SharedClass.loggedUserMobile = userModel.mobile!;
    SharedClass.loggedUsername = userModel.full_name!;
    SharedClass.avatar = userModel.avatar!;
    SharedClass.lang = userModel.lang!;
    SharedClass.status = userModel.status!;
    SharedClass.biometricsKey = userModel.biometrics_key!;
    SharedClass.biometricsEnabled = userModel.biometrics_enabled!;

    await store(path: "token", data: SharedClass.apiToken);
    await store(path: "userId", data: SharedClass.userId);
    await store(path: "mobile", data: SharedClass.loggedUserMobile);
    await store(path: "lang", data: SharedClass.lang);
    await store(path: "fullName", data: SharedClass.loggedUsername);
    await store(path: "biometricsKey", data: SharedClass.biometricsKey);
    await store(path: "biometricsEnabled", data: SharedClass.biometricsEnabled);
    await store(path: "avatar", data: SharedClass.avatar);
    await store(path: "status", data: SharedClass.status);
  }

  Future<void> readUserData() async {
    SharedClass.apiToken = await read(path: "token");
    SharedClass.userId = await read(path: "userId");
    SharedClass.loggedUserMobile = await read(path: "mobile");
    SharedClass.loggedUsername = await read(path: "lang");
    SharedClass.avatar = await read(path: "fullName");
    SharedClass.lang = await read(path: "avatar");
    SharedClass.status = await read(path: "status");
    SharedClass.biometricsKey = await read(path: "biometricsKey");
    SharedClass.biometricsEnabled = await read(path: "biometricsEnabled");
  }

  Future<bool> delete({required String path}) async {
    preferences ??=await SharedPreferences.getInstance();
    return preferences!.remove(path);
  }

  Future<bool> deleteUserData() async {
    await delete(path: "token");
    await delete(path: "userId");
    await delete(path: "mobile");
    await delete(path: "lang");
    await delete(path: "fullName");
    await delete(path: "avatar");
    await delete(path: "status");

    SharedClass.apiToken = "";
    SharedClass.userId = "";
    SharedClass.loggedUserMobile = "";
    SharedClass.loggedUsername = "";
    SharedClass.avatar = "";
    SharedClass.lang = "";
    SharedClass.status = "";
    SharedClass.targetPage = Routes.SPLASH;

    return true;
  }

  Future<String> read({required String path}) async{
    preferences ??=await SharedPreferences.getInstance();
    String? textData = preferences!.getString(path);
    if (textData == null) {
      return "";
    } else {
      return textData;
    }
  }
}
