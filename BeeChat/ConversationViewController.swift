//
//  ViewController.swift
//  BeeChat
//
//  Created by administrator on 08/01/2022.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("CVC: -------------")
        // check to see if user is signed in using ... user defaults
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        print(isLoggedIn)
        // they are, stay on the screen. If not, show the login screen
        if !isLoggedIn {
            print("not logged in!! -> move to login vc")
            // present login view controller
            if let newModal = self.storyboard?.instantiateViewController(withIdentifier: "MyModal") {
                newModal.modalTransitionStyle = .crossDissolve
                newModal.modalPresentationStyle = .fullScreen
                present(newModal, animated: true, completion: nil)
              }
        }
    }

}

