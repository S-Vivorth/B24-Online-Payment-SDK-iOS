//
//  pmProcDone.swift
//  bill24Sdk
//
//  Created by San Vivorth on 12/15/21.
//

import UIKit

class pmProcDone: UIViewController {
    var views:UIViewController!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var bankRef: UILabel!
    @IBOutlet weak var tota: UILabel!
    var order_Id:String!
    var payment_method:String!
    var bank_Ref:String!
    var total_amount:String!
    var language:String!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var total1: UILabel!
    @IBOutlet weak var bankRef1: UILabel!
    @IBOutlet weak var pmMethod1: UILabel!
    @IBOutlet weak var orderid1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderID.text = order_Id
        paymentMethod.text = payment_method
        bankRef.text = bank_Ref
        tota.text = total_amount
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(continueBtnisClicked))
//        continueLable.isUserInteractionEnabled = true
//        continueLable.addGestureRecognizer(tapGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        print(language)
        if language == "kh"{
            pmLabel.text = "ការទូទាត់ប្រាក់បានជោគជ័យ"
            orderid1.text = "លេខបញ្ជាទិញ"
            pmMethod1.text = "ទូទាត់តាម"
            bankRef1.text = "លេខកូដយោង"
            total1.text = "ទឹកប្រាក់"
            btnn.setTitle("បន្តការទិញ", for: .normal)
            
        }
    }
    @IBOutlet weak var btnn: UIButton!
    @IBAction func btn(_ sender: Any) {
        print("Clicked")
    }
    @IBOutlet weak var continueLable: UILabel!
    @objc func continueBtnisClicked(){
        print("Button is clicked")
        dismissPopupViewController(animationType: .BottomTop)
        views.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
