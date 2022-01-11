

//store user info

import FirebaseAuth
import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    
    @IBOutlet var textFieldsProfileInfo: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfilePicUI()
        textFieldsProfileInfo[0].delegate = self
        textFieldsProfileInfo[1].delegate = self
        textFieldsProfileInfo[2].delegate = self
        textFieldsProfileInfo[3].delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func addPicBtnPressed(_ sender: UIButton) {
        showPhotoAlert()
        
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        guard let fname = textFieldsProfileInfo[0].text,
              let lname = textFieldsProfileInfo[1].text,
              let email = textFieldsProfileInfo[2].text,
              let password = textFieldsProfileInfo[3].text,
              !fname.isEmpty, !lname.isEmpty
        else {
            print("fname or lname is empty")
            UserInfoError.alert(error: "First or Last name is empty", view: self)
            return
        }
        
        DatabaseManger.shared.userExists(with: email, completion: {
            [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                UserInfoError.alert(error: "User already exists", view: strongSelf)
                return
            }
            Auth.auth().createUser(withEmail: email, password: password, completion: {
                authResult , error  in
                
                guard authResult != nil, error == nil else {
                    print("Error creating user, error:\(String(describing: error)), result:\(String(describing: authResult))")
                    UserInfoError.alert(error: error!.localizedDescription, view: strongSelf)
                    return
                }
                let user = AppUser(firstName: fname, lastName: lname, emailAddress: email)
                DatabaseManger.shared.insertUser(with: user)
                print("Created User: \(user)")
                if let newModal = strongSelf.storyboard?.instantiateViewController(withIdentifier: "tabBar") {
                    newModal.modalTransitionStyle = .crossDissolve
                    newModal.modalPresentationStyle = .fullScreen
                    strongSelf.present(newModal, animated: true, completion: nil)
                }
            })
        })
    }
}

//this extension deals with the profile pic
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func updateProfilePicUI() {
        let image = imageViewProfilePic.image!
        imageViewProfilePic.maskCircle(with: image)
    }
    
    func showPhotoAlert() {
        let actionSheet = UIAlertController(title: "Pick Profile Picture: ", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.getPhoto(type: .camera)
            }
            else {
                print("Cant use camera on simulator")
                //return
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            self.getPhoto(type: .photoLibrary)
        }))
        present(actionSheet, animated: true)
    }
    
    func getPhoto(type: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = type
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // action sheet - take photo or choose photo
        dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("image not found")
            return
        }
        self.imageViewProfilePic.maskCircle(with: selectedImage)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

//this extensions is for the text fields return btns
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case textFieldsProfileInfo[0]:
                textFieldsProfileInfo[1].becomeFirstResponder()
            case textFieldsProfileInfo[1]:
                textFieldsProfileInfo[2].becomeFirstResponder()
            case textFieldsProfileInfo[2]:
                textFieldsProfileInfo[3].becomeFirstResponder()
            default:
                registerBtnPressed(textField)
        }
        return true
    }
}
