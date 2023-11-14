import Foundation
import Firebase

struct User {
    var name: String
    var email: String
    var profileImageUrl: String?
    var id: String?

}


struct Message {
    var fromId: String
    var text: String
    var timeStamp: Int
    var toId: String
    
    func partnerId() -> String {
        return Auth.auth().currentUser?.uid == toId ? fromId : toId
    }
}
