//
//  Otp.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/17/21.
//

import UIKit
import CryptoSwift
import Alamofire
import SocketIO
class Otp: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var resend: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var bankLogo: UIImageView!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var bankNo: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var function: (([String:Any]) -> Void)!
    var bankImage:String!
    var bankName:String!
    var bankNumber:String!
    var bankImageRadius:String!
    var verifyBtnBorderColor: CGColor!
    var verifyBtnCornerRadius: CGFloat!
    var verifyBtnBorderWithd: CGFloat!
    var verifyBtnColor:String!
    var verfifyBtnRadius:String!
    var verifybtnTextColor:String!
    var allowResendTime:String!
    var expiryTime:String!
    var validateToken:String?
    var sessionID:String!
    var clientID:String!
    var bankId:String!
    var count = 30
    var orderDetails:[String:Any]!
    var language:String!
    var url:String!
    var orderID: String!
    var socketUrl:String!

    @IBOutlet weak var otpVerificationLabel: UILabel!
    @IBOutlet weak var enterOtpLabel: UILabel!
    @IBOutlet weak var dontReceiveOtpLabel: UILabel!
    @IBAction func doneClicked(_ sender: Any) {
        otpTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        print("a")
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.endEditing(true)
        print("b")


    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headers: HTTPHeaders = [
            "token" : "\(encrypted_token(password: "admin"))",
            "Accept": "application/json"
        ]
        let parameters = [
            "data": "\(encrypt_para())"
        ]

        AF.request("\(String(describing: socketUrl!))/socket/send", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { responseData in
            print("codeee \(responseData)")
        }
        
        
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        otpTextField.delegate = self
        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        loadingIndicator.isHidden = true
        print("hehe: \(bankImage) \(bankName) \(bankNumber)")
        verifyButton.layer.cornerRadius = verifyBtnCornerRadius
        verifyButton.layer.borderWidth = verifyBtnBorderWithd
        verifyButton.layer.borderColor = verifyBtnBorderColor
        resend.attributedText = NSAttributedString(string: "0:\(count)", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        otpTextField.textAlignment = .center
        otpTextField.becomeFirstResponder()
//        self.view.endEditing(true)
        bankLabel.text = bankName
        bankNo.text = bankNumber
        let url = URL(string: bankImage)
        let data = try? Data(contentsOf: url!)
        bankLogo.image = UIImage(data: data!)
        bankLogo.layer.cornerRadius = CGFloat((bankImageRadius.split(separator: ",")[0] as NSString).floatValue)
        print("\(verifyBtnColor!)")
        verifyButton.tintColor = hexStringToUIColor(hex: verifyBtnColor!)

        verifyButton.setTitleColor(hexStringToUIColor(hex: verifybtnTextColor), for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        if language == "en" {
            otpVerificationLabel.text = "OTP Verification"
            enterOtpLabel.text = "Enter the OTP sent to your phone number"
            dontReceiveOtpLabel.text = "Don't receive the OTP?"
        }
        else if language == "kh" {
            otpVerificationLabel.text = "ការបញ្ជាក់​ OTP"
            enterOtpLabel.text = "បញ្ចូល OTP ដែលបានផ្ញើទៅកាន់លេខទូរស័ព្ទរបស់លោកអ្នក"
            dontReceiveOtpLabel.text = "មិនបានទទួល​ OTP?"
        }
        if language == "en" {
            verifyButton.setTitle("Verify", for: .normal)

        }
        else if language == "kh" {
            verifyButton.setTitle("បញ្ជូន", for: .normal)

        }
        
        verifyButton.addTarget(self, action: #selector(verifyBtnTapped), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {

       

    }
    @objc func verifyBtnTapped(){
        
        let data2 = Data2(sessionID: sessionID, clientID: clientID,controller: self)
        data2.url = self.url
        print("Otpppp: \(otpTextField.text!)")
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        data2.cfTokenize(sessionId: sessionID, validateToken: validateToken!, otp: otpTextField.text!,clientID: clientID,bankID: bankId,wrongOtp: self.AlertWrongOtp,language: language, completion: { dict in

            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            if data2.otpSucceeded == "Succeeded"{
                self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                        self.function(["result_type": "payment", "data": dict])
        })

            }
        })
    }
    @objc func update() {
        if(count > 0) {
            resend.isUserInteractionEnabled = false
            if(count>=10){
                count-=1
                resend.text = "0:\(count)"
                
            }
            else{
                count-=1
                resend.text = "0:0\(count)"
                
            }
        }
        if(count==0){
            resend.isUserInteractionEnabled = true

            if language == "en" {
                resend.attributedText = NSAttributedString(string: String("Resend"), attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            }
            else if language == "kh" {
                resend.attributedText = NSAttributedString(string: String("ស្នើម្ដងទៀត"), attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            }
            resend.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resendTapped))
            resend.addGestureRecognizer(tapGesture)
            
            
        }
    }
    @objc func resendTapped(){
        let data2 = Data2(sessionID: sessionID, clientID: clientID, controller: self)
        data2.resendTokenize(clientID: clientID, bankID: bankId, sessionId: sessionID, validateToken: """
                             "\(validateToken!)"
                             """) { a, b, c in
            self.count=31
            self.update()
        }
        
        print("Tapped")
    }
    func encrypted_token(password:String) -> String{
        print("Execution Start: \(NSDate())")
        let password: [UInt8] = Array("\(password)".utf8)
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
        
        let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
        
        do {
            var data_tobe_encrypted = """

{"app_id":"sdk","room_name":"\(orderID)"}
"""
            
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
        //            let encryptedString = String(decoding: encryptedData, as: UTF8.self)
        
//                print("Encrypted Data \(encryptedData)")
        //            print("Encrypted Data \(encryptedString)")
            let base64String = encryptedData.toBase64()

            print("End of execution: \(NSDate())")
            return base64String
        }
        catch{
            print(error)
            return ""
        }
    }
    func encrypt_para()->String{
        print("Execution Start: \(NSDate())")
        let password: [UInt8] = Array("\("admin")".utf8)
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
        
        let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
        do {
            var data_tobe_encrypted = """
{"event":"payment_processing", "message":""}
"""
            
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
        //            let encryptedString = String(decoding: encryptedData, as: UTF8.self)
        
//                print("Encrypted Data \(encryptedData)")
        //            print("Encrypted Data \(encryptedString)")
            let base64String = encryptedData.toBase64()

            print("End of execution: \(NSDate())")
            return base64String
        }
        catch{
            print(error)
            return ""
        }
    }
    func AlertWrongOtp(message:String){
        
    
        let alert:UIAlertController!
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        if language == "en" {
            alert = UIAlertController(title: "Verification failed", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else {
            alert = UIAlertController(title: "ការបញ្ជាក់OTPមិនជោគជ័យ", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "យល់ព្រម", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
       
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }


