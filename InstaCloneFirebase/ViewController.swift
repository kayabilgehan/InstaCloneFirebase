import UIKit
import Firebase

//1. Öncelikle Firebase üzerinden projeyi oluşturduk.
//2. GoogleService-Info.plist i indirip proje içine attık.
//3. Firebase ile ilgili podları yüklüyoruz ve workspace dosyası ile projeyi açıyoruz.
//4. Firebase kodlarını AppDelegate e ekliyoruz.
//5. Tabbar Ekledikten sonra segue ayarlarından
    //Present Modally -> Presentation: Fullscreen yapıyoruz

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Halihazırda bir kullanıcı login olmuşsa o kullanıcı ile doğrudan giriş yap işlemini SceneDelegate içinde yapıyoruz
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            //Auth sınıfından auth objesi oluşturuyoruz
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "An error occured. Please try again")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else {
            self.makeAlert(title: "Error", message: "E-mail or Password error")
        }
        
        //performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            //Auth sınıfından auth objesi oluşturuyoruz
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                //Closure
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "An error occured. Please try again")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else {
            self.makeAlert(title: "Error", message: "E-mail or Password error")
        }
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

