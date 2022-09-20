//
//  btmSheetController.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/8/21.
//

import UIKit
//import BottomSheet
import SocketIO
import CryptoSwift
import Alamofire
open class bottomSheetController: UIViewController{
    
    var sesstionID,clientID,language:String
//    var function: (([String:Any]) -> Void)
    var callbackFunction: (([String:Any]) -> Void)
    var orderID:String!
    var orderDetails:[String:Any]!
    var bankPaymentIsOpened:Bool = false
    var url:String!
    var socketUrl:String!
    var userAgent:String = "ios"

    public init(sessionID:String, clientID:String, language:String,environment:String, callbackFunction: @escaping ([String:Any])-> Void){
        let frameworkBundle = Bundle(identifier: "bill24.bill24Sdk")
        
        self.sesstionID = sessionID
        self.clientID = clientID
        self.language = language
        self.url = config(env: environment).sdk_api_url
        self.socketUrl = config(env: environment).socket_url

        self.callbackFunction = { result in
            callbackFunction(result)
        }
        
        
        
        super.init(nibName: "bottomSheetController", bundle: frameworkBundle)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
    }
    
    public var mytableisClick = false
    var existtableisClick = false
    @IBOutlet weak var backButton:UIImageView!
    
    @IBOutlet var slideIndicator: UIView!

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var payExtistingLabel: NSLayoutConstraint!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var saveAccSwitch: UISwitch!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var exTableViewHeight: NSLayoutConstraint!
    
    var selectedIndex:Int?
    var bankList: [String] = []
    var imageList: [String] = []
    var priceList:[String] = []
    var index_of_existing:Int?
    var supportTokenize: [Any] = []
    var supportDeepLink: [Any] = []
    var bankIdList: [String] = []
    var payment_confirm_button:String!
    var remember_account_label:String!
    var widget_frame:String!
    var payment_method_button:String!
    var selected_payment_method_button :String!
    var selected_payment_method_buttonBg:String!
    var savedAccLabel:String!
    var tranid:String!
    var previousSelectedIndex:Int = -1
    var isSucceeded:Bool = false
    ////    let bankList: [String] = ["ACLEDA","WING","PI PAY","ABA","Agent / Bank Counter","Pay With Existing Accounts","ACLEDA", "ACLEDA"]
//    let imageList: [String] = ["acleda", "wing", "pipay", "aba", "agent","","acleda", "acleda"]
//    let priceList:[String] = ["0.25 USD", "0.50 USD","0.50 USD", "0.70 USD","","","****2021", "****0330"]
    
//    let existBankList: [String] = ["ACLEDA", "ACLEDA"]
//    let cardNoList :[String] = ["****2021", "****0330"]
//
//    let exBankImgList:[String] = ["acleda", "acleda"]
    

    @IBOutlet weak var cfButton: UIButton!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var exTableView: UITableView!
    
    
    @IBOutlet weak var rememberAccLabel: UILabel!
    @IBOutlet var widgetFrame: UIView!
    let cellID = "tableViewCell"
    let cellID1 = "existTbCell"
    
    //must declare manager here otherwise it won't work
    var manager :SocketManager!

//


