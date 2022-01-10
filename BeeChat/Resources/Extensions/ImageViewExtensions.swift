
import Foundation
import UIKit

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
