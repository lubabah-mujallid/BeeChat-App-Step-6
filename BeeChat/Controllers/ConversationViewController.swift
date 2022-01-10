//
//  ViewController.swift
//  BeeChat
//
//  Created by administrator on 08/01/2022.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        print("CVC: viewDidLoad -----------------------------------------")
        super.viewDidLoad()
        DatabaseManger.shared.test()
    }

}

