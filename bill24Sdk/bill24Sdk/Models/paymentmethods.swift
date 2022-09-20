
import Foundation



struct Paymentmethods: Codable {
    let paymentMethods: [PaymentMethod]

    enum CodingKeys: String, CodingKey {
        case paymentMethods = "payment_methods"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let currency, bankNameEn: String
    let supportCheckoutPage: Bool
    let bankLogo: String
    let supportTokenize: Bool
    let fee: Int
    let supportDeeplink, supportInapp, bankID, bankNameKh: String

    enum CodingKeys: String, CodingKey {
        case currency
        case bankNameEn = "bank_name_en"
        case supportCheckoutPage = "support_checkout_page"
        case bankLogo = "bank_logo"
        case supportTokenize = "support_tokenize"
        case fee
        case supportDeeplink = "support_deeplink"
        case supportInapp = "support_inapp"
        case bankID = "bank_id"
        case bankNameKh = "bank_name_kh"
    }
}

//struct payment_methods : Decodable{
//    let currency: String
//    let bank_name_en: String
//    let support_checkout_page: Bool
//    let bank_logo: String
//    let support_tokenize: Bool
//    let fee: Double
//    let support_deeplink: Bool
//    let support_inapp: Bool
//    let bank_id: String
//    let bank_name_kh: String
//}
//struct paymentMethodsResponse: Decodable {
//    let payment_methods: [payment_methods]
//}
