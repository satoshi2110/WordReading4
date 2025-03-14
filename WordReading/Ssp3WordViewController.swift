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
    @IBOutlet weak var colorView: UIView!
    
    var csvArray: [String] = []
    var characterArray: [String] = []
    var selectedTag = 0
    var selectedCharacter: String?
    var audioPlayer: AVAudioPlayer!
    var tapImageButton = 0
    var selectedWord: String? // 選択された単語
    var usedWords: [String] = [] // 使用済みの単語を記録
    var currentIndex: Int = 0 // 現在の表示回数（最大4回）
    
    // データセット
    let hiraganaSets = [
        ["はなび", "たきび", "とけい", "おばけ"], // セット1
        ["からす", "おかね", "やさい", "ちくわ"], // セット2
        ["じしん", "おかし", "てれび", "といれ"]  // セット3
    ]
    
    let audioSets = [
        ["はなび.mp3", "たきび.mp3", "とけい.mp3", "おばけ.mp3"], // セット1
        ["からす.mp3", "おかね.mp3", "やさい.mp3", "ちくわ.mp3"], // セット2
        ["じしん.mp3", "おかし.mp3", "てれび.mp3", "といれ.mp3"]  // セット3
    ]
    
    let imageSets = [
        ["はなび.png", "たきび.png", "とけい.png", "おばけ.png"], // セット1
        ["からす.png", "おかね.png", "やさい.png", "ちくわ.png"], // セット2
        ["じしん.png", "おかし.png", "てれび.png", "といれ.png"]  // セット3
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
        
        // ボタンの設定
        firstWord.setTitleColor(UIColor.black, for: .normal)
        secondWord.setTitleColor(UIColor.black, for: .normal)
        thirdWord.setTitleColor(UIColor.black, for: .normal)
        
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
        imageB.isHidden = true
        
        // 表示回数を更新
        currentIndex += 1

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
    
    func soundEffects(volume: Float) {
        var adjustedVolume = volume
        if selectedWord == "たきび,じしん" {
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
    
    @IBAction func firstWordButton(_ sender: UIButton) {
        soundFirst()
        firstWord.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.firstWord.isHidden = true
            self.secondWord.isHidden = false
            self.secondWord.isEnabled = true
            self.secondWord.setTitle(self.characterArray[1], for: .normal)
        }
    }
    @IBAction func secondWordButton(_ sender: UIButton) {
        soundSecond()
        secondWord.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.secondWord.isHidden = true
            self.thirdWord.isHidden = false
            self.thirdWord.isEnabled = true
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
            
            self.firstWord.setTitle("", for: .normal)
            self.secondWord.setTitle("", for: .normal)
            self.thirdWord.setTitle("", for: .normal)
            
            self.firstWord.isHidden = true
            self.secondWord.isHidden = true
            self.thirdWord.isHidden = true
            imageB.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {

            self.imageB.isHidden = true
            
            // ボタンの状態をリセット
            self.firstWord.isEnabled = true
            self.imageB.isEnabled = true
            self.audioPlayer.stop()
            
            // 次の単語を表示
            self.showNextWord()
            
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
