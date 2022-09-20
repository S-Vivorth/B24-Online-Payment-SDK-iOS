import UIKit
import Foundation

var greeting = "Hello, playground"

var str = "\\u17a2\\u17c1\\u179f\\u17ca\\u17b8\\u179b\\u17b8\\u178a\\u17b6"
str = str.replacingOccurrences(of: "\\", with: "")
let split = str.split(separator: "u")
print(split)

var str1 = "17a2"
let result = Int(str1, radix: 16)!
var str2 = ""
for item in split {
    str2 = str2 + String(UnicodeScalar(Int(item, radix: 16)!)!)
}

print(str2)
var scalar = UnicodeScalar(result)!
//let str1 = "\\u{17a2}"
//print(type(of: str1))
//str = str.replacingOccurrences(of: "u", with: "u{") // "\u{1782\u{178e\u{1793"
////str = str.replacingOccurrences(of: "u", with: "}u")
////str = str.replacingOccurrences(of: "u", with: """
////\u
////""")
//str = str.replacingOccurrences(of: "", with: "u{")
//str = str + "}"
//str.replacingCharacters(in: "u", with: "}u") // "}\u{1782}\u{178e}\u{1793"
print(type(of: scalar))
print(scalar)
//
//if let index = str.index(str.startIndex, offsetBy: 0, limitedBy: str.endIndex) {
////    str.remove(at: index)
//
//    print(string)
//}
//else {
//}
