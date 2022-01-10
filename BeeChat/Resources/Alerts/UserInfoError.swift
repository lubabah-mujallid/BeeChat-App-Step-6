//
//  UserInfoError.swift
//  BeeChat
//
//  Created by administrator on 10/01/2022.
//
import UIKit
import Foundation

class UserInfoError {
    static func alert(error: String, view: UIViewController) {
        let alert = UIAlertController(title: "Login Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
