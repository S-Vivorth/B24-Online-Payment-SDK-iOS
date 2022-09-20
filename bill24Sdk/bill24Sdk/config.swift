//
//  config.swift
//  oonePaymentSdk
//
//  Created by San Vivorth on 5/31/22.
//

import Foundation

class config{
    let sdk_api_url: String!
    let socket_url: String!
    let sdk_version:String = "v1.0.1-improve error handling"
    init(env: String){
        if (env == "prod") {
            sdk_api_url = "https://sdkapi.bill24.net"
            socket_url = "https://socketio.bill24.net/"
        }
        else{
            sdk_api_url = "https://sdkapi-demo.bill24.net"
            socket_url = "https://socketio-demo.bill24.net/"
        }
    }

}
