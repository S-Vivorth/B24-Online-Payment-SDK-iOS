import UIKit
import CryptoSwift
var greeting = "Hello, playground"



func encryption() {
    let password: [UInt8] = Array("sdkdev".utf8)
    print("password: \(password)")
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
    print("keyy: \(key)")
    print("keyy: \(key.toBase64())")
    let keyString = key.toHexString()
    
    print("Password to hexa: \(password.toHexString())")
    print("Salt to hexa: \(salt.toHexString())")
    print("key \(String(keyString.prefix(16)))")
    /* Generate random IV value. IV is public value. Either need to generate, or get it from elsewhere */
    let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)
    print(keyString.prefix(16).utf8)
    print("IV \(iv)")
    //         AES cryptor instance

    do {

        let aes = try AES(key: key, blockMode: CBC(iv: iv),padding: .pkcs5)
        let encryptedData = try aes.encrypt(Array("hello".utf8))
        print("Array data: \(Array("hello".utf8))")
    //            let encryptedString = String(decoding: encryptedData, as: UTF8.self)

        print("Encrypted Data \(encryptedData)")
    //            print("Encrypted Data \(encryptedString)")
        let base64String = encryptedData.toBase64()
        print("encrypted: \(base64String)")
        

        //to convert base64 string to Array
        guard let data = Data(base64EncodedURLSafe: "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") else {
            // handle errors in decoding base64 string here
            throw NSError()
        }//
        
        let bytes = data.map { $0 }

        print("decryted base64 \(bytes)")


    //            let encryptedStr = NSData(base64Encoded: encryptedString)
        print("Encrypted Data \(base64String)")
    //            Decryption

        let decryption = try! aes.decrypt(bytes)
        let decrypted = String(bytes: decryption, encoding: .utf8)
        print("Decrypted Data \(decrypted!)")
    }
    catch{
        print(error)
    }
}
encryption()
extension Data {
    init?(base64EncodedURLSafe string: String, options: Base64DecodingOptions = []) {
        let string = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        self.init(base64Encoded: string, options: options)
    }
}

extension Array where Element == UInt8 {
 func bytesToHex(spacing: String) -> String {
   var hexString: String = ""
   var count = self.count
   for byte in self
   {
       hexString.append(String(format:"%02X", byte))
       count = count - 1
       if count > 0
       {
           hexString.append(spacing)
       }
   }
   return hexString
}

}
