import UIKit

class TabBarVC: UITabBarController {
    
    private let homeViewController: MainViewController = {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.main.rawValue, bundle: nil)
        let homeVC: MainViewController = mainStoryboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.mainVC.rawValue) as! MainViewController
        
        return homeVC
    }()
    
    
    private let faqViewController: FaqViewController = {
        let faqStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.faq.rawValue, bundle: nil)
        let faqVC: FaqViewController = faqStoryboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.faqVC.rawValue) as! FaqViewController

        return faqVC
    }()
    
    private let libraryViewController: LibVC = {
        let libraryStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.library.rawValue, bundle: nil)
        let libraryVC: LibVC = libraryStoryboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.libraryVC.rawValue) as! LibVC
        
        return libraryVC
    }()

    private let reportNavViewController: UINavigationController = {
        let reportStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.main.rawValue, bundle: nil)
        let reportVC: ReportViewController = reportStoryboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.reportVC.rawValue) as! ReportViewController
        
        let reportNavVC = UINavigationController(rootViewController: reportVC)
        return reportNavVC
    }()
    
    func updateTabBar(slideValues: SlideValues, presentCVTouch: Bool, presentButtonHidden: Bool, slideNumber: Int) {
        self.homeViewController.slideValues = slideValues
        self.homeViewController.slideNumber = slideNumber
                
        self.homeViewController.addPresentButton(hidden: presentButtonHidden)
        self.homeViewController.presentationsCollectionView.isUserInteractionEnabled = presentCVTouch
        
        if presentCVTouch == false {
            self.homeViewController.presentationsCollectionView.alpha = 0.2
            self.homeViewController.presentationsCollectionView.isPrefetchingEnabled = false
        }
        
        if DB().getListReports(false).count != 0 {
            self.reportNavViewController.tabBarItem.badgeValue = String(DB().getListReports(false).count)
        } else {
            self.reportNavViewController.tabBarItem.badgeValue = nil
        }
        
    }
    
    fileprivate func tabBarFormation() {
        
        if DB().getListReports(false).count != 0 {
            self.reportNavViewController.tabBarItem.badgeValue = String(DB().getListReports(false).count)
        } else {
            self.reportNavViewController.tabBarItem.badgeValue = nil
        }
        
        guard self.viewControllers == nil else { return }
        self.viewControllers = [homeViewController, libraryViewController, faqViewController, reportNavViewController]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarFormation()
    }
    
    
    deinit {
        print("tabbar deinit")
    }
    
}
