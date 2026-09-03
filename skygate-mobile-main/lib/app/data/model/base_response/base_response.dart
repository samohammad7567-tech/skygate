class BaseResponse<T> {
  final T? data;
  final String? message;
  final String? code;

  factory BaseResponse.fromJson(Map<String, dynamic> json,
      T Function(dynamic json)? dataDecode) {
    Map<String,dynamic> emptyObj = {};
    return BaseResponse(
      message : json['message'] ?? " ",
      code : json['code'].toString() ?? " ",
      data : dataDecode?.call(json['data']),
    );
  }

  @override
  String toString() {
    return 'statusCode: $code\n' 'message: $message\n' 'data: $data';
  }

  BaseResponse({this.message, this.code, this.data});
}
