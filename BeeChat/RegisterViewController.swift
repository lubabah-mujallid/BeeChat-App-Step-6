

// take photo from camera not working
// keyboard pod
//set textfield text types and keyboard types and return btn

//store user info


import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    
    @IBOutlet var textFieldsProfileInfo: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfilePicUI()
    }
    
    @IBAction func addPicBtnPressed(_ sender: UIButton) {
        showPhotoAlert()
        
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        
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

//this extension is to make the profile pic circular
extension UIImageView {
    public func maskCircle(with image: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 5.0
        self.image = image
    }
}

