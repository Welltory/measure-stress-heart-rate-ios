import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if cornerRadius > 0 {
                layer.masksToBounds = true
            }
        }
    }
}
