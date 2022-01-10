
//clean up loginbtnpressed more
//register btn needs to go somewhere correctly


import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var textFieldsUserInfo: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LVC: ----------------------------")
        textFieldsUserInfo[0].delegate = self
        textFieldsUserInfo[1].delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {

        // Firebase Login
        Auth.auth().signIn(withEmail: textFieldsUserInfo[0].text!, password: textFieldsUserInfo[1].text!, completion: {
            [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(String(describing: authResult?.user.email))")
                UserInfoError.alert(error: error!.localizedDescription, view: strongSelf)
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            // if this succeeds, dismiss
            strongSelf.dismiss(animated: true, completion: nil)
        })
    }
    
    //later add and connect google btns
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldsUserInfo[0] {
            textFieldsUserInfo[1].becomeFirstResponder()
        }
        else if textField == textFieldsUserInfo[1] {
            loginBtnPressed(textField)
        }
        return true
    }
}
