import UIKit
import CryptoSwift
var greeting = "Hello, playground"



func encryption() {
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
    print(key)

    let keyString = key.toHexString()

    print("Password to hexa: \(password.toHexString())")
    print("Salt to hexa: \(salt.toHexString())")
    print("key \(String(keyString.prefix(16)))")
    /* Generate random IV value. IV is public value. Either need to generate, or get it from elsewhere */
    let iv:Array<UInt8> = Array(keyString.prefix(16).utf8)

    print(iv)
    //         AES cryptor instance

    do {

        let aes = try AES(key: key, blockMode: CBC(iv: iv))
        let encryptedData = try aes.encrypt(Array("hello".utf8))
    //            let encryptedString = String(decoding: encryptedData, as: UTF8.self)

        print("Encrypted Data \(encryptedData)")
    //            print("Encrypted Data \(encryptedString)")
        let base64String = encryptedData.toBase64()
        print("encrypted: \(base64String)")


        //to convert base64 string to Array
        guard let data = Data(base64EncodedURLSafe: "N30yxirqcstQBHqZebCut/fHoVZEM/YV6bFPC1arfo+g3SzBNNdSEa4SGIlk/U6R") else {
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
        print("Decrypted Data \(decrypted)")
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