    public override func viewDidLoad() {
        super.viewDidLoad()
        manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(true), .compress])

        
        if language == "en" {
            paymentLabel.text = "Payment Methods"
        }
        else{
            paymentLabel.text = "វិធីទូទាត់ប្រាក់"
        }
        
        
        saveAccSwitch.isEnabled = false
        
        loadingIndicator.startAnimating()
        let data2 = Data2(sessionID: sesstionID, clientID: clientID, controller: self)
        data2.url = url
        let start = DispatchTime.now()
        
        data2.orderInit(language: language,completion: {isSuccess, result_message in
            if (isSuccess == true) {
                self.orderDetails = data2.orderDetails
                self.bankList = data2.bankList
                self.mytableView.reloadData()
                
                self.imageList = data2.imageList
                self.priceList = data2.priceList
                //to find the index of Pay With Existing Accounts
                self.savedAccLabel = data2.saveAccLabel

                if self.savedAccLabel != "" {
                    let saveAccLabelArray = self.savedAccLabel.split(separator: ",")

                    print(saveAccLabelArray[0])
                    if self.language == "en"{
                        self.index_of_existing = self.bankList.firstIndex(of: String(saveAccLabelArray[0]))!
                    }
                    else{
                        self.index_of_existing = self.bankList.firstIndex(of: String(saveAccLabelArray[2]))!
                    }
                    
                }
                else{
                    self.index_of_existing = self.supportTokenize.count+1
                }
                

                
                
                self.supportTokenize = data2.supportTokenize
                self.supportDeepLink = data2.supportDeeplink
                self.bankIdList = data2.bankIdList
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.orderID = data2.orderID
                self.socket(manager: self.manager)
                self.payment_confirm_button = data2.paymentConfirmBtn
                    let paymentCfBtnArray = self.payment_confirm_button.split(separator: ",")
                    self.cfButton.backgroundColor = self.hexStringToUIColor(hex: String(paymentCfBtnArray[6]))
                    self.cfButton.layer.borderColor = self.hexStringToUIColor(hex: String(paymentCfBtnArray[1])).cgColor
                    self.cfButton.layer.cornerRadius =
                    CGFloat((self.splitPxText(tobeSplit: String(paymentCfBtnArray[4])) as NSString).floatValue)
                    self.cfButton.layer.borderWidth =
                    CGFloat((self.splitPxText(tobeSplit: String(paymentCfBtnArray[2])) as NSString).floatValue)
                    self.cfButton.setTitleColor(self.hexStringToUIColor(hex: String(paymentCfBtnArray[3])), for: .normal)
                    self.cfButton.setTitleColor(self.hexStringToUIColor(hex: String(paymentCfBtnArray[3])), for: .disabled)

                if self.language == "en" {
                    self.cfButton.setTitle(String(paymentCfBtnArray[7]), for: .normal)
                }
                else{
                    self.cfButton.setTitle(String(paymentCfBtnArray[8]), for: .normal)
                }
                    self.cfButton.tintColor =
                    self.hexStringToUIColor(hex: String(paymentCfBtnArray[6]))
                self.saveAccSwitch.onTintColor = self.hexStringToUIColor(hex: String(paymentCfBtnArray[6]))
                    
                
                
                self.remember_account_label = data2.rememberAccLabel
                let rememberAccLabelArray = self.remember_account_label.split(separator: ",")
                if self.language == "en"{
                    self.rememberAccLabel.text = String(rememberAccLabelArray[1])

                }
                else{
                    self.rememberAccLabel.text = String(rememberAccLabelArray[2])

                }
                self.rememberAccLabel.textColor = self.hexStringToUIColor(hex: String(rememberAccLabelArray[0]))
                
                
                self.selected_payment_method_button = data2.selectedPaymentMethodBtn
                let paymentMethodBtnArray = self.selected_payment_method_button.split(separator: ",")
                self.selected_payment_method_buttonBg = String(paymentMethodBtnArray[1])
                
                
                self.payment_method_button = data2.paymentMethodBtn
            }
            else{
                
                self.widgetInitError(message: result_message)
            }
            
            
        })
        
        

//        DispatchQueue.main.async {
//            self.mytableView.reloadData()
//
//        }
        if #available(iOS 13.0, *){
            backButton.isHidden = true
        }
        else{
            slideIndicator.isHidden = true

            backButton.image = UIImage(named: "cross", in: Bundle(for: type(of: self)),compatibleWith: nil)
            backButton.tintColor = .gray
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped(tapGestureRecognizer:)))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        self.cfButton.setTitleColor(.white, for: .disabled)
        let bundle = Bundle(for: type(of: self)) //important => if not include this => it cannot load the xib file
        mytableView.register(UINib(nibName: cellID, bundle: bundle), forCellReuseIdentifier: "cell")
        mytableView.register(UINib(nibName: cellID1, bundle: bundle), forCellReuseIdentifier: "existcell")
        mytableView.register(UINib(nibName: "header", bundle: bundle), forCellReuseIdentifier: "header")
        mytableView.delegate = self
        mytableView.dataSource = self
        
        
//        for hide grey header and footer of table
        mytableView.sectionHeaderHeight = UITableView.automaticDimension;
        mytableView.estimatedSectionHeaderHeight = 20.0
        mytableView.contentInset = UIEdgeInsets(top: -18.0, left: 0.0, bottom: -40, right: 0.0);
        
        mytableView.layer.borderColor = UIColor.gray.cgColor
        mytableView.layer.borderWidth = 0.3
        
        
