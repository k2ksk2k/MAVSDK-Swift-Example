import UIKit
import MAVSDK_Swift
import RxSwift

class CameraActionViewController: UIViewController {
    
	@IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var capturePicture: UIButton!
    @IBOutlet weak var setPhotoMode: UIButton!
    @IBOutlet weak var videoLabel: UIButton!
    @IBOutlet weak var setVideoMode: UIButton!
    @IBOutlet weak var photoIntervalLabel: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    var mediaPlayer = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackLabel.text = "Welcome"
        feedbackLabel?.layer.masksToBounds = true
        feedbackLabel?.layer.borderColor = UIColor.lightGray.cgColor
        feedbackLabel?.layer.borderWidth = 1.0
        feedbackLabel?.layer.cornerRadius = UI_CORNER_RADIUS_BUTTONS
        
        capturePicture.layer.cornerRadius = UI_CORNER_RADIUS_BUTTONS
        setPhotoMode.layer.cornerRadius = UI_CORNER_RADIUS_BUTTONS
        videoLabel.layer.cornerRadius = UI_CORNER_RADIUS_BUTTONS
        setVideoMode.layer.cornerRadius = UI_CORNER_RADIUS_BUTTONS
        photoIntervalLabel.layer.cornerRadius = UI_CORNER_RADIUS_BUTTONS
        
        self.cameraView.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Play example rtsp stream
        let url = URL(string: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov")
        
        let media = VLCMedia(url: url!)
        mediaPlayer.media = media
        mediaPlayer.delegate = self as? VLCMediaPlayerDelegate
        mediaPlayer.drawable = self.cameraView
        
        //TODO modify this
        mediaPlayer.play()
    }
    
    @IBAction func capturePicture(_ sender: UIButton) {
        let myRoutine = drone.camera.takePhoto()
            .do(onError: { error in self.feedbackLabel.text = "Photo Capture Failed : \(error.localizedDescription)" },
                onCompleted: { self.feedbackLabel.text = "Photo Capture Success" })
        _ = myRoutine.subscribe()
    }
    
    @IBAction func videoAction(_ sender: UIButton) {
        if(videoLabel.titleLabel?.text == "Start Video") {
            let myRoutine = drone.camera.startVideo()
                .do(onError: { error in self.feedbackLabel.text = "Start Video Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Start Video Success"
                        self.videoLabel.setTitle("Stop Video", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
            
        else {
            let myRoutine = drone.camera.stopVideo()
                .do(onError: { error in self.feedbackLabel.text = "Stop Video Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Stop Video Success"
                        self.videoLabel.setTitle("Start Video", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
        
    }
    
    @IBAction func photoIntervalAction(_ sender: UIButton) {
        let intervalTimeS = 3
        if(photoIntervalLabel.titleLabel?.text == "Start Photo Interval") {
            let myRoutine = drone.camera.startPhotoInterval(intervalS: Float(intervalTimeS))
                .do(onError: { error in self.feedbackLabel.text = "Start Photo Interval Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Start Photo Interval Success"
                        self.photoIntervalLabel.setTitle("Stop Photo Interval", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
        else {
            let myRoutine = drone.camera.stopPhotoInterval()
                .do(onError: { error in self.feedbackLabel.text = "Stop Photo Interval Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Stop Photo Interval Success"
                        self.photoIntervalLabel.setTitle("Start Photo Interval", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
        
    }
    
    @IBAction func setPhotoMode(_ sender: UIButton) {
        let myRoutine = drone.camera.setMode(cameraMode: Camera.CameraMode.photo)
            .do(onError: { error in self.feedbackLabel.text = "Set Photo Mode Failed : \(error.localizedDescription)" },
                onCompleted: {  self.feedbackLabel.text = "Set Photo Mode Success" })
        _ = myRoutine.subscribe()
    }
    
    @IBAction func setVideoMode(_ sender: UIButton) {
        let myRoutine = drone.camera.setMode(cameraMode: Camera.CameraMode.video)
            .do(onError: { error in self.feedbackLabel.text = "Set Video Mode Failed : \(error.localizedDescription)" },
                onCompleted: {  self.feedbackLabel.text = "Set Video Mode Success" })
        _ = myRoutine.subscribe()
    }
    
    class func showAlert(_ message: String?, viewController: UIViewController?) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true) {() -> Void in }
    }
}
