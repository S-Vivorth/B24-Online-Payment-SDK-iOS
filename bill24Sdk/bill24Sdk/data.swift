//
//  data.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/12/21.
//

import Foundation
import Alamofire
import CryptoSwift
//import SocketIO

public class Data2 {
    
    var sesstionID,clientID:String
    var controller: UIViewController
    public init(sessionID:String, clientID:String,controller:UIViewController){
        self.sesstionID = sessionID
        self.clientID = clientID
        self.controller = controller

    }
    
    
    let headers: HTTPHeaders = [
        "token" : "f91d077940cf44ebbb1b6abdebce0f0a",
        "Accept": "application/json"
    ]
    
    var bankList: [String] = []
    var imageList: [String] = []
    var priceList:[String] = []
    var supportTokenize : [Any] = []
    var supportDeeplink: [Any] = []
    var bankIdList:[String] = []
    var form_data = ""
    var orderDetails:[String:Any]!
    var orderID:String!
    var rememberAccLabel:String = ""
    var paymentConfirmBtn:String = ""
    var widgetLayout:String = ""
    var selectedPaymentMethodBtn:String! = ""
    var widgetFrame:String! = ""
    var saveAccLabel:String! = ""
    var paymentMethodBtn:String! = ""
    var otpSucceeded = ""
    var data = ""
    var isEncrypteDataEmpty:Bool!
    
