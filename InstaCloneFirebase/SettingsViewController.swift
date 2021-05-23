import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logoutClicked(_ sender: Any) {
        do{
            //uygulamadan firebase kullanarak çıkış yap ve giriş sayfasına yönlendir.
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("error")
        }
    }
}
