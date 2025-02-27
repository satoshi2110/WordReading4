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
    var quizResultsArray: [QuizResult] = [] // 静的な配列でデータを保持
    var uniqueQuizIDs: [String] = [] // セクションごとの quizID を保持
    var quizResultsDict: [String: [QuizResult]] = [:]// quizID ごとのデータを保持
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableViewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizResultCell")
        
        // 初回データ読み込み
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 画面が表示されるたびにデータを再読み込み
        loadData()
        tableView.reloadData()
    }
    
    // データを読み込む
    func loadData() {
        let realm = try! Realm()
        quizResults = realm.objects(QuizResult.self).sorted(byKeyPath: "date", ascending: false)
        
        // Resultsを静的な配列に変換
        quizResultsArray = Array(quizResults)
        
        // セクションごとの quizID を取得
        uniqueQuizIDs = Array(Set(quizResultsArray.map { $0.quizID })).sorted()
        
        // デバッグ: uniqueQuizIDs の内容を確認
        for quizID in uniqueQuizIDs {
            if let firstResult = quizResultsArray.first(where: { $0.quizID == quizID }) {
                print("QuizID: \(quizID), Date: \(firstResult.date)")
            }
        }
        
    }
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return uniqueQuizIDs.count
    }
    
    // セクションヘッダーのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let quizID = uniqueQuizIDs[section]
        let resultsForQuizID = quizResultsArray.filter { $0.quizID == quizID }
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
    
    // セクションごとの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let quizID = uniqueQuizIDs[section]
        return quizResultsArray.filter { $0.quizID == quizID }.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizResultCell")
        
        let quizID = uniqueQuizIDs[indexPath.section]
        let resultsForQuizID = quizResultsArray.filter { $0.quizID == quizID }
        
        // インデックスが範囲内か確認
        guard indexPath.row < resultsForQuizID.count else {
            return cell
        }
        
        let quizResult = resultsForQuizID[indexPath.row]
        
        // 日付を「年 月 日 時 分」の形式にフォーマット
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        let dateString = dateFormatter.string(from: quizResult.date)
        
        let timeTakenString = String(format: "%.1f", quizResult.timeTaken)
        
        cell.textLabel?.text = "問題: \(quizResult.quizImageName), 選択: \(quizResult.selectedAnswer), 正解: \(quizResult.isCorrect ? "○" : "×")"
        cell.detailTextLabel?.text = "所要時間: \(timeTakenString)秒, 日付: \(dateString)"
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

