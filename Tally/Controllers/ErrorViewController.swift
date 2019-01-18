import UIKit

class ErrorViewController: UIViewController {
    
    @IBAction func tryAgainButtonHandler() {
        self.dismiss(animated: true, completion: nil)
    }
}

