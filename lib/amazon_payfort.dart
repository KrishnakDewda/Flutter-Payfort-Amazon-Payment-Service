import 'package:amazon_payfort/amazon_payfort_platform_interface.dart';
import 'package:amazon_payfort/src/enums/fort_environment.dart';
import 'package:amazon_payfort/src/models/fort_request.dart';
import 'package:amazon_payfort/src/models/pay_fort_result.dart';

export 'src/enums/fort_environment.dart';
export 'src/enums/response_status.dart';

export 'src/models/pay_fort_result.dart';
export 'src/models/sdk_token_request.dart';
export 'src/models/fort_request.dart';

/// Amazon Payment Services is the new name for PayFort.
/// PayFort is a leading provider of payment processing services that was acquired by Amazon in 2017.
/// Throughout this section, and in our API reference and SDK guides, you will see reference to PayFort. You may also see reference to Fort or FORT.
/// We continue to use PayFort and Fort in our documentation for the simple reason
/// that the code that powers Amazon Payment Services still contains references to PayFort.
/// To ensure ongoing stability, and to minimize the development overhead for our customers,
/// we are slowly but steadily changing references to PayFort across our core code and our documentation.
/// In the meantime, when you see PayFort or Fort,
/// you can safely assume that we are referring to Amazon Payment Services features and benefits.
///
class AmazonPayfort {
  AmazonPayfort._();

  factory AmazonPayfort() {
    assert(
      _instance != null,
      '\nEnsure to initialize AmazonPayfort before accessing it.\nPlease execute the init method : AmazonPayfort.initialize()',
    );
    return _instance ?? AmazonPayfort._();
  }

  static AmazonPayfort? _instance;
  static AmazonPayfort get instance => _instance ?? AmazonPayfort._();

  FortEnvironment? _environment;

  static void initialize(

      /// This parameter used to determine whether the request is going to be submitted to the test/sandbox or production environment.
      /// It has two possible values:
      /// - FortEnvironment.test / sandbox
      /// - FortEnvironment.production
      FortEnvironment fortEnvironment) async {
    _instance ??= AmazonPayfort._();
    _instance?._environment = fortEnvironment;

    /// Initialize the Payfort with the environment.
    ///
    AmazonPayfortPlatform.instance.initialize(fortEnvironment);
  }

  /// These are the URLs you need to use when you request a mobile SDK token for your app:
  ///
  Future<String?> getEnvironmentBaseUrl() {
    return AmazonPayfortPlatform.instance.getEnvironmentBaseUrl(_environment);
  }

  /// Please make sure to use the following function to generate the [device_id] parameter value that
  /// must be used for creating the sdk_token from your business security server:
  ///
  Future<String?> getDeviceId() {
    return AmazonPayfortPlatform.instance.getDeviceId();
  }

  /// The Signature is a parameter that holds the digital signature value calculated by the SHA algorithm.
  /// The digital signature is used to authenticate the sender and receiver of the message and allows
  /// the receiver to verify the integrity of the message.
  ///
  Future<String?> generateSignature({
    required String shaType,
    required String concatenatedString,
  }) {
    return AmazonPayfortPlatform.instance.generateSignature(
      shaType: shaType,
      concatenatedString: concatenatedString,
    );
  }

  /// Standard payment screen.
  /// You can use the standard Amazon Payment Services mobile SDK interface to display a standard payment screen.
  /// This standard payment view is customizable in three ways.
  ///
  Future<PayfortResult> processingTransaction(FortRequest request) {
    return AmazonPayfortPlatform.instance.processingTransaction(
      environment: _environment,
      request: request,
    );
  }
}
