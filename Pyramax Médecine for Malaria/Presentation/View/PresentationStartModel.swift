import UIKit

protocol ContentDelegate {
    func uploadSlideVC(slide: Int)
}

class SlideValues {
    var slides: Slides!
    lazy var autoSlide = false
    lazy var presentationName = String()
    lazy var choiseStandart = true
    lazy var playAudio = true
    lazy var progress = Float()
}

let logoPresent = ["logoPresent1", "logoPresent2", "logoPresent3", "logoPresent4", "logoPresent5", "logoPresent6"]

struct Logo {
    var name: String
    var image: UIImage
    var choose: Bool
}

struct Logos {
    
    static var shared: Logos = Logos()
    var listLogo = [Logo]()
    
    mutating func fillInLogo() {
        self.listLogo = []
        
        for name in logoPresent {
            if let image = UIImage(named: name) {
                self.listLogo.append(Logo(name: name, image: image, choose: false))
            }
        }
    }
}

struct UserInfo {
    
    static var shared = UserInfo()
    
    let namePresenter = User.shared.name
    let lasteNamePresenter = User.shared.lastName
    let function = User.shared.function
    let presentTitle = "Presentation standart title"
}

struct Storyboards {
    
    enum nameSB: String {
        case main = "Main"
        case presentStart = "PresentationStartSB"
        case help = "HelpSB"
        case search = "SearchSB"
        case library = "LibSB"
        case report = "ReportSB"
        case faq = "Faq"
    }
    
    
    enum nameIdentity: String {
        case tabBarVC = "TabBarVC"
        case contentVC = "contentVC"
        case selectCoverVC = "SelectCoverVC"
        case slideVC = "SlideViewController"
        case prepareScreenVC = "PrepareScreenVC"
        case selectLogoVC = "SelectLogoViewController"
        case presentStartVC = "PresentationStartVC"
        case reportVC = "ReportVC"
        case mainVC = "MainVC"
        case helpVC = "HelpVC"
        case libraryVC = "libraries"
        case reportAfterSlide = "ReportAfterSlide"
        case selectLogoTableView = "SelectLogoTableView"
        case faqVC = "faq"
    }
    
}

