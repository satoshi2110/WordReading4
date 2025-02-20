//
//  Word2ViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/11.
//

import UIKit
import AVFoundation

class Word2ViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var firstWord: UIButton!
    @IBOutlet weak var secondWord: UIButton!
    @IBOutlet weak var thirdWord: UIButton!
    @IBOutlet weak var fourthWord: UIButton!
    
    var csvArray: [String] = []
    var characterArray: [String] = []
    var tapButton = 0
    var selectedWord: String?
    var selectedCharacter: String?
    var audioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        csvArray = loadCSV(fileName: "\(selectedWord!)")
        characterArray = csvArray[0].components(separatedBy: ",")
        
        firstWord.setTitleColor(UIColor.black, for:.normal)
        secondWord.setTitleColor(UIColor.black, for: .normal)
        thirdWord.setTitleColor(UIColor.black, for: .normal)
        fourthWord.setTitleColor(UIColor.black, for: .normal)
        
        firstWord.setTitle(characterArray[0], for: .normal)
        secondWord.isHidden = true
        thirdWord.isHidden = true
        fourthWord.isHidden = true
        
    }
    @IBAction func firstWordButton(_ sender: UIButton) {
        soundFirst()
        firstWord.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.firstWord.isHidden = true
            self.secondWord.isHidden = false
            self.secondWord.setTitle(self.characterArray[1], for: .normal)
        }
    }
    
    @IBAction func secondWordButton(_ sender: UIButton) {
        soundSecond()
        secondWord.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.secondWord.isHidden = true
            self.thirdWord.isHidden = false
            self.thirdWord.setTitle(self.characterArray[2], for: .normal)
        }
    }
    @IBAction func thirdWordButton(_ sender: UIButton) {
        soundThird()
        thirdWord.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.thirdWord.isHidden = true
            self.fourthWord.isHidden = false
            self.fourthWord.setTitle(self.characterArray[3], for: .normal)
        }
    }
    
    @IBAction func forthWordButton(_ sender: UIButton) {
        soundForth()
        fourthWord.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.fourthWord.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.soundWord()
            self.firstWord.isHidden = false
            self.firstWord.setTitle(self.characterArray[0], for: .normal)
            self.secondWord.isHidden = false
            self.secondWord.setTitle(self.characterArray[1], for: .normal)
            self.thirdWord.isHidden = false
            self.thirdWord.setTitle(self.characterArray[2], for: .normal)
            self.fourthWord.isHidden = false
            self.fourthWord.setTitle(self.characterArray[3], for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){ [self] in
            image.image = UIImage(named: "\(self.selectedWord!)")
            firstWord.isHidden = true
            secondWord.isHidden = true
            thirdWord.isHidden = true
            fourthWord.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            self.presentingViewController?.dismiss(animated: true)
        }
    }
   
    
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        return csvArray
    }
    
    func soundFirst() {
        let selectedCharacter = characterArray[0]
        let url = Bundle.main.url(forResource: "\(selectedCharacter)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    
    func soundSecond() {
        let selectedCharacter = characterArray[1]
        let url = Bundle.main.url(forResource: "\(selectedCharacter)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    
    func soundThird() {
        let selectedCharacter = characterArray[2]
        let url = Bundle.main.url(forResource: "\(selectedCharacter)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    
    func soundForth() {
        let selectedCharacter = characterArray[3]
        let url = Bundle.main.url(forResource: "\(selectedCharacter)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    
    func soundWord() {
        let url = Bundle.main.url(forResource: "\(selectedWord!)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
}
