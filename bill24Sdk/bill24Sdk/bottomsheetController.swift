////
////  bottomSheetController.swift
////  bill24Sdk
////
////  Created by San Vivorth on 11/3/21.
////
//
//import UIKit
////import BottomSheet
//public class bottomSheetController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet weak var backButton:UIImageView!
//
////    @IBOutlet weak var scrollViewHeight:NSLayoutConstraint!
////
//
//    let bankList: [String] = ["ACLEDA","WING","PI PAY","ABA","Agent / Bank Counter","ACLEDA","WING","PI PAY","ABA","Agent / Bank Counter"]
//    let imageList: [String] = ["acleda", "wing", "pipay", "aba", "agent","acleda", "wing", "pipay", "aba", "agent"]
//    let priceList:[String] = ["0.25 USD", "0.50 USD","0.50 USD", "0.70 USD","","0.25 USD", "0.50 USD","0.50 USD", "0.70 USD",""]
//
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//                print("Index \(indexPath) is tapped.")
//        if(cfButton.isEnabled == false){
//            cfButton.isEnabled = true
//            cfButton.alpha = 1
//        }
//        let cell = tableView.cellForRow(at: indexPath) as! tableViewCell
//        if #available(iOS 13.0, *) {
//            cell.checkBox.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
//            cell.checkBox.tintColor = UIColor.systemPurple
//            cell.cellView.backgroundColor = .systemPurple.withAlphaComponent(0.1)
//
//        }
//        else {
//            cell.checkBox.image = UIImage(named: "tick", in: Bundle(for: type(of: self)),compatibleWith: nil)
//            cell.checkBox.tintColor = .purple.withAlphaComponent(0.9)
//            cell.cellView.backgroundColor = .purple.withAlphaComponent(0.1)
//        }
//
//
//    }
//
//
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bankList.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = mytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
//        cell.bankName.text = bankList[indexPath.row]
//        cell.totalPrice.text = priceList[indexPath.row]
//        cell.checkBox.tintColor = .gray.withAlphaComponent(0.5)
//        cell.bankImage.image = UIImage(named: imageList[indexPath.row], in: Bundle(for: type(of: self)),compatibleWith: nil)
//
//        //to hide the default select background (grey)
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//        return cell
//    }
//
//    @IBOutlet weak var cfButton: UIButton!
//    @IBOutlet weak var paymentLabel: UILabel!
//    @IBOutlet weak var mytableView: UITableView!
//
//    let cellID = "tableViewCell"
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        if #available(iOS 13.0, *){
//            backButton.isHidden = true
//        }
//        else{
//            backButton.image = UIImage(named: "cross", in: Bundle(for: type(of: self)),compatibleWith: nil)
//            backButton.tintColor = .black
//        }
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped(tapGestureRecognizer:)))
//        backButton.isUserInteractionEnabled = true
//        backButton.addGestureRecognizer(tapGestureRecognizer)
//
//
//
//        self.cfButton.layer.cornerRadius = 10
//
//        let bundle = Bundle(for: type(of: self)) //important => if not inclue this => it cannot load the xib file
//        mytableView.register(UINib(nibName: cellID, bundle: bundle), forCellReuseIdentifier: "cell")
//        mytableView.delegate = self
//        mytableView.dataSource = self
//
////        for hide grey header and footer of table
//        mytableView.sectionHeaderHeight = UITableView.automaticDimension;
//        mytableView.estimatedSectionHeaderHeight = 20.0
//        mytableView.contentInset = UIEdgeInsets(top: -18.0, left: 0.0, bottom: -40, right: 0.0);
//
//        mytableView.layer.borderColor = UIColor.gray.cgColor
//        mytableView.layer.borderWidth = 0.3
//
//        cfButton.addTarget(self, action: #selector(confirmPayment), for: .touchUpInside)
//
//    }
//    @objc func confirmPayment(){
//        let bundle = Bundle(for: type(of: self)) //important => if not inclue this => it cannot load the xib file
//        let storyboard = UIStoryboard(name: "bankPaymentController", bundle: bundle)
//        let vc = storyboard.instantiateViewController(withIdentifier: "bankPaymentController")
//        present(vc, animated: true, completion: nil)
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    public func showsheet(views: UIView){
////                let transitioningDelegate = BottomSheetTransitioningDelegate(
////                    contentHeights: [.bottomSheetAutomatic, UIScreen.main.bounds.size.height-500],
////                    startTargetIndex: 1  )
////                let frameworkBundle = Bundle(identifier: "bill24.bill24Sdk")
////
////                let viewController = bottomSheetController(nibName: "bottomSheetController", bundle: frameworkBundle)
////                viewController.transitioningDelegate = transitioningDelegate
////                viewController.modalPresentationStyle = .custom
////
////                present(viewController, animated: true)
//
//
//
//    }
//
//    @objc func backButtonTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
////        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        print("tapped")
//        //back to previous screen
//        self.dismiss(animated: true, completion: nil)
//
//        // Your action
//    }
//}
//
//
////extension bottomSheetController: UITableViewDelegate{
////    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        print("Index \(indexPath) is tapped.")
////    }
////}
////
////
////extension bottomSheetController: UITableViewDataSource {
////    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return 1
////    }
////    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! tableViewCell
////        return cell
////
////    }
////}
////
