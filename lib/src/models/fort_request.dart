import 'dart:convert';

class FortRequest {
  FortRequest({
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.orderDescription,
    required this.sdkToken,
    required this.customerIp,
    this.currency = 'USD',
    this.language = 'en',
    this.merchantReference,
    this.tokenName,
    this.paymentOption,
    this.eci,
    this.phoneNumber,
  }) : command = 'PURCHASE';

  /// Request Command.
  ///
  final String command;

  /// The transaction’s amount.
  /// Each currency has predefined allowed decimal points that should be taken into consideration when sending the amount.
  ///
  final num amount;

  /// The currency of the transaction’s amount in ISO code 3. Example: AED, USD, EUR, GBP.
  /// By Default currency : [USD].
  ///
  final String currency;

  /// The Merchant’s unique order number.
  ///
  final String? merchantReference;

  /// The customer’s name.
  ///
  final String customerName;

  /// The customer’s email. Example: customer1@domain.com
  ///
  final String customerEmail;

  /// A description of the order.
  ///
  final String? orderDescription;

  /// The checkout page and messages language.
  /// By default language: [en].
  ///
  final String language;

  /// An SDK Token to enable using the Amazon Payment Services Mobile SDK.
  ///
  final String sdkToken;

  /// The Token received from the Tokenization process..
  ///
  final String? tokenName;

  /// Payment option. [MASTERCARD], [VISA], [AMEX] etc...
  ///
  final String? paymentOption;

  /// The E-commerce indicator. example: [ECOMMERCE]
  ///
  final String? eci;

  /// It holds the customer’s IP address.
  /// It’s Mandatory, if the fraud service is active.
  /// We support IPv4 and IPv6 as shown in the example below.
  ///
  final String? customerIp;

  /// The customer’s phone number.
  ///
  final String? phoneNumber;

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
      'token_name': tokenName,
      'payment_option': paymentOption,
      'eci': eci,
      'customer_ip': customerIp,
      'phone_number': phoneNumber,
    };
  }

  @override
  String toString() {
    return jsonEncode(toFortRequest());
  }
}
