import UIKit
import AVFoundation

class SlideVC: UIViewController, AVAudioPlayerDelegate {
        
    var slide = Slide()
    private var audioPlayer = AVAudioPlayer()
    
    @IBAction func btBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        let slideView = SlideView(slide, frameSlide: CGRect(x: 0, y: 95, width: self.view.frame.width, height: self.view.frame.height))
        
        slideView.isUserInteractionEnabled = true
        self.view.addSubview(slideView)
                
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SlideVC {
    
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
