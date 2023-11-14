import Foundation
import AVFoundation

struct NormalAlarm {
    var isOn: Bool
    var label: String
    var time: String
    var day: [Int]
    var id: String
}

struct QuickAlarm {
    var time: Int
    var isOn: Bool
    var id: String
}
