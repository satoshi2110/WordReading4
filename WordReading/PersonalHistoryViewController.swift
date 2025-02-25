//
//  PersonalHistoryViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/22.
//
import UIKit
import RealmSwift

class PersonalHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var quizResults: Results<QuizResult>!
    var selectLevel = 0 
    var selectLength = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PersonalHistoryViewControllerのselectLevel: \(selectLevel), selectLength: \(selectLength)") 
        // Realmから全てのデータを取得
        let realm = try! Realm()
        quizResults = realm.objects(QuizResult.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizResultCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let uniqueQuizIDs = Array(Set(quizResults.value(forKeyPath: "quizID") as! [String]))
        return uniqueQuizIDs.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let uniqueQuizIDs = Array(Set(quizResults.value(forKeyPath: "quizID") as! [String]))
            let quizID = uniqueQuizIDs[section]
            let resultsForQuizID = quizResults.filter("quizID == %@", quizID)
            if let quizResult = resultsForQuizID.first {
                // selectLevelとselectLengthに基づいて表示する文字列を生成
                let levelText: String
                switch quizResult.selectLevel {
                case 1:
                    levelText = "基礎"
                case 2:
                    levelText = "応用"
                default:
                    levelText = "未設定"
                }
                
                let lengthText: String
                switch quizResult.selectLength {
                case 2:
                    lengthText = "2文字"
                case 3:
                    lengthText = "3文字"
                case 4:
                    lengthText = "4文字"
                default:
                    lengthText = "未設定"
                }
                
                return "\(levelText) - \(lengthText)"
            }
            return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let uniqueQuizIDs = Array(Set(quizResults.value(forKeyPath: "quizID") as! [String]))
        let quizID = uniqueQuizIDs[section]
        return quizResults.filter("quizID == %@", quizID).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizResultCell")
        let uniqueQuizIDs = Array(Set(quizResults.value(forKeyPath: "quizID") as! [String]))
        let quizID = uniqueQuizIDs[indexPath.section]
        let resultsForQuizID = quizResults.filter("quizID == %@", quizID)
        let quizResult = resultsForQuizID[indexPath.row]
        
        // 日付を「年 日 時 分」の形式にフォーマット
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分" // フォーマットを指定
        let dateString = dateFormatter.string(from: quizResult.date)
        
        let timeTakenString = String(format: "%.1f", quizResult.timeTaken)
        
        cell.textLabel?.text = "問題: \(quizResult.quizImageName), 選択: \(quizResult.selectedAnswer), 正解: \(quizResult.isCorrect ? "○" : "×")"
        cell.detailTextLabel?.text = "所要時間: \(timeTakenString)秒, 日付: \(dateString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // 適切な高さに調整
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

