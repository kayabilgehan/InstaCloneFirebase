import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    //Info.plist içine aşağıdaki satırı ekleyip kullanıcıdan galeri izni alınırken gösterilecek mesajı belirtiyoruz
    //Privacy - Photo Library Usage Description
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true;
        present(pickerController, animated: true, completion: nil)
    }
    //image pick işlemi biitnce aşağıdaki fonksiyon çalışıyor.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadButtonClicked(_ sender: Any) {
        //Firebase storage nesnesi oluştur
        let storage = Storage.storage()
        //referans: upload edinen dosyanın hangi klasöre kaydedileceğini belirtiyor
        let storageReference = storage.reference()
        //klasör ismini belirt(sunucuda klasör yoksa otomatik oluşturur)
        let mediaFolder = storageReference.child("media")
        
        //resmi dataya dönüştürüp kaydet
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            //mediafolder altına resim için bir referans uluştur
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error occured")
                }
                else {
                    //kaydedilen dosya ile ilgili bilgileri alıyoruz
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            
                            //DATABASE işlemleri
                            //Veritabanı nesnesi oluştur
                            let firestoreDatabase = Firestore.firestore()
                            
                            //bir referans objesi oluştur. Bu tablolar gibi bir bölüm
                            var firestoreReference: DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl": imageUrl!,
                                                 "postedBy": Auth.auth().currentUser!.email!,
                                                 "postComment": self.commentText.text!,
                                                 "date": FieldValue.serverTimestamp(),
                                                 "likes": 0
                            ] as [String : Any]
                            
                            //referans nesnesini firebase de oluştur ve veriyi kaydet
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error occured")
                                }
                                else{
                                    //post kaydedilince formu sıfırla ve kullanıcıyı feed e at
                                    self.imageView.image = UIImage(named: "select")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
            }
            
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
