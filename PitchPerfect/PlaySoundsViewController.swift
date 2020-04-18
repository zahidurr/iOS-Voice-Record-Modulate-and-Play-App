//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Zahidur on 2020-04-17.
//  Copyright © 2020 Zahidur. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: Outlet
    @IBOutlet weak var changePlaybackRate: UISlider!
    
    @IBOutlet weak var snailButton: UIButton!
    
    @IBOutlet weak var rabbitButton: UIButton!
    
    @IBOutlet weak var chipmunkVaderButton: UIButton!
    
    @IBOutlet weak var echoButton: UIButton!
    
    @IBOutlet weak var reverbButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    
    var audioFile: AVAudioFile!
    
    var audioEngine: AVAudioEngine!
    
    var audioPlayerNode: AVAudioPlayerNode!
    
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        
        case chipmunkVader = 0, echo, reverb, slow, fast
        
    }
    var playbackRate: Float!
    
    
    // MARK: Actions
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
                        
        case .chipmunkVader:
            
            playSound(pitch: playbackRate)
            
        case .echo:
            
            playSound(echo: true)
            
        case .reverb:
            
            playSound(reverb: true)
            
        case .slow:
            
            playSound(rate: 0.5)
            
        case .fast:
            
            playSound(rate: 1.5)
            
        }
        
        configureUI(.playing)
        
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        
        
        stopAudio()
        
    }
    
    // MARK: set value for chipmunk or Vaderplayback rate when slider changed
    @IBAction func sliderButtonChanged(_ sender: Any) {
        
        playbackRate = round(changePlaybackRate.value)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupAudio()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        configureUI(.notPlaying)
        
    }
    
}
