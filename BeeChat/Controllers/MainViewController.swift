import FirebaseAuth
import UIKit

class MainViewController: UIViewController {
    //this is the root view controller -- the logo page

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MVC: viewDidLoad -----------------------------------------")
        do {
            try Auth.auth().signOut()
        }
        catch {
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MVC: viewDidAppear -----------------------------------------")
        validateAuth()
    }

    private func validateAuth(){
        // current user is set automatically when you log a user in copy
        if Auth.auth().currentUser == nil {
            print("not logged in!! -> move to login vc")
            // present login view controller
            if let newModal = self.storyboard?.instantiateViewController(withIdentifier: "login") {
                newModal.modalTransitionStyle = .crossDissolve
                newModal.modalPresentationStyle = .fullScreen
                present(newModal, animated: true, completion: nil)
              }
        }
        else {
            print("logged in!! -> move to conversations vc")
            performSegue(withIdentifier: "tabBarSegue", sender: self)
        }
    }
    
}


