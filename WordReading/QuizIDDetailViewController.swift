//
//  QuizIDDetailViewController.swift
//  WordReading4
//
//  Created by N S on 2025/03/01.
//
import UIKit
import RealmSwift

class QuizIDDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var quizID: String! // 受け取る quizID
    var quizResults: Results<QuizResult>!
    var quizResultsArray: [QuizResult] = [] // 静的な配列でデータを保持
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableViewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizResultCell")
        
        // データを読み込む
        loadData()
    }
    
    func loadData() {
        let realm = try! Realm()
        
        // quizID を明示的にアンラップ
        guard let quizID = quizID else {
            print("Error: quizID is nil")
            return
        }
        
        // quizID に基づいてデータをフィルタリング
        quizResults = realm.objects(QuizResult.self).filter("quizID == %@", quizID).sorted(byKeyPath: "date", ascending: false)
        
        // Resultsを静的な配列に変換
        quizResultsArray = Array(quizResults)
        
        // TableViewをリロード
        tableView.reloadData()
    }
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションごとの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizResultsArray.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizResultCell")
        
        let quizResult = quizResultsArray[indexPath.row]
        
        // 日付を「年 月 日 時 分」の形式にフォーマット
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        let dateString = dateFormatter.string(from: quizResult.date)
        
        // 所要時間をフォーマット
        let timeTakenString = String(format: "%.1f秒", quizResult.timeTaken)
        
        // セルに表示する内容
        cell.textLabel?.text = "問題: \(quizResult.quizImageName), 選択: \(quizResult.selectedAnswer), 正解: \(quizResult.isCorrect ? "○" : "×")"
        cell.detailTextLabel?.text = "所要時間: \(timeTakenString), 日付: \(dateString)"
        
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
