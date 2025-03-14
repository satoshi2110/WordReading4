//
//  Word2ViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/11.
//

import UIKit
import AVFoundation

class Ssp4WordViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var firstWord: UIButton!
    @IBOutlet weak var secondWord: UIButton!
    @IBOutlet weak var thirdWord: UIButton!
    @IBOutlet weak var fourthWord: UIButton!
    @IBOutlet weak var imageB: UIButton!
    @IBOutlet weak var colorView: UIView!
    
    var csvArray: [String] = []
    var characterArray: [String] = []
    
    var selectedCharacter: String?
    var audioPlayer: AVAudioPlayer!
    var tapImageButton = 0
    var selectedTag = 0
    var selectedWord: String? // オプショナル型に変更
    var usedWords: [String] = [] // 使用済みの単語を記録
    var currentIndex: Int = 0 // 現在の表示回数（最大4回）
    
    // データセット
    let hiraganaSets = [
        ["そうじき", "くつした", "のみもの", "ほうせき"], // セット1
        ["えんぴつ", "てぶくろ", "かみなり", "あおぞら"], // セット2
        ["ふうりん", "にわとり", "ひまわり", "こうえん"]  // セット3
    ]
    
    let audioSets = [
        ["そうじき.mp3", "くつした.mp3", "のみもの.mp3", "ほうせき.mp3"], // セット1
        ["えんぴつ.mp3", "てぶくろ.mp3", "かみなり.mp3", "あおぞら.mp3"], // セット2
        ["ふうりん.mp3", "にわとり.mp3", "ひまわり.mp3", "こうえん.mp3"]  // セット3
    ]
    
    let imageSets = [
        ["そうじき.png", "くつした.png", "のみもの.png", "ほうせき.png"], // セット1
        ["えんぴつ.png", "てぶくろ.png", "かみなり.png", "あおぞら.png"], // セット2
        ["ふうりん.png", "にわとり.png", "ひまわり.png", "こうえん.png"]  // セット3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.isHidden = true
        // 最初の単語を表示
        showNextWord()
    }
    func showNextWord() {
        
        // 4回表示したら終了
        if currentIndex >= 4 {
            print("すべての単語を表示しました")
            self.presentingViewController?.dismiss(animated: true)
            return
        }
        
        // 選択されたタグに基づいてセットを選択
        let setIndex = selectedTag - 1 // タグは1から始まるため、インデックスに変換
        
        // 使用可能な単語をフィルタリング
        let availableWords = hiraganaSets[setIndex].filter { !usedWords.contains($0) }
        
        // 使用可能な単語がなくなったら終了
        guard !availableWords.isEmpty else {
            print("使用可能な単語がありません")
            return
        }
        
        // ランダムに単語を選択
        let randomIndex = Int.random(in: 0..<availableWords.count)
        selectedWord = availableWords[randomIndex]
        usedWords.append(selectedWord!) // 使用済みとして記録
        
        // CSVを読み込む
        csvArray = loadCSV(fileName: selectedWord!)
        characterArray = csvArray[0].components(separatedBy: ",")
        
        firstWord.setTitleColor(UIColor.black, for:.normal)
        secondWord.setTitleColor(UIColor.black, for: .normal)
        thirdWord.setTitleColor(UIColor.black, for: .normal)
        fourthWord.setTitleColor(UIColor.black, for: .normal)
        
        firstWord.setTitle(characterArray[0], for: .normal)
        secondWord.isHidden = true
        thirdWord.isHidden = true
        fourthWord.isHidden = true
        
        // 画像を設定
        if let imageName = selectedWord, let originalImage = UIImage(named: imageName) {
            // 画像をリサイズ
            let newSize = CGSize(width: originalImage.size.width * 0.7, height: originalImage.size.height * 0.7)
            let resizedImage = originalImage.resize(to: newSize)
            
            imageB.setImage(resizedImage, for: .normal)
            imageB.imageView?.contentMode = .scaleAspectFit
        }
        // 初期表示
        firstWord.setTitle(characterArray[0], for: .normal)
        firstWord.isHidden = false
        secondWord.isHidden = true
        thirdWord.isHidden = true
        fourthWord.isHidden = true
        imageB.isHidden = true
        firstWord.isEnabled = true
        secondWord.isEnabled = true
        thirdWord.isEnabled = true
        fourthWord.isEnabled = true
        imageB.isEnabled = true
        
        // 表示回数を更新
        currentIndex += 1
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
            firstWord.setTitle("", for: .normal)
            secondWord.setTitle("", for: .normal)
            thirdWord.setTitle("", for: .normal)
            fourthWord.setTitle("", for: .normal)
            firstWord.isHidden = true
            secondWord.isHidden = true
            thirdWord.isHidden = true
            fourthWord.isHidden = true
            imageB.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            self.showNextWord()
            self.audioPlayer.stop()
            
            // colorViewをライトグレーに設定し、1秒間表示
            self.colorView.backgroundColor = UIColor.systemGray6
            self.colorView.isHidden = false
            
            // 1秒後にcolorViewを非表示にする
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.colorView.isHidden = true
            }
        }
    }
    
    @IBAction func imageButton(_ sender: UIButton) {
        tapImageButton += 1
        soundEffects(volume: 0.1)
        if tapImageButton >= 1 {
            imageB.isEnabled = false
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
    
    func soundEffects(volume: Float) {
        var adjustedVolume = volume
        if selectedWord == "にわとり,かみなり" {
            adjustedVolume = 1.0
        }
        
        if let url = Bundle.main.url(forResource: "\(selectedWord!)e", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.volume = adjustedVolume // ボリュームを設定
                audioPlayer.play()
            } catch {
                print("音声ファイルの再生に失敗しました: \(error.localizedDescription)")
            }
        } else {
            print("音声ファイルが見つかりません: \(selectedWord!)e.mp3")
        }
    }
}


