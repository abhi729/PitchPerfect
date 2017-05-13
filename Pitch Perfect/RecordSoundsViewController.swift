//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abhishek Agarwal on 21/03/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordStatusLabel: UILabel!
    
    func setupUIButtons(_ isRecording: Bool) {
        recordStatusLabel.text = isRecording ? "Recording in progress.." : "Tap to record!"
        recordButton.isEnabled = !isRecording
        stopButton.isEnabled = isRecording
    }
    
    func startRecordingAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecordingAudio() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    @IBAction func recordAudio(_ sender: Any) {
        setupUIButtons(true)
        startRecordingAudio()
    }

    @IBAction func stopRecording(_ sender: Any) {
        setupUIButtons(false)
        stopRecordingAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To prevent the button images from stretching.
        recordButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode = .scaleAspectFit
        
        stopButton.isEnabled = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioUrl
        }
    }
}

