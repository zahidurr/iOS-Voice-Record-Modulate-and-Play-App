//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Zahidur on 2020-04-17.
//  Copyright © 2020 Zahidur. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder : AVAudioRecorder!
    
    // MARK: Outlet
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    enum RecordingState {
        case  recording
        case  notRecording
    }
    
    // MARK: Alerts
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let StartRecording = "Tap to Record"
        static let RecordingProgress = "Recording in progress"
        static let RecordingFailedMessage = "Something went wrong with your recording"
    }
    
    // MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(.notRecording)
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(.recording)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } catch {
            showAlert(Alerts.RecordingFailedMessage, message: String(describing: error))
            return
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        } catch {
            showAlert(Alerts.RecordingFailedMessage, message: String(describing: error))
            return
        }
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        configureUI(.notRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            recordingLabel.text = Alerts.RecordingFailedMessage
        }
    }
    
    // MARK: UI Functions
    func  configureUI(_ recordingState: RecordingState) {
         switch recordingState {
               case .recording:
                setRecordingStatus(true, Alerts.RecordingProgress)
               case .notRecording:
                setRecordingStatus(false, Alerts.StartRecording)
        }
    }
    
    func setRecordingStatus(_ enabled: Bool, _ text: String) {
        recordButton.isEnabled = !enabled
        stopRecordingButton.isEnabled = enabled
        recordingLabel.text = text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


