//
//  ResultViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/23.
//

import UIKit
import RealmSwift
import AVFoundation

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var correct = 0
    var quizResults: Results<QuizResult>!
    var quizID: String!
    
    var selectLevel = 0
    var selectLength = 0
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "正解は\(correct)問です！"
        // Realmからデータを取得
        let realm = try! Realm()
        quizResults = realm.objects(QuizResult.self)
            .filter("quizID == %@", quizID as Any)
            .sorted(byKeyPath: "date", ascending: false)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizResultCell")
        
        // selectLevelとselectLengthをQuizResultから取得
        if let quizResult = quizResults.first {
            selectLevel = quizResult.selectLevel
            selectLength = quizResult.selectLength
        }
        
        // 全問正解かどうかを判定
        if (selectLength == 3 || selectLength == 4) && correct == 12 {
            scoreLabel.text = "おめでとう！！"
            playSound(filename: "fanfare", filetype: "mp3",volume: 0.1)
        } else if selectLength == 2 && correct == 15 {
            scoreLabel.text = "おめでとう！！"
            playSound(filename: "fanfare", filetype: "mp3", volume: 0.1)
        } else if selectLevel == 2 && correct >= 8 { // 応用の場合、8問以上正解でおめでとうを表示
            scoreLabel.text = "おめでとう！！"
            playSound(filename: "fanfare", filetype: "mp3", volume: 0.1)
        }
    }
    
    func playSound(filename: String, filetype: String, volume: Float ) {
        if let path = Bundle.main.path(forResource: filename, ofType: filetype) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.volume = volume
                audioPlayer?.play()
            } catch {
                print("音楽ファイルの再生に失敗しました")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // selectLevelとselectLengthに基づいて表示する文字列を生成
        let levelText: String
        switch selectLevel {
        case 1:
            levelText = "基礎"
        case 2:
            levelText = "応用"
        default:
            levelText = "未設定"
        }
        
        let lengthText: String
        switch selectLength {
        case 2:
            lengthText = "2文字"
        case 3:
            lengthText = "3文字"
        case 4:
            lengthText = "4文字"
        default:
            lengthText = "未設定"
        }
        
        // トータル時間を計算
        let totalTime = quizResults.reduce(0.0) { $0 + $1.timeTaken }
        let totalTimeString = String(format: "%.1f", totalTime)
        
        return "\(levelText) - \(lengthText), トータル時間: \(totalTimeString)秒"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizResultCell")
        let quizResult = quizResults[indexPath.row]
        
        // 所要時間を小数点第1位まで表示
        let timeTakenString = String(format: "%.1f", quizResult.timeTaken)

        
        // 日付を「yyyy年MM月dd日 HH時mm分」の形式にフォーマット
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        let dateString = dateFormatter.string(from: quizResult.date)
        
        cell.textLabel?.text = "問題: \(quizResult.quizImageName), 選択: \(quizResult.selectedAnswer), 正解: \(quizResult.isCorrect ? "○" : "×")"
        cell.detailTextLabel?.text = "所要時間: \(timeTakenString)秒,  日付: \(dateString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // 適切な高さに調整
    }
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
