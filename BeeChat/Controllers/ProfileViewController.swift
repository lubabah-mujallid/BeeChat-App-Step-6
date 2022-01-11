
import FirebaseAuth
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewProfilePic.maskCircle(with: imageViewProfilePic.image!)
    }
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {
            [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                if let newModal = strongSelf.storyboard?.instantiateViewController(withIdentifier: "login") {
                    newModal.modalTransitionStyle = .crossDissolve
                    newModal.modalPresentationStyle = .fullScreen
                    strongSelf.present(newModal, animated: true, completion: nil)
                }
            }
            catch {
                print("failed to logout")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    
}
