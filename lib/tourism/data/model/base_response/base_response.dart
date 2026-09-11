class BaseResponse<T> {
  final T? data;
  final String? message;
  final String? code;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? dataDecode,
  ) {
    return BaseResponse(
      message: json['message'] ?? " ",
      code: json['code']?.toString() ?? "",
      data: _decodeData(json['data'], dataDecode),
    );
  }
  static T? _decodeData<T>(
    dynamic rawData,
    T Function(dynamic json)? dataDecode,
  ) {
    if (dataDecode == null) return null;
    if (rawData == null) {
      try {
        return dataDecode(null);
      } catch (_) {
        return null;
      }
    }
    return dataDecode(rawData);
  }

  @override
  String toString() {
    return 'statusCode: $code\n'
        'message: $message\n'
        'data: $data';
  }

  BaseResponse({this.message, this.code, this.data});
}
