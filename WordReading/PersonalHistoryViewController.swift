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
        var quizResultsDict: [String: [QuizResult]] = [:] // quizID ごとのデータを保持
        
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
        
        func loadData() {
            let realm = try! Realm()
            
            // 日付の降順でデータを取得
            quizResults = realm.objects(QuizResult.self).sorted(byKeyPath: "date", ascending: false)
            
            // Resultsを静的な配列に変換
            quizResultsArray = Array(quizResults)
            
            // quizID ごとにデータをグループ化
            quizResultsDict = Dictionary(grouping: quizResultsArray, by: { $0.quizID })
            
            // セクションごとの quizID を日付の降順でソート
            uniqueQuizIDs = quizResultsDict.keys.sorted {
                let firstDate = quizResultsDict[$0]?.first?.date ?? Date()
                let secondDate = quizResultsDict[$1]?.first?.date ?? Date()
                return firstDate > secondDate // 日付の降順でソート
            }
        }

        // セクションの数
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1 // セクションは1つだけ
        }

        // セクションごとの行数
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return uniqueQuizIDs.count // セッションの数だけ行を表示
        }

    // セルの内容
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizResultCell")
            
            let quizID = uniqueQuizIDs[indexPath.row]
            guard let resultsForQuizID = quizResultsDict[quizID] else {
                return cell
            }
            
            // セッションのトータル正答数を計算
            let totalCorrect = resultsForQuizID.filter { $0.isCorrect }.count
            
            // セッションの最初の結果を取得
            guard let firstResult = resultsForQuizID.first else {
                return cell
            }
            
            // 日付を「年 月 日 時 分」の形式にフォーマット
            let dateString = firstResult.formattedDate()
            
            // selectLevelとselectLengthに基づいて表示する文字列を生成
            let levelText: String
            switch firstResult.selectLevel {
            case 1:
                levelText = "基礎"
            case 2:
                levelText = "応用"
            default:
                levelText = "未設定"
            }
            
            let lengthText: String
            switch firstResult.selectLength {
            case 2:
                lengthText = "2文字"
            case 3:
                lengthText = "3文字"
            case 4:
                lengthText = "4文字"
            default:
                lengthText = "未設定"
            }
            
            // セルに表示する内容
            cell.textLabel?.text = "日時: \(dateString)" // タイトルに日付を表示
            cell.detailTextLabel?.text = "\(levelText) - \(lengthText), 正答数: \(totalCorrect)" // サブタイトルにレベルと正答数を表示
            
            return cell
        }
        
        // セルの高さ
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60.0
        }
        
    // セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizID = uniqueQuizIDs[indexPath.row]
        
        // セグエを実行して詳細画面に遷移
        performSegue(withIdentifier: "showQuizIDDetail", sender: quizID)
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // セグエの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuizIDDetail",
           let detailVC = segue.destination as? QuizIDDetailViewController,
           let quizID = sender as? String {
            detailVC.quizID = quizID
        }
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

