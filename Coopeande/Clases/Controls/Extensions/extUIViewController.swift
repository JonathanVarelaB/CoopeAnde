import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func maxLenght(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > 0 {
            if (textField.text!.count > maxLength) {
                textField.deleteBackward()
            }
        }
    }
}
