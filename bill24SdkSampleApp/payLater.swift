//
//  payLater.swift
//  bill24SdkSampleApp
//
//  Created by San Vivorth on 11/26/21.
//

import Foundation
import UIKit
class payLater: UIViewController {


    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var continuebtn: UIButton!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    var orderDetails:[String:Any]!
    
    @IBOutlet weak var bankList: UILabel!
    var listbank:String = ""
    @IBAction func continueShoppingBtn(_ sender: Any) {
        
        let bundle = Bundle(for: type(of: self)) //important => if not inclue this => it cannot load the xib file
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
        present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        continuebtn.layer.cornerRadius = 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // order dictionary will be initialized during we open the screen
        orderId.text = "Order #\((orderDetails["order_ref"] as? String)!)"
        customerName.text = (orderDetails["customer_info"] as! [String:Any])["customer_name"] as! String
        for item in orderDetails["order_items"] as! NSArray{
            itemName.text =  (item as! NSDictionary).value(forKey: "item_name")! as! String
            quantity.text = String((item as! NSDictionary).value(forKey: "quantity")! as! Int)
            amount.text =  String((item as! NSDictionary).value(forKey: "amount")! as! Double) + "0 USD"
            if String((item as! NSDictionary).value(forKey: "discount_amount")! as! Double) != "0.0" {
                discount.text = String((item as! NSDictionary).value(forKey: "discount_amount")! as! Double) + "0 USD"
            }
            
            subTotal.text = String((item as! NSDictionary).value(forKey: "amount")! as! Double) + "0 USD"
        }
        
       
        totalPrice.text =  String(orderDetails["total_amount"] as! Double) + "0 USD"
        for item in orderDetails["app_or_agency_payment_methods"] as! NSArray {
            listbank += " \((item as! NSDictionary).value(forKey: "name_en")! as! String),"
        }
        listbank.removeFirst()
        listbank.removeLast()
        bankList.text = listbank
    }
}
struct Model {
    let imageString: String
    init(image: String){
        self.imageString = image
    }
}
