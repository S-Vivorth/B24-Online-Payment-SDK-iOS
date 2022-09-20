//
//  bottomsheetAnimation.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/3/21.
//

import Foundation
import UIKit

public class PaymentSdk {
//    public let controller = Bottomsheet.Controller()
    var hello:String = ""
    public init(){
        
    }
    
    @objc public func openSdk(controller: UIViewController, sessionID:String,cliendID:String,language:String, environment:String, callbackFunction: @escaping ([String:Any])-> Void){
        
        let frameworkBundle = Bundle(identifier: "bill24.bill24Sdk")
//
//        let storyboard = UIStoryboard(name: "Otp", bundle: frameworkBundle)
//
//        let vc = storyboard.instantiateViewController(withIdentifier: "Otp")
        
        let vc = bottomSheetController(sessionID: sessionID, clientID: cliendID,language: language,environment: environment ){ result in
            callbackFunction(result)
            
        }

        
        vc.modalPresentationStyle = .pageSheet
        
        //To show only half page
//        if #available(iOS 15.0, *) {
//            if let sheet = vc.presentationController as? UISheetPresentationController{
//
//                sheet.detents = [.medium(), .large()]
//                //corner radius
//                sheet.preferredCornerRadius = 20
//                //            sheet.prefersGrabberVisible = true
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        controller.present(vc, animated: true)
    }
}
