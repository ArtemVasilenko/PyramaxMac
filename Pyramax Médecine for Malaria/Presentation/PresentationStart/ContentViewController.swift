import UIKit

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var contentTableView: UITableView!
    
    var delegate: ContentDelegate?
    var slides: Slides! {
        didSet {
            print("IN CONTETNT \(slides.listSlides.count)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.slides.listSlides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SlideContentTableViewCell
                
        let slide = self.slides.listSlides[indexPath.row]

        if indexPath.row < 9 {
            cell.slideName.text = "0\(indexPath.row + 1)   \(slide.name)"
        } else {
            cell.slideName.text = "\(indexPath.row + 1)   \(slide.name)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let numberOfslide = indexPath.row + 1
        delegate?.uploadSlideVC(slide: numberOfslide)
        
        self.dismiss(animated: true, completion: nil)
        
// notification
//        let numberOfslide = indexPath.row + 1
//        let contentSlides = ["slide": numberOfslide]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "slide"), object: nil, userInfo: contentSlides)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.slides.listSlides.removeFirst()
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


