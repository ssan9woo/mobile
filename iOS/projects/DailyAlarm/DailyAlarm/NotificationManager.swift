import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    let authorizationOption = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
    let title = "상우의 알람"
    let body = "일어나세요 ⏰"
    
    init() {
//        requestNotificationAuthorization()
//        print("notification ON")
    }
    
    func requestNotificationAuthorization() {
        self.userNotificationCenter.requestAuthorization(options: authorizationOption) { success, error in
            if let error = error {
                print("Notification Authorization Error!!!\(error.localizedDescription )")
            }
        }
    }
    
    // Quick Alarm - title, body, Interval
    func addQuickAlarm(interval: Int, id: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = self.title
        notificationContent.body = self.body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
        let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("--> notification request error!!\(error.localizedDescription)")
            }
        }
    }
    
    // Normal Alarm - title, body(label), week, time(Hour + Minute)
    func addNormalAlarm(id:String, label: String, week:[Int], hour:Int, minute: Int) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = self.title
        notificationContent.body = label
        
        for week in week {
            let dateComponent = DateComponents(hour: hour, minute: minute, weekday: week)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
            userNotificationCenter.add(request) { error in
                if let error = error {
                    print("--> notification request error!!\(error.localizedDescription)")
                }
            }
        }
    }
    
    // Delete Noti
    func removeNotification(id: String){
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
