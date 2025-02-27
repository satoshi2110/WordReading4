//
//  SelectCharacterLengthViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/22.
//

import UIKit

class SelectCharacterLengthViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var selectedLevel = 0
    var selectTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedLevel == 1 {
            label.text = "基礎"
        } else  {
            label.text = "応用"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let quizVC = segue.destination as! QuizViewController
        quizVC.selectedLevel = selectedLevel
        quizVC.selectedLength = selectTag
    }
    
    @IBAction func selectCharacterLengthButton(_ sender: UIButton) {
        selectTag = sender.tag
        performSegue(withIdentifier: "toQuizVC", sender: nil)
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
