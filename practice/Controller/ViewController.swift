//
//  ViewController.swift
//  practice
//
//  Created by 柴田将吾 on 2020/06/20.
//  Copyright © 2020 柴田将吾. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import LanguageTranslator
import Firebase


class ViewController: UIViewController, UINavigationControllerDelegate {
    
    var isRecording = false
    let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en_EN"))!
    
    var audioEngine: AVAudioEngine!
    var recognitionReq: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    @IBOutlet weak var englishLabel: UILabel!
    
    
    var EnglishString = String()
    
    var JapaneseString = String()
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var honTextView: UITextView!
    

    
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine()
        englishLabel.layer.borderColor = UIColor.black.cgColor
        englishLabel.layer.borderWidth = 1.0
        honTextView.text = ""
        honTextView.layer.borderColor = UIColor.black.cgColor
        honTextView.layer.borderWidth = 1.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
          DispatchQueue.main.async {
            if authStatus != SFSpeechRecognizerAuthorizationStatus.authorized {
              self.recordButton.isEnabled = false
                
            }
          }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    
    
    
    func stopLiveTranscription() {
      audioEngine.stop()
      audioEngine.inputNode.removeTap(onBus: 0)
      recognitionReq?.endAudio()
    }
    
    func startLiveTranscription() throws {

      if let recognitionTask = self.recognitionTask {
        recognitionTask.cancel()
        self.recognitionTask = nil
      }
      englishLabel.text = ""

      
      recognitionReq = SFSpeechAudioBufferRecognitionRequest()
      guard let recognitionReq = recognitionReq else {
        return
      }
      recognitionReq.shouldReportPartialResults = true

      
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
      let inputNode = audioEngine.inputNode

      
      let recordingFormat = inputNode.outputFormat(forBus: 0)
      inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { (buffer, time) in
        recognitionReq.append(buffer)
      }
      audioEngine.prepare()
      try audioEngine.start()

      recognitionTask = recognizer.recognitionTask(with: recognitionReq, resultHandler: { (result, error) in
        if let error = error {
          print("\(error)")
        } else {
          DispatchQueue.main.async {
            self.englishLabel.text = result?.bestTranscription.formattedString
            
            }
        }
      })
    }
    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        if isRecording {
            stopLiveTranscription()
            recordButton.setTitle("録音", for: .normal)
        }else{
            try! startLiveTranscription()
            recordButton.setTitle("終了", for: .normal)
        }
        
        isRecording = !isRecording
        
    }
    

    
    @IBAction func translateButtonTapped(_ sender: Any) {
        honTextView.text = ""
        let authenticator = WatsonIAMAuthenticator(apiKey: "H0UmYmZXjxXMl2uJ4qUi3_XHTWQ2uIn4denfT8DNurSv")
        let languageTranslator = LanguageTranslator(version: "2020-06-24", authenticator: authenticator)
        languageTranslator.serviceURL = "https://api.jp-tok.language-translator.watson.cloud.ibm.com/instances/7299b232-7917-4a35-9af9-b5cfeff1b348"
        if englishLabel.text != ""{
            languageTranslator.translate(text: ["\(String(englishLabel.text!))"], modelID: "en-ja", source: "en", target: "ja") {
              response, error in

                guard let translation = response?.result else {
                print(error?.localizedDescription ?? "unknown error")
                return
              }
                DispatchQueue.main.async {
                  self.honTextView.text = translation.translations[0].translation
                    self.EnglishString =  self.englishLabel.text!
                }
                
                
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func save(_ sender: Any) {
        englishLabel.text = EnglishString
        if englishLabel.text! != "" && honTextView.text! != ""{
            let DB = Database.database().reference().child(uid!).childByAutoId()
            
            
            let content = ["English": englishLabel.text!, "Japanese":honTextView.text!]
            
            DB.setValue(content) { (error, result) in
                if error != nil{
                    print(error)
                }else{
                    print("成功しました")
                }
            }
            
        }
        
        
    }
    
    
    
}

