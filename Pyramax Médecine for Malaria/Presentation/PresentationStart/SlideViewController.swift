import UIKit
import AVFoundation

class SlideViewController: UIViewController, ContentDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var downProgress: UIProgressView!
    @IBOutlet weak var upperProgress: UIProgressView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logoCollectionView: UICollectionView!
    @IBOutlet weak var previewLogoCollectionView: UICollectionView!
    @IBOutlet weak var previewPresentationTitle: UILabel!
    @IBOutlet weak var previewDescription: UILabel!
    @IBOutlet weak var previewUserAvatar: UIImageView!
    @IBOutlet weak var previewUserName: UILabel!
    @IBOutlet weak var previewUserFunction: UILabel!
    @IBOutlet weak var previewLogo: UIImageView!
    @IBOutlet weak var upsideNavigationView: UIView!
    @IBOutlet weak var presentationNameInUpsideNavView: UILabel!
    @IBOutlet weak var downsideNavigationView: UIView!
    @IBOutlet weak var contentButtonOutlet: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var gearButtonOutlet: UIButton!
    @IBOutlet weak var userInfoOutlet: UILabel!
    
    var slideValues = SlideValues()
    var slideNumber = 0

    private var selectLogos = [Logo]()
    private var logos = Logos.shared.listLogo
    private var tapView = true
    private var timer = Timer()
    private var timerOn = true
    private var audioPlayer = AVAudioPlayer()
    private var slideView: SlideView?
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if self.slideValues.autoSlide && self.slideNumber != self.slideValues.slides.listSlides.count - 1 {
            self.slideView?.removeFromSuperview()

            self.slideNumber += 1
            self.downProgress.progress += self.valueProgress()
            self.upperProgress.progress += self.valueProgress()
            self.changeSlide(number: self.slideNumber)
            self.view.addSubview(self.slideView ?? SlideView(Slide(html: "", id: 51, name: ""), frameSlide: self.view.frame))
        }
    }
    
    fileprivate func bringSubviewsInPreviewSlide(_ bringSubviewsInPreviewSlide: Bool) {
        if bringSubviewsInPreviewSlide {
            self.view.bringSubviewToFront(previewLogoCollectionView)
            self.view.bringSubviewToFront(previewPresentationTitle)
            self.view.bringSubviewToFront(previewUserFunction)
            self.view.bringSubviewToFront(previewDescription)
            self.view.bringSubviewToFront(previewUserAvatar)
            self.view.bringSubviewToFront(previewUserName)
            self.view.bringSubviewToFront(previewLogo)
        } else {
            self.previewLogoCollectionView.isHidden = true
            self.previewPresentationTitle.isHidden = true
            self.previewUserFunction.isHidden = true
            self.previewDescription.isHidden = true
            self.previewUserAvatar.isHidden = true
            self.previewUserName.isHidden = true
            self.previewLogo.isHidden = true
        }
    }
    
    func previewSlide() {
        if self.slideNumber == 0 {
            self.previewPresentationTitle.text = self.slideValues.presentationName
            self.bringSubviewsInPreviewSlide(true)
            self.logoCollectionView.isHidden = true
            self.previewUserFunction.text = User.shared.function
            
            if self.slideValues.choiseStandart == true {
                self.previewLogoCollectionView.isHidden = false
                self.previewDescription.isHidden = true
                self.previewUserName.text = "\(User.shared.name) \(User.shared.lastName)"
            }
        } else {
            self.logoCollectionView.isHidden = false
            self.bringSubviewsInPreviewSlide(false)
        }
    }
    
    func uploadPreviewSlide() {
        guard self.slideValues.slides.listSlides[0].id != 51 else { return }
        self.slideValues.slides.listSlides.insert(Slide(html: "", id: 51, name: ""), at: 0)
    }
    
    fileprivate func returnToMainView() {
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.main.rawValue, bundle: nil)
        let controller: TabBarVC = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.tabBarVC.rawValue) as! TabBarVC
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true) {
            
            controller.updateTabBar(slideValues: self.slideValues, presentCVTouch: true, presentButtonHidden: true, slideNumber: self.slideNumber)
        }
    }
    
    fileprivate func openReportView() {
        self.autoScroll(on: false)
        self.audioPlayer.stop()
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.report.rawValue, bundle: nil)
        let controller: ReportAfterSlideViewController = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.reportAfterSlide.rawValue) as! ReportAfterSlideViewController
        controller.presentationName = self.slideValues.presentationName
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    fileprivate func autoScroll(on: Bool) {
        
        if self.slideValues.autoSlide && on {
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: {
                timer in
                self.slideView!.removeFromSuperview()
                
                if self.slideNumber != self.slideValues.slides.listSlides.count - 1 {
                    self.slideNumber += 1
                    self.downProgress.progress += self.valueProgress()
                    self.upperProgress.progress += self.valueProgress()
                    if self.slideNumber == self.slideValues.slides.listSlides.count - 1 {
                        self.timer.invalidate()
                    }
                }
                self.changeSlide(number: self.slideNumber)
                self.view.addSubview(self.slideView!)
                self.gearButtonOutlet.isHidden = false
            })
            
        } else {
            self.timer.invalidate()
        }
    }
    
    fileprivate func stateNavigationsButtons(slideNum: Int) {
        
        if slideNum == 0 || slideNum == 1  {
            self.previousButton.isEnabled = false
        } else {
            self.previousButton.isEnabled = true
        }
    }
    
    fileprivate func visibilityControlElements() {
        self.previousButton.isHidden = true
        self.nextButton.isHidden = true
        self.upsideNavigationView.isHidden = true
        self.downsideNavigationView.isHidden = true
        self.tapView = true
    }
    
    fileprivate func changeSlide(number: Int) {
        let slide = self.slideValues.slides.listSlides[number]
        
        self.slideView = SlideView(slide, frameSlide: CGRect(x: 0, y: 95, width: self.view.frame.width, height: self.view.frame.height))
        
        self.stateNavigationsButtons(slideNum: number)
        self.previewSlide()
        self.visibilityControlElements()
        
        
        if self.slideValues.slides.listSlides[number].sound?.isEmpty ?? false || self.slideValues.slides.listSlides[number].sound == nil {
            self.audioPlayer.stop()
            if self.slideValues.autoSlide {
                self.autoScroll(on: true)
            }
        } else {
            self.autoScroll(on: false)
            if self.slideValues.playAudio {
                self.playSound(sound: self.slideValues.slides.listSlides[number].sound)
            } else if self.slideValues.autoSlide {
                self.autoScroll(on: true)
            }
        }
        
        print("""
            ### SLIDE INFO ###
            ### NAME PRESENTATION = \(self.slideValues.presentationName),
            ### SLIDE IN PRESENTATION № -> \(number),
            ### SLIDE ID = \(self.slideValues.slides.listSlides[number].id)
            ### AUTOSLIDE = \(self.slideValues.autoSlide),
            ### PLAY SOUND = \(self.slideValues.playAudio),
            ### SOUND = \(String(describing: self.slideValues.slides.listSlides[number].sound))
            """)
    }
    
    fileprivate func addSelectLogos() {
        for i in logos {
            if i.choose {
                selectLogos.append(i)
            }
        }
    }
    
    fileprivate func valuesDesigne() {
        self.downsideNavigationView.layer.masksToBounds = true
        self.downsideNavigationView.layer.cornerRadius = 15
        
        self.previousButton.isHidden = true
        self.nextButton.isHidden = true
        
        self.nextButton.layer.masksToBounds = true
        self.nextButton.layer.cornerRadius = 0.5 * self.nextButton.bounds.size.width
        
        self.previousButton.layer.masksToBounds = true
        self.previousButton.layer.cornerRadius = 0.5 * self.previousButton.bounds.size.width
        
        self.upperProgress.transform = upperProgress.transform.scaledBy(x: 1, y: 2)
        
//        self.presentationNameInUpsideNavView.text = self.slideValues.presentationName
        
        self.addShinPoong()
        
        let date = Date(timeIntervalSinceNow: 86400)
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .short

        let dateString = dateFormatter.string(from: date)
        
        self.userInfoOutlet.text = "\(User.shared.name) \(User.shared.lastName), \(dateString)"
        
        self.previewUserAvatar.image = User.shared.avatar
        
    }
    
    func valueProgress() -> Float {
        let value = Float(1.0) / Float(self.slideValues.slides.listSlides.count)
        return value
    }
    
    fileprivate func pushNavigation() {
        if self.tapView == true {
            self.gearButtonOutlet.isHidden = true
            
            if self.slideNumber == 0 || self.slideNumber == 1 {
                self.nextButton.isHidden = false
                self.upsideNavigationView.isHidden = false
                if self.slideValues.autoSlide == true {
                    self.downsideNavigationView.isHidden = false
                }
                self.view.bringSubviewToFront(self.nextButton)
                self.view.bringSubviewToFront(self.upsideNavigationView)
                self.view.bringSubviewToFront(self.downsideNavigationView)
                self.tapView = false
            } else {
                self.previousButton.isHidden = false
                self.nextButton.isHidden = false
                self.upsideNavigationView.isHidden = false
                if self.slideValues.autoSlide == true {
                    self.downsideNavigationView.isHidden = false
                }
                self.view.bringSubviewToFront(self.previousButton)
                self.view.bringSubviewToFront(self.nextButton)
                self.view.bringSubviewToFront(self.upsideNavigationView)
                self.view.bringSubviewToFront(self.downsideNavigationView)
                self.tapView = false
            }
            
        } else {
            self.previousButton.isHidden = true
            self.nextButton.isHidden = true
            self.upsideNavigationView.isHidden = true
            self.downsideNavigationView.isHidden = true
            self.tapView = true
        }
    }
    
    override func viewDidLoad() {
//        self.tapOnView()
        self.valuesDesigne()
        self.swipeGesture()
        
        self.downProgress.progress += self.valueProgress()
        self.upperProgress.progress += self.valueProgress()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.changeSlide(number: self.slideNumber)
        self.view.addSubview(self.slideView!)
        
        self.addSelectLogos()
        self.previewSlide()
        self.downProgress.setProgress(self.valueProgress(), animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.previousButton.isHidden = true
        self.nextButton.isHidden = true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func gearButton(_ sender: UIButton) {
        self.pushNavigation()
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.openReportView()
    }
    
    @IBAction func pauseButtonFromNav(_ sender: UIButton) {
        
        guard let playPresent = UIImage(named: "playNew") else {
            return
        }
        
        guard let pausePresent = UIImage(named: "presentPause") else {
            return
        }
        
        if self.timerOn == true {
            self.pauseButton.setImage(playPresent, for: .normal)
            self.timerOn = false
            self.autoScroll(on: false)
            self.audioPlayer.pause()
        } else {
            self.pauseButton.setImage(pausePresent, for: .normal)
            self.timerOn = true
            self.autoScroll(on: true)
            self.audioPlayer.play()
        }
        
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.timer.invalidate()
        self.slideView!.removeFromSuperview()
        self.gearButtonOutlet.isHidden = false
        
        if self.slideNumber != self.slideValues.slides.listSlides.count - 1 {
            self.slideNumber += 1
            self.changeSlide(number: slideNumber)
            self.view.addSubview(self.slideView!)
            self.downProgress.progress += self.valueProgress()
            self.upperProgress.progress += self.valueProgress()
        } else {
            self.openReportView()
        }
        
        guard let pausePresent = UIImage(named: "presentPause") else {
            return
        }
        self.pauseButton.setImage(pausePresent, for: .normal)
    }
    
    @IBAction func previosButtonAction(_ sender: UIButton) {
        self.timer.invalidate()
        self.slideView!.removeFromSuperview()
        self.gearButtonOutlet.isHidden = false

        self.downProgress.progress -= self.valueProgress()
        self.upperProgress.progress -= self.valueProgress()
        
        if self.slideNumber != 0 {
            self.slideNumber -= 1
        }
        
        self.changeSlide(number: slideNumber)
        self.view.addSubview(self.slideView!)
        
        guard let pausePresent = UIImage(named: "presentPause") else {
            return
        }
        self.pauseButton.setImage(pausePresent, for: .normal)
    }
    
    @IBAction func contentButton(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
        let controller: ContentViewController = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.contentVC.rawValue) as! ContentViewController
        controller.slides = self.slideValues.slides
        self.autoScroll(on: false)
        
        self.present(controller, animated: true) {
            controller.delegate = self
        }
    }
    
    @IBAction func collapsButton(_ sender: UIButton) {
        self.audioPlayer.pause()
        self.autoScroll(on: false)
        
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.main.rawValue, bundle: nil)
        
        let controller: TabBarVC = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.tabBarVC.rawValue) as! TabBarVC
        controller.modalPresentationStyle = .fullScreen

        
        self.present(controller, animated: true) {
            self.slideValues.progress = self.upperProgress.progress
            controller.updateTabBar(slideValues: self.slideValues, presentCVTouch: false, presentButtonHidden: false, slideNumber: self.slideNumber)
            
            self.view.removeFromSuperview()

        }
    }
    
    // MARK: - ContentVC delegate func
    func uploadSlideVC(slide: Int) {
        self.slideView?.removeFromSuperview()
        self.gearButtonOutlet.isHidden = false
        self.timerOn = true

        self.changeSlide(number: slide)
        self.view.addSubview(self.slideView!)
        self.slideNumber = slide

        self.upperProgress.progress = self.valueProgress() * Float(slide + 1)
        self.downProgress.progress = self.valueProgress() * Float(slide + 1)
        
    }
}


