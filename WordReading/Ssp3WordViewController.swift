//
//  WordViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/10.
//

import UIKit
import AVFoundation

class Ssp3WordViewController: UIViewController {
    
    @IBOutlet weak var imageB: UIButton!
    @IBOutlet weak var firstWord: UIButton!
    @IBOutlet weak var secondWord: UIButton!
    @IBOutlet weak var thirdWord: UIButton!
    
    var csvArray: [String] = []
    var characterArray: [String] = []
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
        
        if let imageName = selectedWord, let originalImage = UIImage(named: imageName) {
            imageB.setImage(originalImage, for: .normal)
            imageB.imageView?.contentMode = .scaleAspectFit
        }

        
        firstWord.setTitle(characterArray[0], for: .normal)
        secondWord.isHidden = true
        thirdWord.isHidden = true
        
        imageB.isHidden = true
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
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.soundWord()
            self.firstWord.isHidden = false
            self.firstWord.setTitle(self.characterArray[0], for: .normal)
            self.secondWord.isHidden = false
            self.secondWord.setTitle(self.characterArray[1], for: .normal)
            self.thirdWord.isHidden = false
            self.thirdWord.setTitle(self.characterArray[2], for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){ [self] in
            self.firstWord.isHidden = true
            self.secondWord.isHidden = true
            self.thirdWord.isHidden = true
            imageB.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    @IBAction func imageButton(_ sender: UIButton) {
        soundEffects()
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
    
    func soundEffects() {
        if let url = Bundle.main.url(forResource: "\(selectedWord!)e", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
            } catch {
                print("音声ファイルの再生に失敗しました: \(error.localizedDescription)")
            }
        } else {
            print("音声ファイルが見つかりません: \(selectedWord!)e.mp3")
        }
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
