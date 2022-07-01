import 'dart:io';

import 'package:amazon_payfort/amazon_payfort.dart';
import 'package:amazon_payfort/src/local_platform.dart';
import 'package:flutter/services.dart';

import 'amazon_payfort_platform_interface.dart';

/// An implementation of [AmazonPayfortPlatform] that uses method channels.
class MethodChannelAmazonPayfort extends AmazonPayfortPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('vvvirani/amazon_payfort');

  final LocalPlatform _platform = LocalPlatform();

  @override
  Future<void> initialize(FortEnvironment environment) {
    return methodChannel.invokeMethod<void>(
      'initialize',
      <String, dynamic>{'envType': environment.name},
    );
  }

  @override
  Future<String?> getEnvironmentBaseUrl(FortEnvironment? environment) {
    return methodChannel.invokeMethod<String?>(
      'getEnvironmentBaseUrl',
      <String, dynamic>{'envType': environment?.name},
    );
  }

  @override
  Future<String?> getDeviceId() {
    String method = Platform.isIOS ? 'getUDID' : 'getDeviceId';
    return methodChannel.invokeMethod<String?>(method);
  }

  @override
  Future<String?> generateSignature({
    required String shaType,
    required String concatenatedString,
  }) {
    return methodChannel.invokeMethod<String?>(
      'generateSignature',
      <String, dynamic>{
        'shaType': shaType,
        'concatenatedString': concatenatedString
      },
    );
  }

  @override
  Future<PayfortResult> callPayFort(
      {required FortEnvironment? environment, required FortRequest request}) {
    var arguments = request.toFortRequest();
    arguments.putIfAbsent('envType', () => environment?.name);
    return methodChannel.invokeMethod('callPayFort', arguments).then((result) {
      return PayfortResult.fromMap(Map<String, dynamic>.from(result));
    });
  }

  @override
  Future<PayfortResult> callPayFortForApplePay({
    required FortEnvironment? environment,
    required FortRequest request,
    required String applePayMerchantId,
  }) {
    if (_platform.isIOS) {
      var arguments = request.toFortRequest();
      arguments.putIfAbsent('envType', () => environment?.name);
      arguments.putIfAbsent('applePayMerchantId', () => applePayMerchantId);
      return methodChannel
          .invokeMethod('callPayFortForApplePay', arguments)
          .then((result) {
        return PayfortResult.fromMap(Map<String, dynamic>.from(result));
      });
    } else {
      throw Exception('Apple Pay is not supported on this device');
    }
  }
}
