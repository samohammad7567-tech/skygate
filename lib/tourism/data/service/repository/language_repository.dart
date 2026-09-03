import '../../provider/storage_provider/local_language_provider.dart';

class LanguageRepository {

  late LocalLanguageProvider localLanguageProvider;
  LanguageRepository(){
    localLanguageProvider=LocalLanguageProvider();
  }

}
