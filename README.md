# iOS Sdk sample app

> Instructions for the billers to integrate bill24 iOS sdk.

## Table of contents

* Compatiblility
* Setup
* Usage
* Contacta

## Compatiblility
- Support from iOS version 11+ .

## Setup
* **Step 1**

Download bill24 sdk from [this link](https://gitlab.bill24.net/Vivorth/ios-sdk-sample-app/-/raw/master/bill24Sdk.framework.zip).

* **Step 2**

Extract the zip and you will get bill24Sdk.framework

![step 2](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.29.34%20PM.jpg?raw=true)


* **Step 3**

Drag bill24sdk.framework into your project.

![step 3](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.08.17%20PM.jpg?raw=true)


![step 3](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.44.58%20PM.jpg?raw=true)


* **Step 4**

Make sure you link framework in frameworks section and link binary with libraries section.

![step 4](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.09.02%20PM.jpg?raw=true)


![step 4](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.09.24%20PM.jpg?raw=true)


* **Step 5**

Add require cocoapods:
```gradle
    	pod 'Alamofire', '5.4'
	pod 'CryptoSwift', '1.4.1'
	pod 'Socket.IO-Client-Swift'
```

## Usage

In your checkout screen:

**Swift**
```swift
func callSdk() {

        //just for demonstration purpose
        if orderRefEditText.text == "" {
            orderRefEditText.layer.borderWidth = 2
            orderRefEditText.layer.borderColor = UIColor.red.cgColor
            orderRefEditText.becomeFirstResponder()
            return
        }
        orderRef = orderRefEditText.text
        
        // to create sessionId and pass it to the sdk
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
                    "order_ref": "\(your order reference)",
                    "payment_fail_url": "payment/fail",
                    "payment_cancel_url": "payment/cancel",
                    "continue_shopping_url":  "payment/cancel"
            ] as [String : Any]
        
        // use switch to switch the language, just for demonstration purpose. You may ignore this line and pass language directly
        if switchLanguage.isOn == true {
            language = "kh"
        }
        else{
            language = "en"
        }
        
        let headers: HTTPHeaders = [
            "token" : "\(unique token)",
            "Accept": "application/json"
        ]
        AF.request("\(url)/order/init", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response {
                (responseData) in
            let responded = responseData.data!
            let dict = self.convertToDictionary(text: String(data: responded, encoding: .utf8)!)
            guard let session_id = ((dict!["data"] as! [String:Any])["session_id"] as? String) else {
                return
            }
            
            // controller is current UIViewController
            // sessionID can be get from checkout api response above
            // clientID is unique id for biller
            // language is the string that specify the language. Language can be "en" or "kh" only.
            // environment is the environment that you want to use
            // initPayLater is a function that you need to hard coded to open the paylater screen when user chooses to pay later
            // initSuccess is a function that you need to hard coded to open your payment succeeded screen when the payment is done successfully
            // we use esacping closure to call these functions
            // you may refer the sample initPayLater and initSuccess functions in below section
            
            BottomSheetAnimation().openSdk(controller: self,sessionID: session_id, cliendID: self.clientId,language: self.language,environment: self.environment){order_details in
                // we use escaping closure
                self.initPayLater(dict: order_details)
            } initPaySuccess: { order_details in
                // we use escaping closure
                self.initSuccess(dict: order_details)
            }
        }
    }
    func initSuccess(dict:[String:Any])
    {
            // dict is dictionary of order details
            let bundle = Bundle(for: type(of: self))
            //your storyboard
            let storyboard = UIStoryboard(name: "paymentSucceed", bundle: bundle)
            let vc:paymentSucceed = storyboard.instantiateViewController(withIdentifier: "paymentSucceed") as! paymentSucceed
            vc.payment_details = dict
            self.present(vc, animated: true, completion: nil)
        
           }
    
    func initPayLater( dict:[String:Any]){
            // dict is dictionary of order details
            let bundle = Bundle(for: type(of: self))
            //your storyboard
            let storyboard = UIStoryboard(name: "payLater", bundle: bundle)
            let vc:payLater = storyboard.instantiateViewController(withIdentifier: "payLater") as! payLater
            vc.orderDetails = dict
            self.present(vc, animated: true, completion: nil)
    }
```


Where:
* **controller** is current UIViewController
* **sessionID** can be get from checkout api response above
* **clientID** is unique id for biller
* **language** is the string that specify the language. Language can be "en" or "kh" only.
* **environment** is the environment that you want to use
* **initPayLater** is a function that you need to hard coded to open the paylater screen when user chooses to pay later
* **initSuccess** is a function that you need to hard coded to open your payment succeeded screen when the payment is done successfully
* You may also refer our sample initPayLater and initPaySuccess functions.

In payment succeeded screen, to verify transaction you have to:

```swift
        let headers: HTTPHeaders = [
            "token" : "f91d077940cf44ebbb1b6abdebce0f0a",
            "Accept": "application/json"
        ]
        
        // payment_details will be initialized during we open the screen
        let tran_id = (payment_details!["tran_data"] as! [String:Any])["trans_id"] as! String
        print(tran_id)
        let parameters = [
            "tran_id": "\(tran_id)"
        ]
        AF.request("\(url)/transaction/verify", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { responseData in
            print("codeee :\(responseData.response?.statusCode)")
            print(String(data: responseData.data!, encoding: .utf8))
            guard let dict = self.convertToDictionary(text: String(data: responseData.data!, encoding: .utf8)!) else{
                return
            }
            self.totalPrice.text = String((dict["data"] as! [String:Any])["total_amount"] as! Double)
            let date = ((dict["data"] as! [String:Any])["tran_date"] as! String)
            let date_split = date.split(separator: ".")
            self.transactionDate.text = "\(date_split[0])"
            self.transactionID.text = (dict["data"] as! [String:Any])["bank_reference_no"] as! String
            self.fee.text = String((dict["data"] as! [String:Any])["fee_amount"] as! Double)
            self.paymentMethod.text = (self.payment_details["tran_data"] as! [String:Any])["bank_name_en"] as! String
            self.subTotal.text = String((dict["data"] as! [String:Any])["tran_amount"] as! Double)
            self.orderRef.text = "Order #\((self.payment_details["tran_data"] as! [String:Any])["order_ref"] as! String)"
```

Congratulations, you are ready to use the SDK.

## Contact
Created by
[@bill24 team](vivorth.san@ubill24.com) - feel free to contact me!















