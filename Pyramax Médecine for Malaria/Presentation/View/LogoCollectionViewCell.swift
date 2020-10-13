import UIKit

class LogoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoStatus: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
        
    override var isSelected: Bool {
        didSet {
            if !isSelected {
                logoStatus.isHidden = true
            } else {
                logoStatus.isHidden = false
            }
        }
    }
}
