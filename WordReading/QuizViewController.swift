//
//  QuizViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/22.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        csvArray = loadCSV(fileName: "\(selectLevel)\(selectLength)")
        print(csvArray)
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        print("選択したのは\(selectLevel)\(selectLength)")
        
        quizImage.image = UIImage(named: "\(quizArray[0])")
        answerButton1.setTitle(quizArray[1], for: .normal)
        answerButton2.setTitle(quizArray[2], for: .normal)
        answerButton3.setTitle(quizArray[3], for: .normal)
        
        progressBar.progress = Float(quizCount) / Float(csvArray.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultViewController
        resultVC.correct = correctCount
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == Int(quizArray[4]) {
            print("正解")
            judgeImage.image = UIImage(named: "まる")
            correctCount += 1
        } else {
            print("不正解")
            judgeImage.image = UIImage(named: "ばつ")
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
            answerButton1.setTitle(quizArray[1], for: .normal)
            answerButton2.setTitle(quizArray[2], for: .normal)
            answerButton3.setTitle(quizArray[3], for: .normal)
            
            // プログレスバーの更新
            progressBar.progress = Float(quizCount) / Float(csvArray.count)
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
