//
//  QuizViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/22.
//

import UIKit
import RealmSwift

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
    
    var selectLevel = 0
    var selectLength = 0
    
    var startTime: Date?
    var quizID: String = UUID().uuidString // クイズごとに一意のIDを生成
    
    override func viewDidLoad() {
        super.viewDidLoad()
        csvArray = loadCSV(fileName: "\(selectLevel)\(selectLength)")
        print(csvArray)
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        print("選択したのは\(selectLevel)\(selectLength)")
        
        quizImage.image = UIImage(named: "\(quizArray[0])")
        
        // ボタンのタイトルを縦書きに設定
        answerButton1.setVerticalTitle(quizArray[1])
        answerButton2.setVerticalTitle(quizArray[2])
        answerButton3.setVerticalTitle(quizArray[3])
        
        // ボタンのフォントサイズを調整
        answerButton1.titleLabel?.font = UIFont.systemFont(ofSize: 80)
        answerButton2.titleLabel?.font = UIFont.systemFont(ofSize: 80)
        answerButton3.titleLabel?.font = UIFont.systemFont(ofSize: 80)
        
        progressBar.progress = Float(quizCount) / Float(csvArray.count)
        
        startTime = Date() // 計測開始
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultViewController
        resultVC.correct = correctCount
        resultVC.quizID = quizID
        resultVC.selectLevel = selectLevel
        resultVC.selectLength = selectLength
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
        if isCorrect {
            judgeImage.image = UIImage(named: "まる")
            correctCount += 1
        } else {
            judgeImage.image = UIImage(named: "ばつ")
        }
        
        // Realmに結果を保存
        let quizResult = QuizResult()
        quizResult.quizID = quizID
        quizResult.quizImageName = quizArray[0]
        quizResult.selectedAnswer = selectedAnswer
        quizResult.isCorrect = isCorrect
        quizResult.timeTaken = timeTaken
        quizResult.date = Date()
        quizResult.correctCount = correctCount
        quizResult.selectLevel = selectLevel // selectLevelを設定
        quizResult.selectLength = selectLength // selectLengthを設定
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(quizResult)
        }
        
        judgeImage.isHidden = false
        buttonDisablement()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.judgeImage.isHidden = true
            self.buttonEnablement()
            self.nextQuiz()
        }
        print("\(correctCount)")
        
    }
    
    func nextQuiz() {
        quizCount += 1
        if quizCount < csvArray.count {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
            quizImage.image = UIImage(named: "\(quizArray[0])")
            // ボタンのタイトルを縦書きに設定
            answerButton1.setVerticalTitle(quizArray[1])
            answerButton2.setVerticalTitle(quizArray[2])
            answerButton3.setVerticalTitle(quizArray[3])
            
            // プログレスバーの更新
            progressBar.progress = Float(quizCount) / Float(csvArray.count)
            startTime = Date() // 次の問題の計測開始
        } else {
            progressBar.progress = 1.0 // プログレスバーを最大にする
            self.buttonDisablement()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                
                self.performSegue(withIdentifier: "toResultVC", sender: nil)
            }
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
    
    func buttonDisablement() {
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
    }
    
    func buttonEnablement() {
        answerButton1.isEnabled = true
        answerButton2.isEnabled = true
        answerButton3.isEnabled = true
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
