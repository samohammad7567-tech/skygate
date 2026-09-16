import 'dart:async';
import 'package:skygate/tourism/modules/user/user_model.dart';
import '../../model/app_information/app_information.dart';
import '../../provider/api_provider/auth_provider.dart';
import '../../provider/storage_provider/local_auth_provider.dart';

enum AuthenticationState { unknown, unauthenticated, authenticated, firstTime }

class AuthRepository {
  final ApiAuthProvider apiProvider;
  final LocalAuthProvider localAuthProvider;

  late UserModel user;
  late AppInformationModel appInformation;
  StreamController<AuthenticationState> authStreamController =
      StreamController<AuthenticationState>()..add(AuthenticationState.unknown);

  Stream<AuthenticationState> getAuthState() {
    return authStreamController.stream;
  }

  AuthRepository({required this.apiProvider, required this.localAuthProvider});
}
