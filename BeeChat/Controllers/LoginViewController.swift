
//clean up loginbtnpressed more

import  FBSDKLoginKit
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var textFieldsUserInfo: [UITextField]!
    @IBOutlet weak var btnFaceBook: FBLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LVC: ----------------------------")
        textFieldsUserInfo[0].delegate = self
        textFieldsUserInfo[1].delegate = self
        btnFaceBook.delegate = self
        self.hideKeyboardWhenTappedAround()
        btnFaceBook.permissions = ["public_profile", "email"]
    }
    
    //login user user firebase
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
            if let newModal = strongSelf.storyboard?.instantiateViewController(withIdentifier: "tabBar") {
                newModal.modalTransitionStyle = .crossDissolve
                newModal.modalPresentationStyle = .fullScreen
                strongSelf.present(newModal, animated: true, completion: nil)
            }
            
        })
    }
        
}

//delegate for the text field return btns
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

//login user with facebook extension
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("user failed to log with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        facebookRequest.start(completion: {
            _, result, error in
            guard let result = result as? [String: Any], error == nil else {
                print("failed to make facebook graph request, error: \(error)")
                return
            }
            print(result)
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                print("failed to get name an email from fb result")
                return
            }
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {
                return
            }
            
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManger.shared.userExists(with: email, completion: {
                exists in
                if !exists {
                    DatabaseManger.shared.insertUser(with: AppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
            })
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credential, completion: {
                [weak self] authResult, error in
                guard let strongSelf = self else { return }
                guard authResult != nil, error == nil else {
                    print("face credential login failed, MFA needed, error: \(error)")
                    return
                }
                print("succesfully logged user in with facebook")
                if let newModal = strongSelf.storyboard?.instantiateViewController(withIdentifier: "tabBar") {
                    newModal.modalTransitionStyle = .crossDissolve
                    newModal.modalPresentationStyle = .fullScreen
                    strongSelf.present(newModal, animated: true, completion: nil)
                }
            })
        })
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    
}
