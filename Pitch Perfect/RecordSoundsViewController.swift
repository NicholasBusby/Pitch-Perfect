//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nicholas Busby on 3/18/15.
//  Copyright (c) 2015 Nicholas Busby. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        //make sure that all elements on this view are in the right state
        stopButton.hidden = true
        microphoneButton.enabled = true
        infoLabel.hidden = false
        recordingInProgress.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        //set the elements to the right state for recording
        microphoneButton.enabled = false
        infoLabel.hidden = true
        recordingInProgress.hidden = false
        stopButton.hidden = false
        
        //setup the recording proecess and start recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //if recorded successfully segue to the next view with the information
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else { //else save some metrics and setup so the user can try again
            println("recording was not successful")
            stopButton.hidden = true
            microphoneButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if we are following the stopRecording segue then we should build the playSoundsVC and pass it the data
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecordingAudio(sender: UIButton) {
        //when the stop button is pressed clean a few things up
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recordingInProgress.hidden = true
        stopButton.hidden = true
    }
}

