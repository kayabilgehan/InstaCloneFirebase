import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        //print("like button clicked")
        
        
        if let likes = Int(likeLabel.text!) {
            let documentId = documentIdLabel.text
            
            let firestoreDatabase = Firestore.firestore()
            
            let likeStore = ["likes" : likes + 1] as [String: Any]
            
            firestoreDatabase.collection("Posts").document(documentId!).setData(likeStore, merge: true)
        }
        
        
    }
    
}
