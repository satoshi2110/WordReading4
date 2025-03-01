//
//  QuizViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/22.
//

import UIKit
import RealmSwift
import AVFoundation

class QuizViewController: UIViewController {
    
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var judgeImage: UIImageView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var csvArray: [String] = []
    var quizArray: [String] = []
    var quizCount = 0
    var correctCount = 0
    
    var selectedLevel = 0
    var selectedLength = 0
    
    var startTime: Date?
    var quizID: String = UUID().uuidString // クイズごとに一意のIDを生成
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuiz()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? ResultViewController {
            resultVC.correct = correctCount
            resultVC.quizID = quizID
            resultVC.selectLevel = selectedLevel
            resultVC.selectLength = selectedLength
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let endTime = Date()
        let timeTaken = endTime.timeIntervalSince(startTime ?? Date())
        
        let selectedAnswer: String
        switch sender.tag {
        case 1:
            selectedAnswer = quizArray[1]
        case 2:
            selectedAnswer = quizArray[2]
        case 3:
            selectedAnswer = quizArray[3]
        default:
            selectedAnswer = ""
        }
        
        let isCorrect = sender.tag == Int(quizArray[4])
        handleAnswer(isCorrect: isCorrect, selectedAnswer: selectedAnswer, timeTaken: timeTaken)
    }
    
    private func setupQuiz() {
        csvArray = loadCSV(fileName: "\(selectedLevel)\(selectedLength)")
        print(csvArray)
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        print("選択したのは\(selectedLevel)\(selectedLength)")
        
        quizImage.image = UIImage(named: quizArray[0])
        
        // ボタンのタイトルを縦書きに設定
        [answerButton1, answerButton2, answerButton3].enumerated().forEach { index, button in
            button?.setVerticalTitle(quizArray[index + 1])
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 80)
        }
        
        // ボタンの位置をランダムに配置
        arrangeButtonsRandomly()
        
        progressBar.progress = Float(quizCount) / Float(csvArray.count)
        startTime = Date() // 計測開始
    }
    
    private func handleAnswer(isCorrect: Bool, selectedAnswer: String, timeTaken: TimeInterval) {
        if isCorrect {
            judgeImage.image = UIImage(named: "まる")
            playSound(filename: "correct", filetype: "mp3")
            correctCount += 1
        } else {
            judgeImage.image = UIImage(named: "ばつ")
        }
        
        saveQuizResult(isCorrect: isCorrect, selectedAnswer: selectedAnswer, timeTaken: timeTaken)
        
        judgeImage.isHidden = false
        buttonDisablement()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.judgeImage.isHidden = true
            self.buttonEnablement()
            self.nextQuiz()
        }
        print("正解数: \(correctCount)")
    }
    
    private func saveQuizResult(isCorrect: Bool, selectedAnswer: String, timeTaken: TimeInterval) {
        let quizResult = QuizResult()
        quizResult.quizID = quizID
        quizResult.quizImageName = quizArray[0]
        quizResult.selectedAnswer = selectedAnswer
        quizResult.isCorrect = isCorrect
        quizResult.timeTaken = timeTaken
        quizResult.date = Date()
        quizResult.correctCount = correctCount
        quizResult.selectLevel = selectedLevel
        quizResult.selectLength = selectedLength
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(quizResult)
        }
    }
    
    private func nextQuiz() {
        quizCount += 1
        if quizCount < csvArray.count {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
            quizImage.image = UIImage(named: quizArray[0])
            
            // ボタンのタイトルを縦書きに設定
            [answerButton1, answerButton2, answerButton3].enumerated().forEach { index, button in
                button?.setVerticalTitle(quizArray[index + 1])
            }
            
            // ボタンの位置をランダムに配置
            arrangeButtonsRandomly()
            
            progressBar.progress = Float(quizCount) / Float(csvArray.count)
            startTime = Date() // 次の問題の計測開始
        } else {
            progressBar.progress = 1.0 // プログレスバーを最大にする
            buttonDisablement()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "toResultVC", sender: nil)
            }
        }
    }
    
    private func loadCSV(fileName: String) -> [String] {
        guard let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            print("CSVファイルが見つかりません")
            return []
        }
        
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: .utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            var csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
            return csvArray
        } catch {
            print("CSVファイルの読み込みに失敗しました: \(error)")
            return []
        }
    }
    
    private func buttonDisablement() {
        [answerButton1, answerButton2, answerButton3].forEach { $0?.isEnabled = false }
    }
    
    private func buttonEnablement() {
        [answerButton1, answerButton2, answerButton3].forEach { $0?.isEnabled = true }
    }
    
    private func playSound(filename: String, filetype: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: filetype) else {
            print("音声ファイルが見つかりません")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("音声ファイルの再生に失敗しました: \(error)")
        }
    }
    
    // ボタンをランダムに配置する関数
    private func arrangeButtonsRandomly() {
        let buttons = [answerButton1, answerButton2, answerButton3]
        
        // ボタンの幅と高さ
        let buttonWidth = answerButton1.frame.width
        let buttonHeight = answerButton1.frame.height
        
        // 配置可能な領域を計算
        let minY = quizImage.frame.maxY + 20 // quizImage の下に配置
        let maxY = progressBar.frame.minY - buttonHeight - 20 // progressBar の上に配置
        let screenWidth = UIScreen.main.bounds.width
        
        // ボタンの位置をランダムに決定
        var usedXPositions: [CGFloat] = []
        for button in buttons {
            guard let button = button else { continue }
            
            var x: CGFloat
            var y: CGFloat
            
            // ボタンが重ならないように x 座標を決定
            repeat {
                x = CGFloat.random(in: 50...(screenWidth - buttonWidth - 50))
            } while usedXPositions.contains { abs($0 - x) < buttonWidth + 20 } // ボタン同士が重ならないように余裕を持たせる
            
            usedXPositions.append(x)
            
            // y 座標をランダムに決定
            y = CGFloat.random(in: minY...maxY)
            
            // ボタンの位置を設定
            button.frame.origin = CGPoint(x: x, y: y)
        }
    }
}
    

extension UIButton {
    func setVerticalTitle(_ title: String) {
        let verticalTitle = title.map { String($0) }.joined(separator: "\n")
        self.setTitle(verticalTitle, for: .normal)
        self.titleLabel?.numberOfLines = title.count // 行数を文字数に合わせる
        self.titleLabel?.textAlignment = .center // 中央揃え
    }
}
