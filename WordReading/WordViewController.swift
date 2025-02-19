//
//  WordViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/10.
//

import UIKit
import AVFoundation

class WordViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var thirdWord: UILabel!
    @IBOutlet weak var secondWord: UILabel!
    @IBOutlet weak var firstWord: UILabel!
    
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
        firstWord.text = ""
        secondWord.text = ""
        thirdWord.text = ""
        
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        tapButton += 1
        sender.isEnabled = false
        
        if tapButton == 1 {
            firstWord.text = characterArray[0]
            secondWord.text = " "
            thirdWord.text = " "
            soundFirst()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
        }else if tapButton == 2 {
            firstWord.text = " "
            secondWord.text = characterArray[1]
            thirdWord.text = " "
            soundSecond()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
        }else if tapButton == 3 {
            firstWord.text = " "
            secondWord.text = " "
            thirdWord.text = characterArray[2]
            soundThird()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                sender.isEnabled = true
            }
        }else if tapButton == 4 {
            firstWord.text = characterArray[0]
            secondWord.text = characterArray[1]
            thirdWord.text = characterArray[2]
            soundWord()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                sender.isEnabled = true
            }
        }else if tapButton == 5 {
            firstWord.text = ""
            secondWord.text = ""
            thirdWord.text = ""
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
        print(selectedCharacter)
        
    }
    
    func soundSecond() {
        let selectedCharacter = characterArray[1]
        let url = Bundle.main.url(forResource: "\(selectedCharacter)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
        print(selectedCharacter)
    }
    
    func soundThird() {
        let selectedCharacter = characterArray[2]
        let url = Bundle.main.url(forResource: "\(selectedCharacter)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
        print(selectedCharacter)
    }
    
    func soundWord() {
        let url = Bundle.main.url(forResource: "\(selectedWord!)", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
}

