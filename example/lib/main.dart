import 'dart:developer';

import 'package:amazon_payfort/amazon_payfort.dart';
import 'package:amazon_payfort_example/fort_constants.dart';
import 'package:amazon_payfort_example/payfort_api.dart';
import 'package:amazon_payfort_example/sdk_token_response.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Step 1 : Create a instance of AmazonPayfort.
  final AmazonPayfort _amazonPayfort =
      AmazonPayfort.instance(FortConstants.environment);

  bool _loading = false;
  String? _message;

  Future<void> _paymentHandler({bool payWithApplePay = false}) async {
    try {
      _setLoading(true);

      /// Step 2 : Get the baseUrl, DeiveId and Singature of the SDK Token
      String? baseUrl = await _amazonPayfort.getEnvironmentBaseUrl();

      String? deviceId = await _amazonPayfort.getDeviceId();

      SdkTokenRequest tokenRequest = SdkTokenRequest(
        accessCode: FortConstants.accessCode,
        merchantIdentifier: FortConstants.merchantIdentifier,
        deviceId: deviceId ?? '',
      );

      String? signature = await _amazonPayfort.generateSignature(
        shaType: FortConstants.shaType,
        concatenatedString:
            tokenRequest.toConcatenatedString(FortConstants.shaRequestPhrase),
      );

      tokenRequest = tokenRequest.copyWith(signature: signature);

      /// Step 3 : Generate the SDK Token
      SdkTokenResponse? response = await PayFortApi.generateSdkToken(
          Uri.parse(baseUrl ?? ''), tokenRequest);

      /// Step 4 : Processing Transaction
      FortRequest request = FortRequest(
        amount: 1000,
        customerName: 'Test Customer',
        customerEmail: 'test@customer.com',
        orderDescription: 'Test Order',
        sdkToken: response?.sdkToken ?? '',
        merchantReference: "Order ${DateTime.now().millisecondsSinceEpoch}",
        currency: 'SAR',
        customerIp: '175.100.133.138',
      );

      var payfortResult = payWithApplePay
          ? await _amazonPayfort.callPayFortForApplePay(
              request: request,
              applePayMerchantId: FortConstants.applePayMerchantId,
            )
          : await _amazonPayfort.callPayFort(request);

      _message = payfortResult.toMap().toString();
    } catch (e) {
      _setLoading(false);
      log(e.toString());
      _message = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _loading = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amazon Payfort Plugin Example')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_message != null)
                    Text(
                      _message ?? '',
                      textAlign: TextAlign.center,
                    ),
                  ElevatedButton(
                    onPressed: () {
                      _paymentHandler();
                    },
                    child: const Text('Pay with Card'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _paymentHandler(payWithApplePay: true);
                    },
                    child: const Text('Pay with Apple Pay'),
                  ),
                ],
              ),
      ),
    );
  }
}
