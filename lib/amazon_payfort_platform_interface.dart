import 'package:amazon_payfort/amazon_payfort.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amazon_payfort_method_channel.dart';

abstract class AmazonPayfortPlatform extends PlatformInterface {
  /// Constructs a AmazonPayfortPlatform.
  AmazonPayfortPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmazonPayfortPlatform _instance = MethodChannelAmazonPayfort();

  /// The default instance of [AmazonPayfortPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmazonPayfort].
  static AmazonPayfortPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmazonPayfortPlatform] when
  /// they register themselves.
  static set instance(AmazonPayfortPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize(FortEnvironment environment);

  Future<String?> getEnvironmentBaseUrl(FortEnvironment? environment);

  Future<String?> getDeviceId();

  Future<String?> generateSignature({
    required String shaType,
    required String concatenatedString,
  });

  Future<PayfortResult> callPayFort({
    required FortEnvironment? environment,
    required FortRequest request,
  });

  Future<PayfortResult> callPayFortForApplePay({
    required FortEnvironment? environment,
    required FortRequest request,
    required String applePayMerchantId,
  });
}
