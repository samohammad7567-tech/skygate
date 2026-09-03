class _AppInformationKeys{
  static const firstTime="first_time";
}

class AppInformationModel{
  bool firstTime;

  AppInformationModel({required this.firstTime});

  factory AppInformationModel.fromJson(Map<String ,dynamic> json){
    return AppInformationModel(firstTime: json[_AppInformationKeys.firstTime].toString().toLowerCase()=="true"?true:false);
  }
  Map<String, dynamic>  toJson(){
    return {
      _AppInformationKeys.firstTime:firstTime.toString(),
    };
  }

}