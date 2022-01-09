import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var textFieldsUserInfo: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LVC: ----------------------------")
        
        

        
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        
        // Firebase Login
        Auth.auth().signIn(withEmail: textFieldsUserInfo[0].text!, password: textFieldsUserInfo[1].text!, completion: { authResult, error in
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(String(describing: authResult?.user.email))")
                return
            }
            let user = result.user
            print("logged in user: \(user)")
        })
    }
    
    //later add and connect google btns
    
}