//        exTableView.register(UINib(nibName: cellID1, bundle: bundle), forCellReuseIdentifier: "existcell")
//        exTableView.delegate = self
//        exTableView.dataSource = self
//        exTableViewHeight.constant = CGFloat(81*(existBankList.count))+exTableView.sectionHeaderHeight
//        exTableView.isScrollEnabled = false
//        exTableView.layer.borderColor = UIColor.gray.cgColor
//        exTableView.layer.borderWidth = 0.3

        
        cfButton.addTarget(self, action: #selector(confirmPayment), for: .touchUpInside)
        //set the height base on its cells
//        tableViewHeight.constant = CGFloat(81*(bankList.count+1))
        mytableView.isScrollEnabled = true
        
    }
    func widgetInitError(message:String){
        let alert:UIAlertController!
        
        if language == "en" {
            alert = UIAlertController(title: "Somethings went wrong", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default){(action) in
                self.dismissSdk()
                
            })
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else {
            alert = UIAlertController(title: "មិនជោគជ័យ", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "យល់ព្រម", style: UIAlertAction.Style.default){ (action) in
                self.dismissSdk()

            })
        
            self.present(alert, animated: true, completion: nil)

        }
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    func alertError(message:String){
        let alert:UIAlertController!
        
        if language == "en" {
            alert = UIAlertController(title: "Somethings went wrong", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else {
            alert = UIAlertController(title: "មិនជោគជ័យ", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "យល់ព្រម", style: UIAlertAction.Style.default, handler: nil))
        
            self.present(alert, animated: true, completion: nil)

        }
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    @objc func confirmPayment(){
        
        self.view.bringSubviewToFront(self.loadingIndicator)
        self.loadingIndicator.layer.zPosition = 3
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
        self.bankPaymentIsOpened = true
        let data2 = Data2(sessionID: sesstionID, clientID: clientID, controller: self)
        data2.url = url

//        if environment == "uat" {
//            data2.url = "https://sdkapi-demo.bill24.net"
//        }
//        else{
//            data2.url = "https://sdkapi-staging.bill24.net"
//        }
        
        
        // if saved accounts exist
        if savedAccLabel != "" {
            // if pay_later option not exists
            if bankIdList[index_of_existing! - 1] != "pay_later"{
                if(selectedIndex! < index_of_existing!){
                    init_payment(data2: data2)
                }
                else{
                    let split_bank_tokenize = bankIdList[selectedIndex!-1].components(separatedBy: "$$$")
                    let bundle = Bundle(for: type(of: self)) //important => if not inclue this => it cannot load the xib file
                    let storyboard = UIStoryboard(name: "Otp", bundle: bundle)
                    let vc:Otp = storyboard.instantiateViewController(withIdentifier: "Otp") as! Otp
                    vc.bankName = self.bankList[selectedIndex!]
                    vc.bankNumber = self.priceList[selectedIndex!]
                    vc.bankImage = self.imageList[selectedIndex!]
                    let paymentMethodBtnArray = payment_method_button.split(separator: ",")
                    vc.bankImageRadius = String(paymentMethodBtnArray[2])
                    let paymentCfBtnArray = self.payment_confirm_button.split(separator: ",")
                    vc.verifyBtnColor =  String(paymentCfBtnArray[6])
                    vc.verifybtnTextColor = String(paymentCfBtnArray[3])
                    vc.orderID = self.orderID
                    vc.verifyBtnBorderColor = self.hexStringToUIColor(hex: String(paymentCfBtnArray[1])).cgColor
                    vc.verifyBtnCornerRadius =
                    CGFloat((self.splitPxText(tobeSplit: String(paymentCfBtnArray[4])) as NSString).floatValue)
                    vc.verifyBtnBorderWithd =
                    CGFloat((self.splitPxText(tobeSplit: String(paymentCfBtnArray[2])) as NSString).floatValue)
                    vc.sessionID = sesstionID
                    vc.clientID = clientID
                    vc.bankId = split_bank_tokenize[0]
                    vc.function = callbackFunction
                    vc.orderDetails = self.orderDetails
                    vc.socketUrl = socketUrl
                    data2.tokenizeValidate(bankID: split_bank_tokenize[0], tokenizeID: split_bank_tokenize[1],language: language) { allowResendTime, expiryTime, validateToken, result_code, result_message in
                        if result_code == "000" {
                            vc.allowResendTime = String(allowResendTime)
                            vc.expiryTime = String(expiryTime)
                            vc.validateToken = validateToken
                            vc.language = self.language
                            vc.url = data2.url
                            self.present(vc, animated: true, completion: {
                                self.loadingIndicator.stopAnimating()
                                self.loadingIndicator.isHidden = true
                            })
                        }
                        else{
                            self.alertError(message: result_message)
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.isHidden = true
                            return
                        }
                    }
            }
            }
            //if pay_later exists
            else{
                
                if(selectedIndex! < index_of_existing! - 1){
                    init_payment(data2: data2)
                }
                else if (selectedIndex! == (index_of_existing! - 1)){
                    dismiss(animated: false, completion: {
                        self.callbackFunction(["result_type": "pay_later", "data": self.orderDetails ?? ""])
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                    })
                }
                else{
                    let split_bank_tokenize = bankIdList[selectedIndex!-1].components(separatedBy: "$$$")
                    let bundle = Bundle(for: type(of: self)) //important => if not inclue this => it cannot load the xib file
                    let storyboard = UIStoryboard(name: "Otp", bundle: bundle)
                    let vc:Otp = storyboard.instantiateViewController(withIdentifier: "Otp") as! Otp
                    vc.bankName = self.bankList[selectedIndex!]
                    vc.bankNumber = self.priceList[selectedIndex!]
                    vc.bankImage = self.imageList[selectedIndex!]
                    let paymentMethodBtnArray = payment_method_button.split(separator: ",")
                    vc.bankImageRadius = String(paymentMethodBtnArray[2])
                    let paymentCfBtnArray = self.payment_confirm_button.split(separator: ",")
                    vc.verifyBtnColor =  String(paymentCfBtnArray[6])
                    vc.verifybtnTextColor = String(paymentCfBtnArray[3])
                    vc.orderID = self.orderID
                    vc.verifyBtnBorderColor = self.hexStringToUIColor(hex: String(paymentCfBtnArray[1])).cgColor
                    vc.verifyBtnCornerRadius =
                    CGFloat((self.splitPxText(tobeSplit: String(paymentCfBtnArray[4])) as NSString).floatValue)
                    vc.verifyBtnBorderWithd =
                    CGFloat((self.splitPxText(tobeSplit: String(paymentCfBtnArray[2])) as NSString).floatValue)
                    vc.sessionID = sesstionID
                    vc.clientID = clientID
                    vc.bankId = split_bank_tokenize[0]
                    vc.function = callbackFunction
                    vc.orderDetails = self.orderDetails
                    vc.socketUrl = socketUrl
                    data2.tokenizeValidate(bankID: split_bank_tokenize[0], tokenizeID: split_bank_tokenize[1],language: language) { allowResendTime, expiryTime, validateToken, result_code, result_message in
                        if result_code == "000" {
                            vc.allowResendTime = String(allowResendTime)
                            vc.expiryTime = String(expiryTime)
                            vc.validateToken = validateToken
                            vc.language = self.language
                            vc.url = data2.url
                            self.present(vc, animated: true, completion: {
                                self.loadingIndicator.stopAnimating()

                                self.loadingIndicator.isHidden = true
                            })

                        }
                        else{
                            self.alertError(message: result_message)
                            self.loadingIndicator.stopAnimating()

                            self.loadingIndicator.isHidden = true
                            return
                        }
                    }
            }
            }
        }
        // when no saved accounts exist
        else{
            
            if(selectedIndex! < supportTokenize.count-1){
                init_payment(data2: data2)
            }
            else{
                if bankIdList[selectedIndex!] != "pay_later" {
                    init_payment(data2: data2)
                }
                else{
                    dismiss(animated: false, completion: {
                        self.callbackFunction(["result_type": "pay_later", "data": self.orderDetails])
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                    })
                }
            }


        }
        
    }
    func init_payment(data2: Data2){
        if supportDeepLink[selectedIndex!] as! String == "1" {
            data2.initPayment(bankID: bankIdList[selectedIndex!], saveAcc: saveAccSwitch.isOn, language: language, userAgent: userAgent) { formdata, isSuccess, result_message in
                if isSuccess == true {
                    let dict = data2.convertToDictionary(text: formdata)!
                    guard let deeplink:String = (dict["deeplink_data"]) as? String else {
                        print("deeplinking not found")
                        return
                    }
                    guard let appstore:String = (dict["app_store"]) as? String else {
                        return
                    }
                    self.openDeepLink(deepLink: deeplink, appstore: appstore)
                    self.loadingIndicator.stopAnimating()

                    self.loadingIndicator.isHidden = true
                }
                else{
                    self.alertError(message: result_message)
                    self.loadingIndicator.stopAnimating()

                    self.loadingIndicator.isHidden = true
                }
            }
        }
        else{
            init_webpayment(agent: "web-mobile")
        }
    }
    
    func socket(manager: SocketManager){
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        
        var isPmProcessing:Bool = false
        socket.on("payment_processing") { data,ack in
            isPmProcessing = true
            print("processing is received")
            let frameworkBundle = Bundle(identifier: "bill24.bill24Sdk")
            let vc = bill24Sdk.paymentProcessingBox(nibName: "paymentProcessingBox", bundle: frameworkBundle)
            vc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
            vc.language = self.language
            if self.bankPaymentIsOpened == true {

            }
            else{
                self.presentpopupViewController(popupViewController: vc, animationType: .BottomTop, completion: {
                    
                })
                socket.on("payment_success") { data,ack  in
                    //need to use this in order to dismiss all vc
        //            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
        //                self.function(" ")
        //
        //            })
                    
                    self.dismissPopupViewController(animationType: .BottomTop)
                    let pmProcVC = bill24Sdk.pmProcDone(nibName: "pmProcDone", bundle: frameworkBundle) as! pmProcDone
//                    pmProcVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                    pmProcVC.views = self
                    let dict = data[0] as! [String:Any]
                    self.tranid = String((dict["tran_data"] as! [String:Any])["trans_id"] as! String)
                    
                    pmProcVC.order_Id = String((dict["tran_data"] as! [String:Any])["order_ref"] as! String)
                    
                    pmProcVC.payment_method = String((dict["tran_data"] as! [String:Any])["bank_name_en"] as! String)
                    pmProcVC.bank_Ref = String((dict["tran_data"] as! [String:Any])["bank_ref"] as! String)
                    pmProcVC.language = self.language
//                    pmProcVC.tota.text = (dict["tran_data"] as! [String:Any])["bank_name_en"] as! String
                    let parameters = [
                        "encrypted_data": "\(self.encrypt_transID())"
                    ]
//                    let headers: HTTPHeaders = [
//                        "token" : "f91d077940cf44ebbb1b6abdebce0f0a",
//                        "Accept": "application/json"
//                    ]
                    var result:InitOrder!

                    AF.request("\(self.url)/payment/verify", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { (responseData) in
                        guard let responsed = responseData.data else {
                            self.alertError(message: "Could connect to api", language: "en")
                            return
                        }
                    print(responseData)
                    print(responseData.response?.statusCode)
                    print(String(data: responsed, encoding: .utf8))
                    
                    do {
                        print("responsed::: \(responsed)")
                        result = try JSONDecoder().decode(InitOrder.self, from: responsed)
                        let start = DispatchTime.now()
                        
                        let decrypted_data = self.decrypt_result(base64Sting: result.data.encryptedData,completion: {
                        })
                        let str = decrypted_data
                        let dict: [String:Any]
                        dict = self.convertToDictionary(text: str)!
                        pmProcVC.total_amount = String(dict["total_amount"] as! Double)+"0 USD"
                        self.presentpopupViewController(popupViewController: pmProcVC, animationType: .BottomTop, completion: {})
                        pmProcVC.btnn.addTarget(self, action: #selector(self.click), for: .touchUpInside)
                    }
                    catch {
                        print(error)
                    }
                }
                }
            }


        }
        
        
        socket.on("payment_success") { data, ack in
            if (isPmProcessing == false) {
                print("success received")
                self.dismissSdk()
            }
        }
        socket.connect(withPayload: [
        "token" :
"\(encrypted_token(password: "client"))"
    ])
}
    @objc func click(){
        callbackFunction(["result_type": "continue_shopping", "data": ""])
        self.dismiss(animated: true, completion: nil)
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
            completion!()
            return decrypted ?? ""
        }
        catch{
            print(error)
            return ""
        }
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
    @objc func continueBtnisClick(){
//        self.dismissPopupViewController(animationType: .BottomTop)
        
        self.dismiss(animated: true, completion: nil)
    }
    public func showsheet(views: UIView){
//                let transitioningDelegate = BottomSheetTransitioningDelegate(
//                    contentHeights: [.bottomSheetAutomatic, UIScreen.main.bounds.size.height-500],
//                    startTargetIndex: 1  )
//                let frameworkBundle = Bundle(identifier: "bill24.bill24Sdk")
//
//                let viewController = bottomSheetController(nibName: "bottomSheetController", bundle: frameworkBundle)
//                viewController.transitioningDelegate = transitioningDelegate
//                viewController.modalPresentationStyle = .custom
//
//                present(viewController, animated: true)
        
        
        
    }
    func encrypt_transID() -> String{
        let password: [UInt8] = Array("\("sdkdev")".utf8)
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
            var data_tobe_encrypted = """
{"trans_id":"\(tranid!)"}
"""
            
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
            let base64String = encryptedData.toBase64()
            return base64String
        }
        catch{
            print(error)
            return ""
        }
    }
    func encrypted_token(password:String) -> String{
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
            var data_tobe_encrypted = """

{"app_id":"sdk","room_name":"\(orderID!)"}
"""
            
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let encryptedData = try aes.encrypt(Array("\(data_tobe_encrypted)".utf8))
            let base64String = encryptedData.toBase64()
            return base64String
        }
        catch{
            print(error)
            return ""
        }
    }
    func init_webpayment(agent: String){
        let bundle = Bundle(for: type(of: self)) //important => if not include this => it cannot load the xib file
        let storyboard = UIStoryboard(name: "bankPaymentController", bundle: bundle)
        let vc:bankPaymentController = storyboard.instantiateViewController(withIdentifier: "bankPaymentController") as! bankPaymentController
        let data2 = Data2(sessionID: sesstionID, clientID: clientID, controller: self)
        data2.url = url
        vc.orderID = self.orderID!
        vc.orderDetails = self.orderDetails
        vc.isEmpty = data2.isEncrypteDataEmpty
        vc.socketUrl = socketUrl
        data2.initPayment(bankID: bankIdList[selectedIndex!], saveAcc: saveAccSwitch.isOn ,language: language, userAgent: agent) { [self] formdata, isSuccess, result_message in
            if isSuccess == true {
            let html = """
            <html>

                <body>

                <script>
            function submit_form(data) {

            let form = document.createElement("form");
            form.setAttribute("action", data.action_url);
            form.setAttribute("method", "post");
            for (let key in data.form_data) {
                let input = document.createElement("input");
                input.setAttribute("name", key);
                input.setAttribute("type", "hidden");
                input.setAttribute("value", data.form_data[key]);
                form.appendChild(input);
            }
            document.getElementsByTagName("body")[0].append(form);
            form.submit();
            }
            submit_form(\(formdata));

            </script>
                </body>
            </html>
            """
                    
                    vc.html = html
                    vc.function = self.callbackFunction
                    self.present(vc, animated: true, completion: {
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                    })
                
            }
            else {
                self.alertError(message: result_message)
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            }
            }
    }
    func openDeepLink(deepLink:String!,appstore:String){
        print("opendeeplink is called")
        // Url will return nil if we don't add this coz sometimes string which put to url is containing space => we need to use this
        let txtAppend = (deepLink).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let deeplinkURL = URL(string: txtAppend!), let appStoreURL =
         URL(string: appstore) else {
             self.alertError(message: "Could not find deeplink or appstore url", language: "en")
            return
         }
            UIApplication.shared.open(deeplinkURL, options: [:]) { success in
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            if !success {
                // Open app store
                print("Failed to open deeplink")
                UIApplication.shared.open(URL(string: appstore)!, options: [:])
            }
            self.dismissSdk()
        }
        
    }
    func splitPxText(tobeSplit:String)-> String{
        let splitArray = tobeSplit.split(separator: "p")
        return String(splitArray[0])
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
    @objc func backButtonTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //back to previous screen
        self.dismiss(animated: true, completion: nil)
    }
}


extension bottomSheetController: UITableViewDelegate, UITableViewDataSource{
    
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankList.count
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
//        print("Deselect at :\(indexPath.row)")
//        if savedAccLabel != "" {
//
//            if indexPath.row < index_of_existing! {
//
//                let cell = mytableView.cellForRow(at: indexPath) as! tableViewCell
////                guard let cell = mytableView.cellForRow(at: indexPath) as? tableViewCell else {
////                    return
////
////                }
//
//                cell.checkBox.image = UIImage(named: "defaultcheckbox", in: Bundle(for: type(of: self)),compatibleWith: nil)
//                cell.checkBox.tintColor = UIColor.gray.withAlphaComponent(0.5)
//                cell.cellView.backgroundColor = .clear
//                cell.isSelected = false
//
//            }
//            else{
//                let cell = mytableView.cellForRow(at: indexPath) as! existTbCell
//
////                guard let cell = mytableView.cellForRow(at: indexPath) as? existTbCell else{
////                    return
////                }
//                cell.exCheckBox.image = UIImage(named: "defaultcheckbox", in: Bundle(for: type(of: self)),compatibleWith: nil)
//                cell.exCheckBox.tintColor = UIColor.gray.withAlphaComponent(0.5)
//                cell.exCheckBox.backgroundColor = .clear
//                cell.exCellView.backgroundColor = .clear
//                cell.isSelected = false
//
//            }
//        }
//        else{
//            let cell = mytableView.cellForRow(at: indexPath) as! tableViewCell
//
////            guard let cell = mytableView.cellForRow(at: indexPath) as? tableViewCell else{
////                return
////            }
//
//            cell.checkBox.image = UIImage(named: "defaultcheckbox", in: Bundle(for: type(of: self)),compatibleWith: nil)
////            cell.checkBox.tintColor = UIColor.gray.withAlphaComponent(0.5)
//            cell.cellView.backgroundColor = .clear
//            cell.isSelected = false
//
//        }


    }
    

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPaymentMethodBtnArray = self.selected_payment_method_button.split(separator: ",")
            let paymentCfBtnArray = self.payment_confirm_button.split(separator: ",")
            selectedIndex = indexPath.row

            self.cfButton.setTitleColor(self.hexStringToUIColor(hex: String(paymentCfBtnArray[3])), for: .normal)
                if(cfButton.isEnabled == false){
                    cfButton.isEnabled = true
                    cfButton.alpha = 1
                }
            if savedAccLabel != ""{
                if indexPath.row < index_of_existing! {
                    let cell = mytableView.cellForRow(at: indexPath) as! tableViewCell
                        
                    cell.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
                    cell.selectedBgColor = self.hexStringToUIColor(hex: selected_payment_method_buttonBg)
                    cell.selectedCheckboxTintColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[0]))
                    cell.selectedBankNameTextColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
                    cell.selectedFeeTextColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
//                        cell.checkBox.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
//                        cell.cellView.backgroundColor = self.hexStringToUIColor(hex: selected_payment_method_buttonBg)
//                        cell.checkBox.tintColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[0]))
//                        cell.bankName.textColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
//                        cell.totalPrice.textColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
                        
                    cell.isSelected = true

//                    mytableView.reloadData()

                    if supportTokenize[indexPath.row] as! String == "1" {
                        saveAccSwitch.isEnabled = true
                    }
                    else{
                        saveAccSwitch.isEnabled = false
                        saveAccSwitch.isOn = false
                    }
                }
                else{
                    existtableisClick = true
                    mytableisClick = false
                    saveAccSwitch.isEnabled = false
                    saveAccSwitch.isOn = false
                    let cell = mytableView.cellForRow(at: indexPath) as! existTbCell
                    cell.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
                    cell.exselectedCheckboxTintColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[0]))
                    cell.exselectedBgColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[1]))
                    cell.exselectedBankNameTextColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
                    cell.exselectedFeeTextColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
