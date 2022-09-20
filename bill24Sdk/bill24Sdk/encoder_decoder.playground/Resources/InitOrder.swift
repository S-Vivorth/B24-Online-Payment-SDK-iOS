
import Foundation

struct InitOrder: Codable {
    let data: DataClass
    let result: Result
}

// MARK: - DataClass
struct DataClass: Codable {
    let encryptedData: String

    enum CodingKeys: String, CodingKey {
        case encryptedData = "encrypted_data"
    }
}

// MARK: - Result
struct Result: Codable {
    let resultStatus, resultMessageEn, resultMessageKh, resultCode: String

    enum CodingKeys: String, CodingKey {
        case resultStatus = "result_status"
        case resultMessageEn = "result_message_en"
        case resultMessageKh = "result_message_kh"
        case resultCode = "result_code"
    }
}
