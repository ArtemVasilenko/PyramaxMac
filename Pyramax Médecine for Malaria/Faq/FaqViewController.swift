import UIKit

class FaqViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.addSubview(SlideView(Slide(), frameSlide: CGRect(x: 20, y: self.view.frame.height / 2, width: self.view.frame.width - 20, height: self.view.frame.height / 2)))
    }
}
