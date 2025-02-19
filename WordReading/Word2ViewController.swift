//
//  Word2ViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/11.
//

import UIKit
import AVFoundation

class Word2ViewController: UIViewController {
    
    @IBOutlet weak var firstWord: UILabel!
    @IBOutlet weak var secondWord: UILabel!
    @IBOutlet weak var thirdWord: UILabel!
    @IBOutlet weak var fourthWord: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
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
        firstWord.text = " "
        secondWord.text = " "
        thirdWord.text = " "
        fourthWord.text = " "
    }
    
    @IBAction func nextStepButton(_ sender: UIButton) {
        tapButton += 1
        sender.isEnabled = false
        print(tapButton)
        
        if tapButton == 1 {
            firstWord.text = characterArray[0]
            secondWord.text = " "
            thirdWord.text = " "
            fourthWord.text = " "
            soundFirst()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
            print(firstWord.text!)
        }else if tapButton == 2 {
            firstWord.text = " "
            secondWord.text = characterArray[1]
            thirdWord.text = " "
            fourthWord.text = " "
            soundSecond()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
            
        }else if tapButton == 3 {
            firstWord.text = " "
            secondWord.text = " "
            thirdWord.text = characterArray[2]
            fourthWord.text = " "
            soundThird()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
        }else if tapButton == 4 {
            firstWord.text = " "
            secondWord.text = " "
            thirdWord.text = " "
            fourthWord.text = characterArray[3]
            soundForth()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
        }else if tapButton == 5 {
            firstWord.text = characterArray[0]
            secondWord.text = characterArray[1]
            thirdWord.text = characterArray[2]
            fourthWord.text = characterArray[3]
            soundWord()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                sender.isEnabled = true
            }
        }else if tapButton == 6 {
            firstWord.text = " "
            secondWord.text = " "
            thirdWord.text = " "
            fourthWord.text = " "
            image.image = UIImage(named: "\(selectedWord!)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
        }else {
            self.performSegue(withIdentifier: "toLastVC", sender: self)
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
