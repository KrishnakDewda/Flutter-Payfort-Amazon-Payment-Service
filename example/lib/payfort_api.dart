import 'dart:convert';

import 'package:amazon_payfort/amazon_payfort.dart';
import 'package:amazon_payfort_example/sdk_token_response.dart';
import 'package:http/http.dart';

class PayFortApi {
  PayFortApi._();

  static Future<SdkTokenResponse?> generateSdkToken(
      Uri uri, SdkTokenRequest request) async {
    var response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toMap()),
    );
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return SdkTokenResponse.fromMap(decodedResponse);
    }
    return null;
  }
}
