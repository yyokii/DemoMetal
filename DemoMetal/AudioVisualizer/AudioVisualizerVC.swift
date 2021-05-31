//
//  AudioVisualizerVC.swift
//  DemoMetal
//
//  Created by Higashihara Yoki on 2021/06/01.
//

import Accelerate
import AVFoundation
import Cocoa

class AudioVisualizerVC: NSViewController {
    var audioVisualizer : AudioVisualizer!
    var engine : AVAudioEngine!
    let fftSetup = vDSP_DFT_zop_CreateSetup(nil, 1024, vDSP_DFT_Direction.FORWARD)
    var prevRMSValue : Float = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioVisualizer = AudioVisualizer()
        view.addSubview(audioVisualizer)
        
        //constraining to window
        audioVisualizer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        audioVisualizer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        audioVisualizer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        audioVisualizer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        setupAudio()
    }
    
    func setupAudio(){
        /* Setup & Start Engine */
        
        //initialize it
        engine = AVAudioEngine()
        
        //initialzing the mainMixerNode singleton which will connect to the default output node
        _ = engine.mainMixerNode
        
        //prepare and start
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print(error)
        }
        
        //first we need the resource url for our file
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else {
            print("mp3 not found")
            return
        }
        
        //now we need to create our player node
        let player = AVAudioPlayerNode()
        
        do {
            //player nodes have a few ways to play-back music, the easiest way is from an AVAudioFile
            let audioFile = try AVAudioFile(forReading: url)
            
            //audio always has a format, lets keep track of what the format is as an AVAudioFormat
            let format = audioFile.processingFormat
            
            //we now need to connect add the node to our engine. This part is a little weird but we first need
            //to attach it to the engine itself before connecting it to the mainMixerNode. Recall that the
            //mainMixerNode connects to the default outputNode, so now we'll have a complete playback path from
            //our file to the outputNode!
            engine.attach(player)
            engine.connect(player, to: engine.mainMixerNode, format: format)
            
            //let's play the file!
            //note: player must be attached first before scheduling a file to play
            player.scheduleFile(audioFile, at: nil, completionHandler: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //tap it to get the buffer data at playtime
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { (buffer, time) in
            self.processAudioData(buffer: buffer)
            
        }
        
        //start playing the music!
        player.play()
    }
    
    func processAudioData(buffer: AVAudioPCMBuffer){
        guard let channelData = buffer.floatChannelData?[0] else {return}
        let frames = buffer.frameLength
        
        let rmsValue = SignalProcessing.rms(data: channelData, frameLength: UInt(frames))
        
        let interpolatedResults = SignalProcessing.interpolate(current: rmsValue, previous: prevRMSValue)
        prevRMSValue = rmsValue
        
        let fftMagnitudes =  SignalProcessing.fft(data: channelData, setup: fftSetup!)
    }
}
