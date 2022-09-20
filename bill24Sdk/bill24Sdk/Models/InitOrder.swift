
import Foundation

public struct InitOrder: Codable {
    public let data: DataClass
    public let result: Result
}

// MARK: - DataClass
public struct DataClass: Codable {
    public let encryptedData: String

    public enum CodingKeys: String, CodingKey {
        case encryptedData = "encrypted_data"
    }
}

// MARK: - Result
public struct Result: Codable {
    
    let resultStatus, resultMessageEn, resultMessageKh, resultCode: String

    public enum CodingKeys: String, CodingKey {
        case resultStatus = "result_status"
        case resultMessageEn = "result_message_en"
        case resultMessageKh = "result_message_kh"
        case resultCode = "result_code"
    }
}
