//
//  SelectCharacterLengthViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/22.
//

import UIKit

class SelectCharacterLengthViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var selectLevel = 0
    var selectTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectLevel == 1 {
            label.text = "基礎"
        } else  {
            label.text = "応用"
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quizVC = segue.destination as? QuizViewController {
            quizVC.selectLevel = selectLevel
            quizVC.selectLength = selectTag
        }
    }
    
    @IBAction func selectCharacterLengthButton(_ sender: UIButton) {
        selectTag = sender.tag
        performSegue(withIdentifier: "toQuizVC", sender: nil)
    }

    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
