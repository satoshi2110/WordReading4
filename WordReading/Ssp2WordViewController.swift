//
//  Word0ViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/20.
//

import UIKit
import AVFAudio

class Ssp2WordViewController: UIViewController {
    @IBOutlet weak var firstWord: UIButton!
    @IBOutlet weak var secondWord: UIButton!
    @IBOutlet weak var imageB: UIButton!
    
    var csvArray: [String] = []
    var characterArray: [String] = []
    var selectedTag = 0
    var selectedCharacter: String?
    var audioPlayer: AVAudioPlayer!
    var tapButton = 0
    
    // データセット
    let hiraganaSets = [
        ["あめ", "いぬ", "すず", "ねこ", "むし"], // セット1
        ["せみ", "へび", "さる", "よる", "やま"], // セット2
        ["よむ", "ほん", "にく", "ふゆ", "もも"]  // セット3
    ]
    
    let audioSets = [
        ["あめ.mp3", "いぬ.mp3", "すず.mp3", "ねこ.mp3", "むし.mp3"], // セット1
        ["せみ.mp3", "へび.mp3", "さる.mp3", "よる.mp3", "やま.mp3"], // セット2
        ["よむ.mp3", "ほん.mp3", "にく.mp3", "ふゆ.mp3", "もも.mp3"]  // セット3
    ]
    
    let imageSets = [
        ["あめ.png", "いぬ.png", "すず.png", "ねこ.png", "むし.png"], // セット1
        ["せみ.png", "へび.png", "さる.png", "よる.png", "やま.png"], // セット2
        ["よむ.png", "ほん.png", "にく.png", "ふゆ.png", "もも.png"]  // セット3
    ]
    
    var selectedHiragana: String = "" // 選択されたひらがな
    var selectedAudio: String = ""    // 選択された音声ファイル
    var selectedImage: String = ""    // 選択された画像ファイル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 選択されたタグに基づいてセットをランダムに選択
        let setIndex = selectedTag - 1 // タグは1から始まるため、インデックスに変換
        let randomIndex = Int.random(in: 0..<hiraganaSets[setIndex].count)
        
        // 選択されたひらがな、音声、画像を設定
        selectedHiragana = hiraganaSets[setIndex][randomIndex]
        selectedAudio = audioSets[setIndex][randomIndex]
        selectedImage = imageSets[setIndex][randomIndex]
        
        // CSVを読み込む
        csvArray = loadCSV(fileName: selectedHiragana)
        characterArray = csvArray[0].components(separatedBy: ",")
        
        // ボタンの設定
        firstWord.setTitleColor(UIColor.black, for:.normal)
        secondWord.setTitleColor(UIColor.black, for: .normal)
        
        // 画像を設定
        if !selectedImage.isEmpty, let originalImage = UIImage(named: selectedImage) {
            let scale: CGFloat = (selectedImage == "もも" || selectedImage == "へび" || selectedImage == "すず") ? 0.5 : 0.7
            let newSize = CGSize(width: originalImage.size.width * scale, height: originalImage.size.height * scale)
            let resizedImage = originalImage.resize(to: newSize)
            
            imageB.setImage(resizedImage, for: .normal)
            imageB.imageView?.contentMode = .scaleAspectFit
        } else {
            print("画像が見つかりません: \(selectedImage)")
        }
        
        // 初期表示
        firstWord.setTitle(characterArray[0], for: .normal)
        secondWord.isHidden = true
        imageB.isHidden = true
    }
    
    func loadCSV(fileName: String) -> [String] {
        // CSVファイルのパスを取得
        guard let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            print("CSVファイルが見つかりません: \(fileName).csv")
            return []
        }
        
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast() // 最後の空行を削除
        } catch {
            print("CSVファイルの読み込みに失敗しました: \(error.localizedDescription)")
        }
        return csvArray
    }
    
    func soundFirst() {
        let selectedCharacter = characterArray[0]
        
        // リソースが見つからない場合のエラーハンドリング
        guard let url = Bundle.main.url(forResource: selectedCharacter, withExtension: "mp3") else {
            print("音声ファイルが見つかりません: \(selectedCharacter).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
            print(selectedCharacter)
        } catch {
            print("音声ファイルの再生に失敗しました: \(error.localizedDescription)")
        }
    }
    
    func soundSecond() {
        let selectedCharacter = characterArray[1]
        
        // リソースが見つからない場合のエラーハンドリング
        guard let url = Bundle.main.url(forResource: selectedCharacter, withExtension: "mp3") else {
            print("音声ファイルが見つかりません: \(selectedCharacter).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
            print(selectedCharacter)
        } catch {
            print("音声ファイルの再生に失敗しました: \(error.localizedDescription)")
        }
    }
    
    func soundWord() {
        // リソースが見つからない場合のエラーハンドリング
        guard let url = Bundle.main.url(forResource: selectedHiragana, withExtension: "mp3") else {
            print("音声ファイルが見つかりません: \(selectedHiragana).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("音声ファイルの再生に失敗しました: \(error.localizedDescription)")
        }
    }
    
    func soundEffects(volume: Float) {
        // リソースが見つからない場合のエラーハンドリング
        guard let url = Bundle.main.url(forResource: "\(selectedHiragana)e", withExtension: "mp3") else {
            print("音声ファイルが見つかりません: \(selectedHiragana)e.mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.volume = volume // ボリュームを設定
            audioPlayer.play()
        } catch {
            print("音声ファイルの再生に失敗しました: \(error.localizedDescription)")
        }
    }
    @IBAction func firstWordButtton(_ sender: UIButton) {
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
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.soundWord()
            self.firstWord.isHidden = false
            self.firstWord.setTitle(self.characterArray[0], for: .normal)
            self.secondWord.isHidden = false
            self.secondWord.setTitle(self.characterArray[1], for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            self.firstWord.isHidden = true
            self.secondWord.isHidden = true
            self.imageB.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.8){
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    @IBAction func imageButton(_ sender: UIButton) {
        tapButton += 1
        
        // selectedHiraganaが"にく"の場合、ボリュームを1.0に設定し、それ以外は0.1に設定
        let setIndex = selectedTag - 1
        let randomIndex = Int.random(in: 0..<hiraganaSets[setIndex].count)
        let selectedHiragana = hiraganaSets[setIndex][randomIndex]
        
        let volume: Float = (selectedHiragana == "にく" || selectedHiragana == "よむ") ? 1.0 : 0.1
        soundEffects(volume: volume)
        
        if tapButton >= 1 {
            imageB.isEnabled = false
        }
    }
}

