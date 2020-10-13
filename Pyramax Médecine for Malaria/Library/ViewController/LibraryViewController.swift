import UIKit

class LibraryViewController: UIViewController {
    
    let indCell = "IndCell"
    var topics = Topics().listTopic
    
    @IBOutlet weak var libCollectV: UICollectionView!
    
    @IBAction func btBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        
        libCollectV.dataSource = self
        libCollectV.delegate = self
    }
}

extension LibraryViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.1 , height: collectionView.frame.width/2.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        topics.sort(by: {$0.id > $1.id})
        
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: indCell, for: indexPath) as? LibCollectionVCell
        
        itemCell!.topic = topics[indexPath.row]
                
        return itemCell!
    }
}