//                        cell.exCheckBox.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
//                        cell.exCheckBox.tintColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[0]))
//
//                        cell.exCellView.backgroundColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[1]))
//                        cell.exBankName.textColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
//                        cell.exBankNumber.textColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
                    cell.isSelected = true

//                    mytableView.reloadData()

                }

            }
            else{
                let cell = mytableView.cellForRow(at: indexPath) as! tableViewCell
                
                cell.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
                cell.selectedBgColor = self.hexStringToUIColor(hex: selected_payment_method_buttonBg)
                cell.selectedCheckboxTintColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[0]))
                cell.selectedBankNameTextColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
                cell.selectedFeeTextColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
//                    cell.checkBox.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
//                    cell.cellView.backgroundColor = self.hexStringToUIColor(hex: selected_payment_method_buttonBg)
//                    cell.checkBox.tintColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[0]))
//                    cell.bankName.textColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
//                    cell.totalPrice.textColor = self.hexStringToUIColor(hex: String(selectedPaymentMethodBtnArray[3]))
                cell.isSelected = true

//                mytableView.reloadData()

                if supportTokenize[indexPath.row] as! String == "1" {
                    saveAccSwitch.isEnabled = true

                }
                else{
                    saveAccSwitch.isEnabled = false
                    saveAccSwitch.isOn = false
                }
            }
