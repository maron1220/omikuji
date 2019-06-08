//
//  ViewController.swift
//  omikuziApp
//
//  Created by 細川聖矢 on 2019/06/08.
//  Copyright © 2019 Seiya. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //音楽再生用の変数｡AVFoundationをimportしているから使用できる｡
    var resultAudioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    var beforeAudioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var stickView: UIView!
    
    @IBOutlet weak var stickLabel: UILabel!
    
    @IBOutlet weak var stickHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stickBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var overView: UIView!
    
    let resultTexts: [String] = [
        "大吉",
        "中吉",
        "小吉",
        "吉",
        "末吉",
        "凶",
        "大凶"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //サウンド再生を準備する関数
        setUpSound()
        beginSound()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        
        self.beforeAudioPlayer.play()
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion != UIEvent.EventSubtype.motionShake || overView.isHidden == false {
            // "!=" not equal
            //motionshakeじゃないとき または isHiddenがfalseのとき｡
            return //シェイクモーション以外では動作させない
        }
        
        //初期位置が変わったらshakeを受け入れないようにする｡
        if /*motion == UIEvent.EventSubtype.motionShake &&*/ stickBottomMargin.constant != 0{
            return
        }
        
       
        //UIntになおしてrandomにいれてからIntに直している
        //UIntじゃないとrandom関数が使えない
        //random関数｡7(resultTexts.count)までの範囲でランダムに整数を返す｡
        let resultNum = Int(arc4random_uniform(UInt32(resultTexts.count)))
        stickLabel.text = resultTexts[resultNum]
        
        //stickHeight分だけ下に動いてくる↓
        stickBottomMargin.constant = stickHeight.constant * -1
        
        UIView.animate(withDuration:5 , animations: {
            self.view.layoutIfNeeded()/*layoutでanimationを作成する場合に良い感じに作ってくれる*/
        },completion: {(finished:Bool) in /*completionはanimationが終わったあとの処理*/
            
            self.bigLabel.text = self.stickLabel.text
            //bigLabelの字とstickLabel(おみくじの文字)の字を同じにする↑
            self.overView.isHidden = false //Hiddenを見せる状態にする↑
            //音を鳴らす↓
            self.resultAudioPlayer.play()
            
        })
    }
    @IBAction func tapRetryButton(_ sender: Any) {
        overView.isHidden = true
        stickBottomMargin.constant = 0 //棒の位置を初期位置に戻す
    }
    
    func setUpSound(){
        //Bundle.main.path ファイルが置いてある場所｡
        //そのファイルがある場所までのpathがしっかり通っているとき
        if let sound = Bundle.main.path(forResource: "drum", ofType: ".mp3"){
            //try! 例外が発生したらスキップする
            resultAudioPlayer = try! AVAudioPlayer(contentsOf:URL(fileURLWithPath: sound))
            
            resultAudioPlayer.prepareToPlay()
        }
    }
    
    func beginSound(){
        //Bundle.main.path ファイルが置いてある場所｡
        //そのファイルがある場所までのpathがしっかり通っているとき
        if let sound = Bundle.main.path(forResource: "bell", ofType: ".mp3"){
            //try! 例外が発生したらスキップする
            beforeAudioPlayer = try! AVAudioPlayer(contentsOf:URL(fileURLWithPath: sound))
            
            beforeAudioPlayer.prepareToPlay()
        }
    }
}



