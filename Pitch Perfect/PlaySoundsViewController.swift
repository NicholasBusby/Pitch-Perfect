//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nicholas Busby on 3/22/15.
//  Copyright (c) 2015 Nicholas Busby. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the page up for playing audio
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //the next functions control the playing of audio
    @IBAction func slowPlayButton(sender: UIButton) {
        playAudio(0.5)
    }

    @IBAction func fastPlayButton(sender: UIButton) {
        playAudio(2.0)
    }
    
    @IBAction func chipmonkPlayButton(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func vaderPlayButton(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudioPlayback(sender: UIButton) {
        audioEngine.stop()
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1.0
    }
    
    //this function is for fast and slow playback
    private func playAudio(speed: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        
        audioPlayer.play()
    }
    
    //this function is for chipmunk and vader playback
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