//


    }

    


    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if savedAccLabel != "" {
            if (indexPath.row < index_of_existing!)
            {
                
                let cell = mytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
                
                cell.bankName.text = bankList[indexPath.row]
                let paymentMethodBtnArray = payment_method_button.split(separator: ",")
                cell.unselectedBankNameColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[6]))

                cell.bankName.textColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[6]))
                cell.totalPrice.textColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[6]))
                cell.bankImage.layer.borderWidth = CGFloat((self.splitPxText(tobeSplit: String(paymentMethodBtnArray[4])) as NSString).floatValue)
                cell.bankImage.layer.borderColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[1])).cgColor
                cell.bankImage.layer.cornerRadius =  CGFloat((self.splitPxText(tobeSplit: String(paymentMethodBtnArray[2])) as NSString).floatValue)
                
                if paymentMethodBtnArray[7] == "false" {
                    cell.totalPrice.text = ""
                }
                else{
                    cell.totalPrice.text = priceList[indexPath.row]

                }
//                cell.checkBox.tintColor = .gray.withAlphaComponent(0.5)
                
                //to make the scroll smooth we need to use background thread for loading image data
                //and set image in main thread
                DispatchQueue.global(qos: .background).async {
                    let url = URL(string: self.imageList[indexPath.row])

                    if let data = try? Data(contentsOf: url!){
                        let myImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.bankImage.image = UIImage(data: data)

                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            
                            if #available(iOS 13.0, *) {
                                cell.bankImage.image = UIImage(systemName: "aba")
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    
                }

                //to hide the default select background (grey)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
    //            let widgetFrameArray = self.widget_frame.split(separator: ",")
    //            cell.backgroundColor = self.hexStringToUIColor(hex: String(widgetFrameArray[8]))


                cell.tag = indexPath.row

                return cell
                
            }
            else if indexPath.row == index_of_existing! {
                let cell = mytableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! header
                cell.isUserInteractionEnabled = false
                let saveAccLabelArray = self.savedAccLabel.split(separator: ",")
                if language == "en"{
                    cell.savedAccLabel.text = String(saveAccLabelArray[0])

                }
                else{
                    cell.savedAccLabel.text = String(saveAccLabelArray[2])

                }
                cell.savedAccLabel.textColor = self.hexStringToUIColor(hex: String(saveAccLabelArray[1]))
    //            let widgetFrameArray = self.widget_frame.split(separator: ",")
    //            cell.backgroundColor = self.hexStringToUIColor(hex: String(widgetFrameArray[8]))
                cell.tag = indexPath.row
                cell.reloadInputViews()

                return cell
            }
            else if indexPath.row > index_of_existing! {
                            let cell = mytableView.dequeueReusableCell(withIdentifier: "existcell", for: indexPath) as! existTbCell
                            cell.exBankName.text = bankList[indexPath.row]

                DispatchQueue.global(qos: .background).async {
                    let url = URL(string: self.imageList[indexPath.row])

                    if let data = try? Data(contentsOf: url!){
                        let myImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.exBankImg.image = UIImage(data: data)

                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            
                            if #available(iOS 13.0, *) {
                                cell.exBankImg.image = UIImage(systemName: "aba")
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    
                }

                            cell.exBankNumber.text = priceList[indexPath.row]
    //                        cell.exBankNumber.addCharacterSpacing(kernValue: 5)
                            cell.exCheckBox.tintColor = .gray.withAlphaComponent(0.5)
                        
                                cell.exCheckBox.image = UIImage(named: "defaultcheckbox", in: Bundle(for: type(of: self)),compatibleWith: nil)
                            //to hide the default select background (grey)
                            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                let paymentMethodBtnArray = payment_method_button.split(separator: ",")
                cell.exunselectedBankNameColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[6]))
                cell.exBankName.textColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[6]))
                cell.exBankNumber.textColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[6]))
                cell.exBankImg.layer.borderWidth = CGFloat((self.splitPxText(tobeSplit: String(paymentMethodBtnArray[4])) as NSString).floatValue)
                cell.exBankImg.layer.borderColor = self.hexStringToUIColor(hex: String(paymentMethodBtnArray[1])).cgColor
                cell.exBankImg.layer.cornerRadius =  CGFloat((self.splitPxText(tobeSplit: String(paymentMethodBtnArray[2])) as NSString).floatValue)
                cell.tag = indexPath.row
                cell.reloadInputViews()

                return cell
            }
            else {
                return UITableViewCell()

            }
        }
        else{
            let cell = mytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
            
            cell.bankName.text = bankList[indexPath.row]
            cell.totalPrice.text = priceList[indexPath.row]
            cell.checkBox.tintColor = .gray.withAlphaComponent(0.5)
            
            //to make the scroll smooth we need to use background thread for loading image data
            //and set image in main thread
            DispatchQueue.global(qos: .background).async {
                let url = URL(string: self.imageList[indexPath.row])

                if let data = try? Data(contentsOf: url!){
                    let myImage = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.bankImage.image = UIImage(data: data)

                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                        if #available(iOS 13.0, *) {
                            cell.bankImage.image = UIImage(systemName: "aba")
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
            cell.reloadInputViews()

            cell.tag = indexPath.row

            return cell
        }
        
    }
  
}

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
      guard let text = text, !text.isEmpty else { return }
      let string = NSMutableAttributedString(string: text)
      string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
      attributedText = string
    }
}
extension UIViewController {
    func alertError(message:String, language: String, isDismissSdk: Bool? = false){
        let alert:UIAlertController!
        
        if language == "en" {
            alert = UIAlertController(title: "Somethings went wrong", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                if (isDismissSdk == true) {
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                    })
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            alert = UIAlertController(title: "មិនជោគជ័យ", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "យល់ព្រម", style: UIAlertAction.Style.default, handler: {action in
                if (isDismissSdk == true) {
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                    })
                }

            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func dismissSdk(){
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

