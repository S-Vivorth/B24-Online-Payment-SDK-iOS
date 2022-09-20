//
//  paymentProcessingBox.swift
//  bill24Sdk
//
//  Created by San Vivorth on 12/7/21.
//

import UIKit

public class paymentProcessingBox: UIViewController {
    
    @IBOutlet weak var paymentProcLabel: UILabel!
    var language:String!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override public func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    public override func viewDidAppear(_ animated: Bool) {
        print(language)

        if language == "kh" {
            paymentProcLabel.text = "កំពុងប្រតិបត្តិការទូទាត់ប្រាក់"
        }
    }
    public override func viewDidDisappear(_ animated: Bool) {
        loadingIndicator.stopAnimating()
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
