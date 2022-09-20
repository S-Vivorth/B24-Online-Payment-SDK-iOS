//
//  bankPaymentController.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/5/21.
//

import UIKit
import WebKit
import SocketIO
import CryptoSwift
import Alamofire
open class bankPaymentController: UIViewController, WKNavigationDelegate,WKScriptMessageHandler, WKUIDelegate {
    var function : (([String:Any]) -> Void)!
    var orderID: String!
    var orderDetails:[String:Any]!
    var isEmpty:Bool!
    var socketUrl: String!

    //    var sesstionID,clientID,bankID:String
//
//    init(sessionID:String, clientID:String, bankID:String){
//        let frameworkBundle = Bundle(identifier: "bill24.bill24Sdk")
//
//        self.sesstionID = sessionID
//        self.clientID = clientID
//        self.bankID = bankID
//        super.init(nibName: "bankPaymentController", bundle: frameworkBundle)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var topBlankBar: NSLayoutConstraint!
    
    @IBOutlet weak var backButtonConstraint: NSLayoutConstraint!

    var manager :SocketManager!
    var html = ""
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    public override func viewDidLoad() {
        super.viewDidLoad()
        manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(true), .compress])

        webView.loadHTMLString(html, baseURL: nil)
        let headers: HTTPHeaders = [
            "token" : "\(encrypted_token(password: "admin"))",
            "Accept": "application/json"
        ]
        print("headerr: \(headers)")
        let parameters = [
            "data": "\(encrypt_para())"
        ]
        print("tokennn\(encrypted_token(password: "admin"))")
        print("encrypted_data: \(encrypt_para())")
        AF.request("\(String(describing: socketUrl!))socket/send", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { responseData in
        }
        loadingIndicator.startAnimating()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        webView.configuration.preferences = wkPreferences

        if #available(iOS 14.0, *) {
            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            // Fallback on earlier versions
        }
        
        webView.configuration.preferences.javaScriptEnabled = true

//        if #available(iOS 14.0, *) {
//            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
//        } else {
//            // Fallback on earlier versions
//        }
        
//        if let htmlpath = Bundle.main.path(forResource: "index", ofType: "html"){
//            print(htmlpath)
//            webView.load(URLRequest(url: URL(fileURLWithPath: htmlpath)))
//        }
        let source = """
    function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.onerror = captureLog;
"""
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
        // register the bridge script that listens for the output
        webView.configuration.userContentController.add(self, name: "logHandler")
//        webView.load(URLRequest(url: URL(string: "http://bf04-96-9-80-29.ngrok.io/parent")!))        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *){
            backButton.isHidden = true
        }
        else{
            topBlankBar.constant = 0
            backButtonConstraint.constant = 23
            
        }
    
//        backButton.image = UIImage(named: "cross", in: Bundle(for: type(of: self)),compatibleWith: nil)
        backButton.tintColor = .gray
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped(tapGestureRecognizer:)))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(tapGestureRecognizer)
        
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let socket = manager.defaultSocket

        if isEmpty == true {
            AlertWrongOtp(message: "abc")
        }


        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        socket.on("payment_success") { data,ack  in
            //need to use this in order to dismiss all vc
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                
            })
//            print((data[0] as! [String:Any])["payment_success_url"])
            print("typee of: \(type(of: data[0]))")
            self.function(["result_type": "payment", "data": data[0] as! [String:Any]]
)


        }

        socket.connect(withPayload: [
        "token" :
"\(encrypted_token(password: "client"))"

    ])

    
    }
    @objc public func backButtonTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("tapped")
        //back to previous screen
        //

        self.dismiss(animated: true, completion: nil)
        
        
        // Your action
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            print("order_idddd: \(orderID!)")
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
        
        let keyString = key.toHexString()
        
        let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
        
        do {
            print("order_idddd: \(orderID!)")
            var data_tobe_encrypted = """

{"app_id":"sdk","room_name":"\(orderID!)"}
"""
            
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
    func AlertWrongOtp(message:String){
        
    
        let alert:UIAlertController!
        

            alert = UIAlertController(title: "Verification failed", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

       
    }
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("LOG: \(message.body)")

    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        print("finished")
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
     }
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
                if let urlToLoad = navigationAction.request.url {
                   print("link \(urlToLoad.absoluteString)")// this is a closure, which is handled in another class. Nayway... here you get the url of "broken" links
                }
            }
            return nil
        }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let servertrust = challenge.protectionSpace.serverTrust!
        let exception = SecTrustCopyExceptions(servertrust)
        SecTrustSetExceptions(servertrust, exception)
        completionHandler(.useCredential, URLCredential(trust: servertrust))
        
        
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("failed: \(error)")
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("failed: \(error)")

    }
    
    
}
