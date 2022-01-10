import Foundation
import FirebaseDatabase


final class DatabaseManger {
    
    static let shared = DatabaseManger()
    private let database = Database.database().reference()
    
    public func test() {
        database.child("foo").setValue(["hello":"500 ones"])
    }
}

extension DatabaseManger {
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
        // will return true if the user email does exist already
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) {
            snapshot in
            guard snapshot.value as? String != nil else {
                // let's create the account
                completion(false)
                return
            }
            completion(true) // the caller knows the email exists already
        }
    }
    
    public func insertUser(with user: AppUser){
        database.child(user.safeEmail).setValue(["first_name":user.firstName,"last_name":user.lastName]
        )
    }
}

struct AppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    //let profilePictureUrl: String
    
    // create a computed property safe email
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
