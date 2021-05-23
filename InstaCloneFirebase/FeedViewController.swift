import UIKit
import Firebase
import SDWebImage

//resimleri indirmek için SDWebImage tool unu kullanıyoruz.

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documenIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore() {
        let firestoreDatabase = Firestore.firestore()
        
        //firestore db sinin ayarlarını ayarlıyoruz. Eski versiyonlarda aşağıdaki ayarların yapılması gerekiyormuş
        //let settings = firestoreDatabase.settings
        //Aşağıdaki ayar depreched olmuş. depreched olmasaydı aşağıdaki kodu kullanacaktık
        //settings.areTimestampsInSnapshotsEnabled = true
        //firestoreDatabase.settings = settings
        
        
        //firebase db sine anlık bağlanmak ve her güncellemeden haberimizin olması için aşağıdaki listener i kuruyoruz
        firestoreDatabase.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "An error occured")
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documenIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        //print(documentId)
                        self.documenIdArray.append(documentId)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(describing: likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView?.image = UIImage(named: "select")
        
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]), completed: nil)
        
        cell.documentIdLabel.text = documenIdArray[indexPath.row]
        return cell
    }
}
