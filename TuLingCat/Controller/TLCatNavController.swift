

import UIKit

class TLCatNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.tintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0)
        self.navigationBar.barTintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }

}