//MARK: - CollectionView delegate
extension SlideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectLogos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LogoSlideCollectionViewCell
        cell.logoImage.image = selectLogos[indexPath.row].image
        return cell
    }
}
//MARK: - SWIPE, TAP
extension SlideViewController {
    
    fileprivate func swipeGesture() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        leftSwipeGesture.direction = .left
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc func swipeLeft(_ gesture: UISwipeGestureRecognizer) {
        self.timer.invalidate()
        self.slideView!.removeFromSuperview()
        
        if self.slideNumber != self.slideValues.slides.listSlides.count - 1 {
            self.slideNumber += 1
            self.changeSlide(number: slideNumber)
            self.view.addSubview(self.slideView!)
            self.downProgress.progress += self.valueProgress()
            self.upperProgress.progress += self.valueProgress()
        } else {
            self.openReportView()
        }
        
        guard let pausePresent = UIImage(named: "presentPause") else {
            return
        }
        self.pauseButton.setImage(pausePresent, for: .normal)
    }
    
    @objc func swipeRight(_ gesture: UISwipeGestureRecognizer) {
        self.timer.invalidate()
        self.slideView!.removeFromSuperview()
        self.downProgress.progress -= self.valueProgress()
        self.upperProgress.progress -= self.valueProgress()
        
        if self.slideNumber != 0 {
            self.slideNumber -= 1
        }
        
        self.changeSlide(number: slideNumber)
        self.view.addSubview(self.slideView!)
        
        guard let pausePresent = UIImage(named: "presentPause") else {
            return
        }
        self.pauseButton.setImage(pausePresent, for: .normal)
    }
    
