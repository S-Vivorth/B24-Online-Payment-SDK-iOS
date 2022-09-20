//
//  bottomsheetview.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/4/21.
//

import UIKit

public class RegisterPageView: UIView {

        class func instanceFromNib() -> RegisterPageView {
            return UINib(nibName: "bottomSheetController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RegisterPageView
        }
}
