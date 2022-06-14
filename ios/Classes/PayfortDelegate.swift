import Flutter
import PayFortSDK
import CommonCrypto

public class PayFortDelegate: NSObject {
    
    private var payFort: PayFortController?
    
    public  func initialize(envType : String?){
        let environment = getEnvironmentBaseUrl(environment: envType)
        payFort = PayFortController.init(enviroment: environment)
    }
    
    
    public func getEnvironmentBaseUrl(environment :String?) -> PayFortEnviroment {
        switch (environment) {
        case ("test"):
            return PayFortEnviroment.sandBox
        case ("production"):
            return PayFortEnviroment.production
        default:
            return PayFortEnviroment.sandBox
        }
    }
    
    public func processingTransaction(requestData : Dictionary<String, Any>, viewController : UIViewController, result : @escaping ([String : Any]) -> Void){
        
        var request = [String : String]()
        request["command"] = (requestData["command"] as? String) ?? "";
        request["customer_email"] = (requestData["customer_email"] as? String) ?? "";
        request ["currency"] = (requestData["currency"] as? String) ?? "";
        request[ "amount"] = (requestData["amount"] as? String) ?? "";
        request["language"] = (requestData["language"] as? String) ?? "";
        request ["merchant_reference"] = (requestData["merchant_reference"] as? String) ?? "";
        request["order_description"] = (requestData["order_description"] as? String) ?? "";
        request["sdk_token"] = (requestData["sdk_token"] as? String) ?? "";
        request["token_name"] = (requestData["token_name"] as? String) ?? "";
        request["payment_option"] = (requestData["payment_option"] as? String) ?? "";
        request["eci"] = (requestData["eci"] as? String) ?? "";
        request["customer_ip"] = (requestData["customer_ip"] as? String) ?? "";
        request["phone_number"] = (requestData["phone_number"] as? String) ?? "";
        
        payFort?.hideLoading = false // For show loading
        payFort?.presentAsDefault = true // For Change View
        payFort?.isShowResponsePage = true // For show payment status page
        
        payFort?.callPayFort(
            withRequest: request,
            currentViewController: viewController,
            success: { requestDic, responeDic in
                
                print("Success : - \(requestDic) - \(responeDic)")
                
                var response = [String : Any]()
                response["response_status"] = 0
                responeDic.forEach { (key, value) in response[key] = value }
                return result(response)
                
            },
            canceled: { requestDic, responeDic in
                
                print("Canceled : - \(requestDic) -  \(responeDic)")
                
                var response = [String : Any]()
                response["response_status"] = 2
                responeDic.forEach { (key, value) in response[key] = value }
                return result(response)
                
            },
            faild: { requestDic, responeDic, message in
                
                print("Faild : \(message) - \(requestDic) - \(responeDic)")
                
                var response = [String : Any]()
                response["response_status"] = 1
                responeDic.forEach { (key, value) in response[key] = value }
                return result(response)
            }
        )
    }
    
    
    public func getUDID() -> String? {
        return payFort?.getUDID()
    }
    
    
    public func generateSignature(concatenatedString : String?) -> String {
        let data = ccSha256(data: concatenatedString?.data(using: .utf8))
        let signature = data.map { String(format: "%02hhx", $0) }.joined()
        return signature
    }
    
    
    func ccSha256(data: Data?) -> Data {
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digest.withUnsafeMutableBytes({ digestBytes in
            data?.withUnsafeBytes({ stringBytes in
                CC_SHA256(stringBytes, CC_LONG(data?.count ?? 0), digestBytes)
            })
        })
        return digest
    }
}

public extension PayFortEnviroment {
    
    func getUrl() -> String {
        switch (self) {
        case PayFortEnviroment.sandBox:
            return "https://sbpaymentservices.payfort.com/FortAPI/paymentApi"
        case PayFortEnviroment.production:
            return "https://paymentservices.payfort.com/FortAPI/paymentApi"
        default:
            return ""
        }
    }
    
}


