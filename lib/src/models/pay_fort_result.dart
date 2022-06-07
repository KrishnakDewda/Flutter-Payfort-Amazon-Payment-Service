import 'package:amazon_payfort/src/enums/response_status.dart';

class PayfortResult {
  PayfortResult({
    required this.status,
    required this.message,
    required this.code,
  });

  /// Transaction status code
  /// 
  String code;

  /// Transaction status : [success], [failure] and [canceled]
  ResponseStatus status;

  /// Transaction message
  /// 
  String message;

  factory PayfortResult.fromMap(Map<String, dynamic> data) {
    return PayfortResult(
      code: data['response_code'],
      status: ResponseStatus.values[data['response_status']],
      message: data['response_message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'response_code': code,
      'response_status': status.index,
      'response_message': message,
    };
  }
}
