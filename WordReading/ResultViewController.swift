//
//  ResultViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/23.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var correct = 0
    var quizResults: Results<QuizResult>!
    var quizID: String!
    
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizResultCell")
        let quizResult = quizResults[indexPath.row]
        cell.textLabel?.text = "問題: \(quizResult.quizImageName), 選択: \(quizResult.selectedAnswer), 正解: \(quizResult.isCorrect ? "○" : "×")"
        cell.detailTextLabel?.text = "所要時間: \(quizResult.timeTaken), 日付: \(quizResult.date)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // 適切な高さに調整
    }
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