    func tapOnView() {
        let clickOnView = UITapGestureRecognizer(target: self, action: #selector (tap(_:)))
        clickOnView.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(clickOnView)
        clickOnView.delegate = self
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        self.pushNavigation()
    }
    
    //MARK: - Notification option (not work)
    //    @objc func openedSlideFromContent(notification: Notification) {
    //
    //        guard let contentSlides = notification.userInfo else { return }
    //        guard let slideFromContent = contentSlides["slide"] as? Int else { return }
    //
    //        print(self.slides.listSlides)
    //
    //
    //        if slideFromContent <= self.slideValues.slides.listSlides.count {
    //            self.view.addSubview(addSlideView(number: slideFromContent))
    //            self.slideNumber = slideFromContent
    //        } else {
    //            self.view.addSubview(addSlideView(number: 1))
    //            self.slideNumber = slideFromContent
    //            print("CRASH!!!")
    //        }
    //    }
}
//MARK: - Add shinPoong logo
extension SlideViewController {
    func addShinPoong() {
        guard let imageShinPoong = UIImage(named: "Shin_poong") else { return }
        let shinPoongImgView = UIImageView(image: imageShinPoong)
        shinPoongImgView.frame = CGRect(x: 0, y: 0, width: 155, height: 20)
        self.view.addSubview(shinPoongImgView)
        
        shinPoongImgView.translatesAutoresizingMaskIntoConstraints = false
        
        shinPoongImgView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        shinPoongImgView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
    }
}
//MARK: - Sound func
extension SlideViewController {
    
    func playSound(sound: Data?) {
        do {
            self.audioPlayer = try AVAudioPlayer(data: sound ?? Data())
            self.audioPlayer.delegate = self
            print(audioPlayer)
            self.audioPlayer.play()
            
        } catch {
            print("mp3 sound error \(error)")
        }
    }
}

