import UIKit

class LibVC: UIViewController {
    
    private var topicTV: TopicTV!
    private var slidesTV: SlidesTV!
    private var topics = Topics()
    
    private var idTopic: Int! {
        didSet {
            self.slides = Slides(idTopic: self.idTopic ?? 0)
        }
    }
    private var slides = Slides(idTopic: 1)
    
    @IBAction func btSearh(_ sender: UIBarButtonItem) {
        print("btSearh")
        runSearh()
    }
    
    @IBOutlet weak var labelNamePresent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.labelNamePresent.text = ReportsWords.shared.libraries
        
        self.slidesTV = SlidesTV(frame: self.view.frame)
        self.topicTV = TopicTV(frame: self.view.frame, topics: topics)
        self.slidesTV.separatorStyle = .none
            
        topicTV.delegate = self
        slidesTV.delegate = self
        slidesTV.dataSource = self

        self.view.addSubview(self.slidesTV)
        self.view.addSubview(self.topicTV)
    }
}

extension LibVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        switch tableView {
        case self.topicTV:
            return self.topics.listTopic.count
        case self.slidesTV:
            return self.slides.listSlides.count
        default: ()
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
            case self.slidesTV:
                let cell = slidesTV.dequeueReusableCell(withIdentifier: "slideCellIdentifier", for: indexPath) as! SlideTVCell
                cell.slide = slides.listSlides[indexPath.row]
                return cell
            
            default: ()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
            case self.topicTV:
                print("case self.topicTV:")
                self.idTopic = topics.listTopic[indexPath.row].id
                self.slidesTV.reloadData()
                
            case self.slidesTV:
                let storyboard: UIStoryboard = UIStoryboard(name: "SlideVCSB", bundle: nil)
                let controller: SlideVC = storyboard.instantiateViewController(withIdentifier: "ControllerIdentifier") as! SlideVC
                                
                let slide = self.slides.listSlides[indexPath.row]
                controller.slide = slide
                controller.modalPresentationStyle = .fullScreen
                
                self.present(controller, animated: true) {
                    controller.playSound(sound: slide.sound)
            }
                
            default: ()
        }
    }
}

// FIXME: - delete after
extension LibVC {
    
    func runSearh() {
        let storyboard: UIStoryboard = UIStoryboard(name: "SearhSB", bundle: nil)
        let controller: SearchVC = storyboard.instantiateViewController(withIdentifier: "SearchIdSb") as! SearchVC
        controller.modalPresentationStyle = .fullScreen
        
        self.present(controller, animated: true, completion: nil)
    }
}
