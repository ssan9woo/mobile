import Foundation

extension Date {
    static func getTime(dt: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko")
        let time = formatter.string(from: date)
        
        return time
    }
    
    static func getDay(dt: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee"
        formatter.locale = Locale(identifier: "ko")
        let day = formatter.string(from: date)
        
        return day
    }
    
    static func timezoneToTime(timezone: String) -> String {
        let formatter = DateFormatter()
        let date = Date()
        
        formatter.timeZone = TimeZone(identifier: timezone)
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
}