    var url:String = ""
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
                "language": "km",
                "order_items": [
                    [
                        "item_name": "Men T-Shirt",
                        "quantify": 1,
                        "price": 25,
                        "amount": 25,
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
                "order_ref":"String.random",
                "payment_fail_url": "payment/fail",
                "payment_cancel_url": "payment/cancel",
                "continue_shopping_url":  "payment/cancel"
        ] as [String : Any]
    

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
    public func orderInit(language:String,completion:(@escaping (Bool,String) -> Void))  {
        DispatchQueue.global().async {
            var result:InitOrder!
                let parameter1 = [
                    "encrypted_data" : "\(self.encrypt_ssID_cID())"
                ]
            let sdk_url = "\(self.url)/payment/widget-init"
            let header: HTTPHeaders = [
                "Payment-Sdk-iOS-Version" : "\(config(env: "").sdk_version)"
            ]
            AF.request(sdk_url, method: .post, parameters: parameter1, encoding: JSONEncoding.default, headers: header,interceptor: nil, requestModifier: nil).response {
                (responseData) in
                guard let responded = responseData.data else{
                    self.controller.alertError(message: "Could connect to api", language: "en", isDismissSdk: true)
                    return
                }
                print(responseData)
                
                print(responseData.response?.statusCode)
                print(String(data: responded, encoding: .utf8))
                    
                    do {
                        print("responded::: \(responded)")
                        result = try JSONDecoder().decode(InitOrder.self, from: responded)
                        let start = DispatchTime.now()
                        if (result.result.resultCode == "000") {
                            let decrypted_data = self.decrypt_result(base64Sting: result.data.encryptedData,completion: {
                                let end = DispatchTime.now()
                                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                                    let timeInterval = Double(nanoTime) / 1_000_000_000
                            })
                            
                            let str = decrypted_data
                            var dict: [String:Any]
                            dict = self.convertToDictionary(text: str)!
                            if (dict["style"] as! NSDictionary == [:]){
                                self.controller.alertError(message: "Invalid config style", language: "en", isDismissSdk: true)
                                return
                            }
                            print(dict["payment_methods"]!)
                            self.orderID = ((dict["order_detail"] as! [String:Any])["order_id"] as! String)
                            self.setRememberAccLabel(dict: dict)
                            self.setpaymentConfirmBtn(dict: dict)
                            self.setSelectedPaymentMethodbtn(dict: dict)
                            self.setWidgetFrame(dict: dict)
                            if (dict["existing_accounts"] as! NSArray).count != 0 {
                                self.setSaveAccountLabel(dict: dict)
                            }
                            else{
                                self.saveAccLabel = ""
                            }
                            self.setPaymentMethodBtn(dict: dict)
                            self.orderDetails = dict["order_detail"]! as! [String : Any]
                            let existing_acc: NSArray = dict["existing_accounts"]! as! NSArray
                            if(existing_acc.count==0){
                                print("no existing acc")
                            }
                            else{
                                print(type(of: existing_acc))
                                print(existing_acc.count)
                            }
                            for item in (dict["payment_methods"] as! NSArray) {
                                let bank:Any!
                                if language == "en" {
                                    bank = (item as! NSDictionary).value(forKey: "bank_name_en")! as! String
                                }
                                else {
                                    let flagBank = (item as! NSDictionary).value(forKey: "bank_name_kh")! as! String
                                    if flagBank == "" {
                                        bank = (item as! NSDictionary).value(forKey: "bank_name_en")! as! String
                                    }
                                    else{
                                        bank = (item as! NSDictionary).value(forKey: "bank_name_kh")! as! String
                                    }
                                }
                                
                                let bank_image:Any = (item as! NSDictionary).value(forKey: "bank_logo")! as! String
                                let price:Any = String(describing: (item as! NSDictionary).value(forKey: "fee")!)
                                let bankID:Any = (item as! NSDictionary).value(forKey: "bank_id")! as! String
                                if(bankID as! String != "pay_later"){
                                    let currency:Any = String(describing: (item as! NSDictionary).value(forKey: "currency")!) as! String
                                    if "\(price)" == "0" {
                                        self.priceList.append("\(price).00 \(currency)")

                                    }
                                    else{
                                        let slice_price = "\(price)0".prefix(4)
                                        self.priceList.append("\(slice_price) \(currency)")

                                    }
                                    let tokenize:Any = String(describing: (item as! NSDictionary).value(forKey: "support_tokenize")!) as! String
                                    
                                    self.supportTokenize.append(tokenize)
                                    let deeplink:Any = String(describing: (item as! NSDictionary).value(forKey: "support_deeplink")!) as! String
                                    self.supportDeeplink.append(deeplink)
                                    
                                }
                                else{
                                    self.supportDeeplink.append("")
                                    self.supportTokenize.append("")
                                    self.priceList.append("")
                                }
                                self.bankList.append(bank as! String)
                                
                                self.imageList.append(bank_image as! String)
                                self.bankIdList.append(bankID as! String)
                            }
    //                        if dict["order_detail"]! != nil {
    //                            self.bankList.append("Agent / Bank Counter")
    //                            self
    //                        }
                            if(existing_acc.count>0){
                                if language == "en"{
                                    self.bankList.append(((dict["style"] as! [String:Any])["saved_account_label"] as! [String:Any])["display_text_en"] as! String)
                                }
                                else{
                                    self.bankList.append(((dict["style"] as! [String:Any])["saved_account_label"] as! [String:Any])["display_text_kh"] as! String)
                                }
                                
                                
                                self.imageList.append("")
                                self.priceList.append("")
                                for item in existing_acc {
                                    
                                    let bank:Any!
                                    if language == "en" {
                                        
                                        bank = (item as! NSDictionary).value(forKey: "bank_name_en")! as! String
                                        
                                    }
                                    else {
                                        let flagBank = (item as! NSDictionary).value(forKey: "bank_name_kh")! as! String
                                        if flagBank == "" {
                                            bank = (item as! NSDictionary).value(forKey: "bank_name_en")! as! String
                                        }
                                        else{
                                            bank = (item as! NSDictionary).value(forKey: "bank_name_kh")! as! String
                                        }
                                        
                                    }

                                    let bank_image:Any = (item as! NSDictionary).value(forKey: "bank_logo")! as! String

                                    let account_no:Any = String(describing: (item as! NSDictionary).value(forKey: "account_no")!)
                                    let bankID:Any = (item as! NSDictionary).value(forKey: "bank_id")! as! String
                                    let tokenizeID: Any = (item as! NSDictionary).value(forKey: "tokenize_id")! as! String
                                    let bankIDandTokenizeID = "\(bankID)$$$\(tokenizeID)"
                                    self.bankList.append(bank as! String)
                                    self.imageList.append(bank_image as! String)
                                    self.priceList.append(account_no as! String)
                                    self.bankIdList.append(bankIDandTokenizeID as! String)
                                }
                            }

                            completion(true,"")
                        }
                        else{
                            if language == "en" {
                                completion(false, result.result.resultMessageEn)
                            }
                            else{
                                completion(false, result.result.resultMessageKh)
                            }
                        }
     

                        
                    }
                    catch {
                        print("error: \(error)")
                    }
                    }
        }


            
            }
    
    
    
    func tokenizeValidate(bankID:String, tokenizeID:String,language:String, completion: (@escaping (Int,Int,String,String,String) -> Void)) {
        var result:InitOrder!
        let tokenizeValidation = [
            "encrypted_data" : "\(encryptTokenizeValidation(bankID: bankID, tokenizeID: tokenizeID))"
        ]
        let sdk_url = "\(self.url)/tokenize/validate"
        AF.request(sdk_url, method: .post, parameters: tokenizeValidation, encoding: JSONEncoding.default).response {
            (responseData) in
            guard let responded = responseData.data else{
                self.controller.alertError(message: "Could connect to api", language: "en")
                return
            }
        do {
            result = try JSONDecoder().decode(InitOrder.self, from: responded)
            let start = DispatchTime.now()
            let responsesDict = self.convertToDictionary(text: String(data: responded, encoding: .utf8)!)
            let result_code = (responsesDict!["result"] as! [String:Any])["result_code"] as! String
            if result_code != "000" {
                if language == "en" {
                    completion(0,0,"",(responsesDict!["result"] as! [String:Any])["result_code"] as! String,(responsesDict!["result"] as! [String:Any])["result_message_en"] as! String)
                }
                else{
                    completion(0,0,"",(responsesDict!["result"] as! [String:Any])["result_code"] as! String,(responsesDict!["result"] as! [String:Any])["result_message_kh"] as! String)
                }
            }
            else{
                let decrypted_data = self.decrypt_result(base64Sting: result.data.encryptedData,completion: {
                    let end = DispatchTime.now()
                    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                        let timeInterval = Double(nanoTime) / 1_000_000_000
                })
                let dict: [String:Any]
                dict = self.convertToDictionary(text: decrypted_data)!

                if language == "en" {
                    completion(dict["allow_resend_time"] as! Int,dict["expiry_time"] as! Int,dict["validate_token"] as! String,(responsesDict!["result"] as! [String:Any])["result_code"] as! String,(responsesDict!["result"] as! [String:Any])["result_message_en"] as! String)
                }
                else{
                    completion(dict["allow_resend_time"] as! Int,dict["expiry_time"] as! Int,dict["validate_token"] as! String,(responsesDict!["result"] as! [String:Any])["result_code"] as! String,(responsesDict!["result"] as! [String:Any])["result_message_kh"] as! String)
                }

            }

        }
        catch {
            print("error")
        }
        }
    }
    func initPayment(bankID: String,saveAcc:Bool,language:String, userAgent:String, completion: (@escaping (String,Bool,String) -> Void)){
        var result:InitOrder!

        let initPaymentPayload = [
            "encrypted_data" : "\(encrypt_initPayment(bankID: bankID, saveAcc: saveAcc, userAgent: userAgent))"
        ]
        
        let sdk_url = "\(self.url)/payment/init"
        AF.request(sdk_url, method: .post, parameters: initPaymentPayload, encoding: JSONEncoding.default).response {
            (responseData) in
            guard let responded = responseData.data else{
                self.controller.alertError(message: "Could connect to api", language: "en")
                return
            }
            print(responseData)
        print(responseData.response?.statusCode)
        print(String(data: responded, encoding: .utf8))
            do {
                result = try JSONDecoder().decode(InitOrder.self, from: responded)
                let start = DispatchTime.now()

                    if result.result.resultStatus == "SUCCESS" {
                        print("statussss")
                        let decrypted_data = self.decrypt_result(base64Sting: result.data.encryptedData,completion: {
                            
                            let end = DispatchTime.now()
                            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                                let timeInterval = Double(nanoTime) / 1_000_000_000
                            print("execution time is: \(timeInterval)s")
                        })
                        print("\(decrypted_data)")
                        let str = decrypted_data
                        let dict: [String:Any]
                        dict = self.convertToDictionary(text: str)!
                        print(dict["checkout_data"]!)
                        let form_data:String = self.decrypt_result(base64Sting: dict["checkout_data"]! as! String, completion: {
                            
                        })
                        print("form_data: \(form_data)")
                        
                        completion(form_data,true,"")
                    }
                    else{
                        print("statussss failed")

                        if language == "en" {
                            completion(self.form_data,false, result.result.resultMessageEn)
                        }
                        else{
                            completion(self.form_data,false, result.result.resultMessageKh)
                        }
                    
                    }
                
            }
            catch {
                print("error")
            }
        }
    }
    func resendTokenize(clientID:String,bankID:String,sessionId:String, validateToken:String,completion: (@escaping (Int,Int,String) -> Void)){
        var result:InitOrder!
        print("validateToken: \(validateToken)")
        let resendtoken = [
            "encrypted_data" : "\(encryptResendTokenize(bankID: bankID, clientID: clientID, sessionID: sessionId, validateToken: validateToken))"
        ]
        print("resendtoken: \(resendtoken)")
        let sdk_url = "\(self.url)/tokenize/resend-otp"
        AF.request(sdk_url, method: .post, parameters: resendtoken, encoding: JSONEncoding.default).response {
            (responseData) in
            guard let responded = responseData.data else{
                self.controller.alertError(message: "Could connect to api", language: "en")
                return
            }
            print("respondeddd: \(responded)")
            print("metrics: \(String(describing: responseData.metrics))")
            print(responseData)
        print(responseData.response?.statusCode)
        print(String(data: responded, encoding: .utf8)!)
        do {
            result = try JSONDecoder().decode(InitOrder.self, from: responded)
            let start = DispatchTime.now()
            
            let decrypted_data = self.decrypt_result(base64Sting: result.data.encryptedData,completion: {
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                print("execution time is: \(timeInterval)s")
            })
            let dict: [String:Any]
            dict = self.convertToDictionary(text: decrypted_data)!
            print(dict)
            print("Otppp: \(dict["expiry_time"]!)")
            
            
            
            completion(1,2,"asd")
//                print(form_data)
            
            
        }
        catch {
            print(error)
        }
        }
    }
    func cfTokenize(sessionId:String,validateToken:String,otp:String,clientID:String,bankID:String,wrongOtp:@escaping (String)->Void,language:String,completion: (([String:Any]) -> Void)?){
        var result:InitOrder!
        let initPaymentPayload = [
            "encrypted_data" : "\(encrypt_CfTokenize(sessionId: sessionId, validateToken: validateToken, otp: otp,clientID: clientID,bankId: bankID))"
        ]
        print(initPaymentPayload)
        let sdk_url = "\(self.url)/tokenize/confirm"
        AF.request(sdk_url, method: .post, parameters: initPaymentPayload, encoding: JSONEncoding.default).response {
            (responseData) in
            guard let responded = responseData.data else{
                self.controller.alertError(message: "Could connect to api", language: "en")
                return
            }
            print("metrics: \(responseData.metrics)")
            print(responseData)
        print(responseData.response?.statusCode)
        let responses = String(data: responded, encoding: .utf8)
            print("responses: \(responses)")
            let responsesDict = self.convertToDictionary(text: responses!)
            print("ResponseDict: \(responsesDict)")
            let result_status = (responsesDict!["result"] as! [String:Any])["result_status"] as! String
            let result_message:String!
            if language == "en" {
                result_message = (responsesDict!["result"] as! [String:Any])["result_message_en"] as! String
            }
            else{
                result_message = (responsesDict!["result"] as! [String:Any])["result_message_kh"] as! String
            }
            print(result_status)
            if result_status == "ERR_VERIFY_FAILED"
            {
                wrongOtp(result_message)
            }
            else{
                do {
                    result = try JSONDecoder().decode(InitOrder.self, from: responded)
                    let decrypted_data = self.decrypt_result(base64Sting: result.data.encryptedData,completion: {
                    })
                    
                    print("\(decrypted_data)")
                    let str = decrypted_data
                    let dict: [String:Any]
                    dict = self.convertToDictionary(text: str)!
                    print("Confirm Tokenize: \(dict)")

                    self.otpSucceeded = "Succeeded"
                    completion!(dict)

                    
                }
                catch {
                    print("error")
                }
            }
        print(String(data: responded, encoding: .utf8))
        }
    }
    func setRememberAccLabel(dict:[String: Any]){
        let style = dict["style"]
        let text_color = ((style as! [String:Any])["remember_account_label"] as! [String:Any])["text_color"] as! String
        let display_text_en = ((style as! [String:Any])["remember_account_label"] as! [String:Any])["display_text_en"] as! String
        let display_text_kh = ((style as! [String:Any])["remember_account_label"] as! [String:Any])["display_text_kh"] as! String
        rememberAccLabel = "\(text_color),\(display_text_en),\(display_text_kh)"
        
        print("rememberAccLabel: \(rememberAccLabel)")
        
    }
    
    func setpaymentConfirmBtn(dict:[String:Any]){
        let style = dict["style"]
        let shadow_color = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["shadow_color"] as! String
        let border_color = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["border_color"] as! String
        let border_size = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["border_size"] as! String
        let text_color = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["text_color"] as! String
        let radius = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["radius"] as! String
        let shadow_size = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["shadow_size"] as! String
        let background_color = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["background_color"] as! String
        let display_text_en = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["display_text_en"] as! String
        let display_text_kh = ((style as! [String:Any])["payment_confirm_button"] as! [String:Any])["display_text_kh"] as! String
        paymentConfirmBtn = "\(shadow_color),\(border_color),\(border_size),\(text_color),\(radius),\(shadow_size),\(background_color),\(display_text_en),\(display_text_kh)"
        print("paymentConfirmBtn: \(paymentConfirmBtn)")
    }
    
    func setSelectedPaymentMethodbtn(dict: [String:Any]){
        let style = dict["style"]
        let border_color = ((style as! [String:Any])["selected_payment_method_button"] as! [String:Any])["border_color"] as! String
        let background_color = ((style as! [String:Any])["selected_payment_method_button"] as! [String:Any])["background_color"] as! String
        let border_size = ((style as! [String:Any])["selected_payment_method_button"] as! [String:Any])["border_size"] as! String
        let text_color = ((style as! [String:Any])["selected_payment_method_button"] as! [String:Any])["text_color"] as! String
        
        selectedPaymentMethodBtn = "\(border_color),\(background_color),\(border_size),\(text_color)"
        print("selectedPaymentMethodBtn: \(selectedPaymentMethodBtn)")
    }
    func setWidgetFrame(dict: [String:Any]){
        let style = dict["style"]
        let shadow_color = ((style as! [String:Any])["widget_frame"] as! [String:Any])["shadow_color"] as! String
        let payment_method_widget_visible = ((style as! [String:Any])["widget_frame"] as! [String:Any])["payment_method_widget_visible"] as! Bool
        let payment_confirm_widget_visible = ((style as! [String:Any])["widget_frame"] as! [String:Any])["payment_confirm_widget_visible"] as! Bool
        let border_color = ((style as! [String:Any])["widget_frame"] as! [String:Any])["border_color"] as! String
        let border_size = ((style as! [String:Any])["widget_frame"] as! [String:Any])["border_size"] as! String
        let padding = ((style as! [String:Any])["widget_frame"] as! [String:Any])["padding"] as! String
        let radius = ((style as! [String:Any])["widget_frame"] as! [String:Any])["radius"] as! String
        let shadow_size = ((style as! [String:Any])["widget_frame"] as! [String:Any])["shadow_size"] as! String
        let background_color = ((style as! [String:Any])["widget_frame"] as! [String:Any])["background_color"] as! String
        
        widgetFrame = "\(shadow_color),\(payment_method_widget_visible),\(payment_confirm_widget_visible),\(border_color),\(border_size),\(padding),\(radius),\(shadow_size),\(background_color)"
        print("widgetFrame: \(widgetFrame)")
    }
    func setSaveAccountLabel(dict:[String:Any]){
        let style = dict["style"]
        let display_text_en = ((style as! [String:Any])["saved_account_label"] as! [String:Any])["display_text_en"] as! String
        let text_color = ((style as! [String:Any])["saved_account_label"] as! [String:Any])["text_color"] as! String
        let display_text_kh = ((style as! [String:Any])["saved_account_label"] as! [String:Any])["display_text_kh"] as! String
        saveAccLabel = "\(display_text_en),\(text_color),\(display_text_kh)"
        print("saveAccLabel: \(saveAccLabel)")
    }
    func setPaymentMethodBtn(dict: [String:Any]){
        let style = dict["style"]
        let shadow_color = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["shadow_color"] as! String
        let icon_border_color = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["icon_border_color"] as! String
        let icon_radius = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["icon_radius"] as! String
        let border_color = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["border_color"] as! String
        let icon_border_size = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["icon_border_size"] as! String
        let border_size = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["border_size"] as! String
        let text_color = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["text_color"] as! String
        let convenience_fee_visible = (((style as! [String:Any])["payment_method_button"] as! [String:Any])["convenience_fee_visible"] as! Bool)
        let icon_shadow_color = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["icon_shadow_color"] as! String
        let radius = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["radius"] as! String
        let icon_shadow_size = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["icon_shadow_size"] as! String
        let shadow_size = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["shadow_size"] as! String
        let background_color = ((style as! [String:Any])["payment_method_button"] as! [String:Any])["background_color"] as! String
        paymentMethodBtn = "\(shadow_color),\(icon_border_color),\(icon_radius),\(border_color),\(icon_border_size),\(border_size),\(text_color),\(convenience_fee_visible),\(icon_shadow_color),\(radius),\(icon_shadow_size),\(shadow_size),\(background_color)"
        print("paymentMethodBtn: \(paymentMethodBtn)")
        
    }
        
//        AF.request("https://checkoutapi-demo.bill24.net/order/init", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil)
        func encrypt_ssID_cID() -> String{
            print("Execution Start: \(NSDate())")
            let password: [UInt8] = Array("sdkdev".utf8)
            let salt: [UInt8] = Array("salt".utf8)
            /* Generate a key from a `password`. Optional if you already have a key */
            let key = try!
                PKCS5.PBKDF2(
                    
                    password: password,
                    salt: salt,
                    iterations: 100,
                    keyLength: 16, /* AES-256 */
                    variant: .sha1
                ).calculate()
//            print(key)
            
            let keyString = key.toHexString()
            
//            print("Password to hexa: \(password.toHexString())")
//            print("Salt to hexa: \(salt.toHexString())")
//            print("key \(String(keyString.prefix(16)))")
            /* Generate random IV value. IV is public value. Either need to generate, or get it from elsewhere */
            let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
            
//            print(iv)
            //         AES cryptor instance
            
            do {
                var data_tobe_encrypted =
                    "{\"session_id\": \"\(sesstionID)\",\"client_id\": \"\(clientID)\"}"
                let aes = try AES(key: key, blockMode: CBC(iv: iv))
                let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
            //            let encryptedString = String(decoding: encryptedData, as: UTF8.self)
            
//                print("Encrypted Data \(encryptedData)")
            //            print("Encrypted Data \(encryptedString)")
                let base64String = encryptedData.toBase64()
                print("base64String: \(base64String)")
                print("End of execution: \(NSDate())")
                return base64String
            }
            catch{
                print(error)
                return ""
            }
        }
    
    func encryptResendTokenize(bankID:String,clientID:String,sessionID:String,validateToken:String)->String{
        let password: [UInt8] = Array("sdkdev".utf8)
        let salt: [UInt8] = Array("salt".utf8)
        /* Generate a key from a `password`. Optional if you already have a key */
        let key = try!
            PKCS5.PBKDF2(
                password: password,
                salt: salt,
                iterations: 100,
                keyLength: 16, /* AES-256 */
                variant: .sha1
            ).calculate()
        let keyString = key.toHexString()
        let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
        do {
            
            var data_tobe_encrypted =
                "{\"session_id\": \"\(sesstionID)\",\"bank_id\": \"\(bankID)\",\"client_id\": \"\(clientID)\",\"validate_token\": \(validateToken)}"
            print("data_tobe_encrypted: \(data_tobe_encrypted)")
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
            let base64String = encryptedData.toBase64()
            print("End of execution: \(NSDate())")
            return base64String
        }
        catch{
            print(error)
            return ""
        }

    }
    func encryptTokenizeValidation(bankID:String,tokenizeID:String) -> String {
        let password: [UInt8] = Array("sdkdev".utf8)
        let salt: [UInt8] = Array("salt".utf8)
        /* Generate a key from a `password`. Optional if you already have a key */
        let key = try!
            PKCS5.PBKDF2(
                password: password,
                salt: salt,
                iterations: 100,
                keyLength: 16, /* AES-256 */
                variant: .sha1
            ).calculate()
        let keyString = key.toHexString()
        let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
        do {
            
            var data_tobe_encrypted =
                "{\"session_id\": \"\(sesstionID)\",\"bank_id\": \"\(bankID)\",\"client_id\": \"\(clientID)\",\"tokenize_id\": \(tokenizeID)}"
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
            let base64String = encryptedData.toBase64()
            print("End of execution: \(NSDate())")
            return base64String
        }
        catch{
            print(error)
            return ""
        }
        
    }
    
    func encrypt_CfTokenize(sessionId:String,validateToken:String,otp:String,clientID:String,bankId:String) -> String{
        let password: [UInt8] = Array("sdkdev".utf8)
        let salt: [UInt8] = Array("salt".utf8)
        /* Generate a key from a `password`. Optional if you already have a key */
        let key = try!
            PKCS5.PBKDF2(
                password: password,
                salt: salt,
                iterations: 100,
                keyLength: 16, /* AES-256 */
                variant: .sha1
            ).calculate()
        let keyString = key.toHexString()
        let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
        do {
            
            var data_tobe_encrypted =
                "{\"session_id\": \"\(sessionId)\",\"validate_token\": \"\(validateToken)\",\"otp\": \"\(otp)\",\"client_id\":\"\(clientID)\",\"bank_id\":\"\(bankId)\"}"
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
            let base64String = encryptedData.toBase64()
            print("End of execution: \(NSDate())")
            return base64String
        }
        catch{
            print(error)
            return ""
        }
    }
    
    
    func encrypt_initPayment(bankID:String,saveAcc:Bool, userAgent: String) ->String{
        let password: [UInt8] = Array("sdkdev".utf8)
        let salt: [UInt8] = Array("salt".utf8)
        /* Generate a key from a `password`. Optional if you already have a key */
        let key = try!
            PKCS5.PBKDF2(
                password: password,
                salt: salt,
                iterations: 100,
                keyLength: 16, /* AES-256 */
                variant: .sha1
            ).calculate()
        let keyString = key.toHexString()
        let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
        do {
            
            var data_tobe_encrypted =
                "{\"session_id\": \"\(sesstionID)\",\"bank_id\": \"\(bankID)\",\"client_id\": \"\(clientID)\",\"remember_acc\": \(saveAcc),\"user_agent\": \"\(userAgent)\"}"
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
            let base64String = encryptedData.toBase64()
            print("End of execution: \(NSDate())")
            return base64String
        }
        catch{
            print(error)
            return ""
        }

    }
        func decrypt_result(base64Sting:String,completion: (() -> Void)?) -> String{
            let password: [UInt8] = Array("sdkdev".utf8)
            let salt: [UInt8] = Array("salt".utf8)
            /* Generate a key from a `password`. Optional if you already have a key */
            let key = try!
                PKCS5.PBKDF2(
                    password: password,
                    salt: salt,
                    iterations: 100,
                    keyLength: 16, /* AES-256 */
                    variant: .sha1
                ).calculate()
            let keyString = key.toHexString()
            let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
            do {
                let aes = try AES(key: key, blockMode: CBC(iv: iv))
                guard let data = Data(base64EncodedURLSafe: base64Sting) else {
                    // handle errors in decoding base64 string here
                    throw NSError()
                }//
                let bytes = data.map { $0 }
                guard let decryption = try? aes.decrypt(bytes) else { return "Bank Error" } // when reponse code is 200(our api) but error from the bank => encrypted_data: "" => cannot decrypt => we use try? to set it as optional and return "Bank Error"
                let decrypted = String(bytes: decryption, encoding: .utf8)
//                print("Decrypted Data \(decrypted)")
                completion!()
                return decrypted ?? ""
            }
            catch{
                print(error)
                return ""
            }
        }

    }

    extension Data {
        init?(base64EncodedURLSafe string: String, options: Base64DecodingOptions = []) {
            let string = string
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            self.init(base64Encoded: string, options: options)
        }
    }

    extension Array where Element == UInt8 {
     func bytesToHex(spacing: String) -> String {
       var hexString: String = ""
       var count = self.count
       for byte in self
       {
           hexString.append(String(format:"%02X", byte))
           count = count - 1
           if count > 0
           {
               hexString.append(spacing)
           }
       }
       return hexString
    }
    }
