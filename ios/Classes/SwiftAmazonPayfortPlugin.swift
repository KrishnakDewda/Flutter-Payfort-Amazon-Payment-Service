import Flutter
import UIKit

public class SwiftAmazonPayfortPlugin: NSObject, FlutterPlugin, ApplePayResponseDelegateProtocol {
    
    private var result :FlutterResult? = nil
    
    private var fortDelegate = PayFortDelegate()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "vvvirani/amazon_payfort", binaryMessenger: registrar.messenger())
        
        let instance = SwiftAmazonPayfortPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        if call.method == "initialize" {
            
            if let args = call.arguments as? Dictionary<String, Any>{
                let envType = args["envType"] as? String
                fortDelegate.initialize(envType: envType)
                fortDelegate.responseDelegate = self
            }
            
        } else if call.method == "getEnvironmentBaseUrl" {
            
            if let args = call.arguments as? Dictionary<String, Any>{
                let envType = args["envType"] as? String
                let env = fortDelegate.getEnvironmentBaseUrl(environment: envType)
                result(env.getUrl())
            }
            
        } else if call.method == "getUDID" {
            
            let udid = fortDelegate.getUDID()
            result(udid)
            
        } else if call.method == "generateSignature" {
            
            if let args = call.arguments as? Dictionary<String, Any>{
                _ = args["shaType"] as? String
                let string = args["concatenatedString"] as? String
                let signature = fortDelegate.generateSignature(concatenatedString: string)
                result(signature)
            }
            
        } else if call.method == "callPayFort" {
            
            if let requestData = call.arguments as? Dictionary<String, Any>{
                let viewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
                fortDelegate.callPayFort(requestData: requestData, viewController: viewController) { response in
                    result(response)
                }
                
            }
            
        } else if call.method == "callPayFortForApplePay" {
            
            if let requestData = call.arguments as? Dictionary<String, Any>{
                let viewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
                fortDelegate.callPayFortForApplePay(requestData: requestData, viewController: viewController)
            }
            
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func onApplePayPaymentResponse(response: [String : Any]) {
        result?(response)
    }
}


