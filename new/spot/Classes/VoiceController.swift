//
//  VoiceController.swift
//  spot
//
//  Created by Hikaru on 2015/03/12.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import AVFoundation

class VoiceController :NSObject,AVAudioRecorderDelegate{
    
    private var recorder:AVAudioRecorder!
    private var player:AVAudioPlayer!
    private var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    private var path_wav = ""
    private var path_amr = ""
    //インスタンス
    class var instance : VoiceController {
        struct Static {
            static let instance : VoiceController = VoiceController()
        }
        return Static.instance
    }
    
    //初期化
    private override init() {
        super.init()
        self.path_wav = "\(paths[0])/recorder.wav"//"\(paths[0])/recorder\(NSDate.timeIntervalSinceReferenceDate() * 1000.0).wav"
        self.path_amr = "\(paths[0])/recorder.amr"//"\(paths[0])/recorder\(NSDate.timeIntervalSinceReferenceDate() * 1000.0).amr"
    }
    
    private func setup(){
        /*
        NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
        //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
        [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
        [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
        //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
        [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
        [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
        [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
        [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
        nil];
        */
        var recordSettings =
        [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 8000.00,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            //AVLinearPCMIsNonInterleaved:false,
            //AVLinearPCMIsBigEndianKey: false,
            //AVLinearPCMIsFloatKey: false,
        ]
        var error:NSErrorPointer = nil
        
        recorder = AVAudioRecorder(URL: NSURL(fileURLWithPath: self.path_wav), settings: recordSettings, error: error)
        recorder.delegate = self
        recorder.meteringEnabled = true
        //creates the file and gets ready to record. happens automatically on record.
        let res = recorder.prepareToRecord()
        println("\(res)")
        println("\(error)")

    }
    func start(){
        if nil == recorder {
            self.setup()
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord,error: nil)
            AVAudioSession.sharedInstance().setActive(true, error: nil)
            
            let status = recorder.record() //start or resume
            println("\(status)")
        }
    }
    func stop()->String?{
        if nil != recorder {
            recorder.stop()
            self.wavToAmr(self.path_wav, savePath: self.path_amr)
            recorder = nil;
            return self.path_amr
        }
        return nil
    }

    func playOrStopTest() {
        if player != nil {
            if player.playing {
                player.stop()
                player = nil
                return
            } else {
                player.stop()
                player = nil
            }
        }
        
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "amr")
        
        play(path)
    }
    
    func playOrStop(data: NSData) {
        if player != nil {
            if player.playing {
                player.stop()
                player = nil
                return
            } else {
                player.stop()
                player = nil
            }
        }
        
        let path = paths[0].stringByAppendingPathComponent("test.amr")
        data.writeToFile(path, atomically: true)
        
        play(path)
    }

    func play(path:String!){
        /////
        self.amrToWav(path, savePath: self.path_wav)
        /////
        player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: self.path_wav), error: nil)
//        player.delegate = self
        AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: nil)
        
        player.prepareToPlay()
        player.play()
        println("play")
    }
    
    func wavToAmr(wavPath:String,savePath:String){
        EncodeWAVEFileToAMRFile(wavPath.cStringUsingEncoding(NSUTF8StringEncoding)!,savePath.cStringUsingEncoding(NSUTF8StringEncoding)!,1,16)
    }
    func amrToWav(amrPath:String,savePath:String){
        DecodeAMRFileToWAVEFile(amrPath.cStringUsingEncoding(NSUTF8StringEncoding)!,savePath.cStringUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    
}