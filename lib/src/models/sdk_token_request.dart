class SdkTokenRequest {
  SdkTokenRequest({
    required this.accessCode,
    required this.merchantIdentifier,
    required this.deviceId,
    this.language = 'en',
    this.signature,
  }) : command = 'SDK_TOKEN';

  /// Request Command.
  ///
  String command;

  /// Alphanumeric access code.
  ///
  String accessCode;

  /// The ID of the Merchant.
  ///
  String merchantIdentifier;

  /// The checkout page and messages language.
  /// By default language is [en].
  ///
  String language;

  /// A unique device identifier.
  ///
  String deviceId;

  /// A string hashed using the [Secure Hash Algorithm]. Please refer to section Signature.
  ///
  String? signature;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_command': command,
      'access_code': accessCode,
      'merchant_identifier': merchantIdentifier,
      'language': language,
      'device_id': deviceId,
      'signature': signature,
    };
  }

  String toConcatenatedString(String shaRequestPhrase) {
    return '$shaRequestPhrase'
        'access_code=$accessCode'
        'device_id=$deviceId'
        'language=$language'
        'merchant_identifier=$merchantIdentifier'
        'service_command=$command'
        '$shaRequestPhrase';
  }
}
