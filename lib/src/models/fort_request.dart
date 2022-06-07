class FortRequest {
  FortRequest({
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.orderDescription,
    required this.sdkToken,
    this.currency = 'USD',
    this.language = 'en',
    this.merchantReference,
  }) : command = 'PURCHASE';

  /// Request Command.
  ///
  String command;

  /// The transaction’s amount.
  /// Each currency has predefined allowed decimal points that should be taken into consideration when sending the amount.
  ///
  num amount;

  /// The currency of the transaction’s amount in ISO code 3. Example: AED, USD, EUR, GBP.
  /// By Default currency : [USD].
  ///
  String currency;

  /// The Merchant’s unique order number.
  ///
  String? merchantReference;

  /// The customer’s name.
  ///
  String customerName;

  /// The customer’s email. Example: customer1@domain.com
  ///
  String customerEmail;

  /// A description of the order.
  ///
  String? orderDescription;

  /// The checkout page and messages language.
  /// By default language: [en].
  ///
  String language;

  /// An SDK Token to enable using the Amazon Payment Services Mobile SDK.
  ///
  String sdkToken;

  Map<String, dynamic> toFortRequest() {
    return <String, dynamic>{
      'command': command,
      'amount': amount.toString(),
      'merchant_reference': '${DateTime.now().millisecondsSinceEpoch}',
      'currency': currency,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'order_description': orderDescription,
      'language': language,
      'sdk_token': sdkToken,
    };
  }
}
