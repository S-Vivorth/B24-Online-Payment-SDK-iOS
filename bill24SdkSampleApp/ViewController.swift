
import UIKit
import bill24Sdk
import Alamofire
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var switchLanguage: UISwitch!
    @IBOutlet weak var orderRefEditText: UITextField!
    var orderRef:String!
    
    // language must be either "en" or "kh" only
    var language:String = "kh"
    
    // environment must be either "uat" or "prod" only
    let environment:String = "uat"
    
    // clientId can be obtained from bill24
    let clientId:String = "W/GkvceL7nCjOF/v+fu5MA+epIQMXMJedMeXvbvEn7I="
    
    // this url can be obtained from bill24
    let url:String = "https://checkoutapi-demo.bill24.net"
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if orderRefEditText.text != "" {
            orderRefEditText.layer.borderWidth = 0
            orderRefEditText.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        orderRefEditText.resignFirstResponder()
        self.view.endEditing(true)
        return false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if orderRefEditText.text != "" {
            orderRefEditText.layer.borderWidth = 0
            orderRefEditText.layer.borderColor = UIColor.clear.cgColor
        }
    }
    //call Sdk when checkout button is clicked
    @IBAction func button(_ sender: Any) {
        callSdk()
//        UIApplication.shared.open(URL(string: "bill24SdkSampleApp://")!, options: [:]) { success in
//
//        if !success {
//            // Open app store
//
//                UIApplication.shared.open(URL(string: "appstore")!, options: [:])
//
//        }
//    }
    }

    func callSdk() {
        if orderRefEditText.text == "" {
            orderRefEditText.layer.borderWidth = 2
            orderRefEditText.layer.borderColor = UIColor.red.cgColor
            orderRefEditText.becomeFirstResponder()
            return
        }
        orderRef = orderRefEditText.text
        
        // to create sessionId
        let parameters =
            [
                    "customer": [
                        "customer_ref": "C00001",
                        "customer_email": "example@gmail.com",
                        "customer_phone": "010801252",
                        "customer_name": "test customer"
                    ],
                    "billing_address": [
                        "province": "Phnom Penh",
                        "country": "Cambodia",
                        "address_line_2": "string",
                        "postal_code": "12000",
                        "address_line_1": "No.01, St.01, Toul Kork"
                    ],
                    "description": "Extra note",
                    "language": "kh",
                    "order_items": [
                        [
                            "item_name": "Men T-Shirt",
                            "quantity": 1,
                            "price": 1,
                            "amount": 1,
                            "item_ref": "P1001",
                            "discount_amount": 0
                        ]
                    ],
                    "payment_success_url":  "/payment/success",
                    "currency": "USD",
                    "amount": 1,
                    "pay_later_url":  "/payment/paylater",
                    "shipping_address": [
                        "province": "Phnom Penh",
                        "country": "Cambodia",
                        "address_line_2": "string",
                        "postal_code": "12000",
                        "address_line_1": "No.01, St.01, Toul Kork"
                    ],
                    "order_ref":orderRef,
                    "payment_fail_url": "payment/fail",
                    "payment_cancel_url": "payment/cancel",
                    "continue_shopping_url":  "payment/cancel"
            ] as [String : Any]
        
        // use switch to switch the language, just for demonstration purpose
        if switchLanguage.isOn == true {
            language = "kh"
        }
        else{
            language = "en"
        }
        
        let headers: HTTPHeaders = [
            "token" : "f91d077940cf44ebbb1b6abdebce0f0a",
            "Accept": "application/json"
        ]
        AF.request("\(url)/order/init", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response {
                (responseData) in
            let responded = responseData.data!
            let dict = self.convertToDictionary(text: String(data: responded, encoding: .utf8)!)
            guard let session_id = ((dict!["data"] as? [String:Any])?["session_id"] as? String) else {
                return
            }
            
            print(session_id)
            // controller is current UIViewController
            // sessionID can be get from checkout api response above
            // clientID is unique id for biller
            // language is the string that specify the language. Language can be "en" or "kh" only.
            // environment is the environment that you want to use
            // initPayLater is a function that you need to hard coded to open the paylater screen when user chooses to pay later
            // initSuccess is a function that you need to hard coded to open your payment succeeded screen when the payment is done successfully
            // we use esacping closure to call these functions
            // you may refer the sample initPayLater and initSuccess functions in below section
            
            PaymentSdk().openSdk(controller: self,sessionID: session_id, cliendID: self.clientId,language: self.language, environment: "" ){result in
                print("result::: \(result)")
            }
        }
    }

    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 10
        orderRefEditText.delegate = self
        orderRefEditText.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    func initSuccess(dict:[String:Any])
    {
            // dict is dictionary of order details
            let bundle = Bundle(for: type(of: self))
            let storyboard = UIStoryboard(name: "paymentSucceed", bundle: bundle)
            let vc:paymentSucceed = storyboard.instantiateViewController(withIdentifier: "paymentSucceed") as! paymentSucceed
            vc.payment_details = dict
            self.present(vc, animated: true, completion: nil)
        
           }
    
    func initPayLater( dict:[String:Any]){
            // dict is dictionary of order details
            let bundle = Bundle(for: type(of: self))
            let storyboard = UIStoryboard(name: "payLater", bundle: bundle)
            let vc:payLater = storyboard.instantiateViewController(withIdentifier: "payLater") as! payLater
            vc.orderDetails = dict
            self.present(vc, animated: true, completion: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
//    func openApp(appName:String) {
//
//        let appScheme = "\(appName)://app"
//        let appUrl = URL(string: appScheme)
//
//        if UIApplication.shared.canOpenURL(appUrl!) {
//            UIApplication.shared.open(appUrl!)
//        } else {
//            UIApplication.shared.open(URL(string: "calshow://app")!)
//
//        }
//
//    }

}



