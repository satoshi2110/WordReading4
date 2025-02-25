//
//  QuizViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/21.
//

import UIKit

class SelectQuizViewController: UIViewController {
    
    var selectTag = 0
    var selectLevel = 0
    var selectLength = 0
    
    private enum SegueIdentifier {
        static let toSelectCharacterLengthVC = "toSelectCharacterLengthVC"
        static let toPersonalHistoryVC = "toPersonalHistoryVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SelectQuizViewControllerのselectLevel: \(selectLevel), selectLength: \(selectLength)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toSelectCharacterLengthVC,
           let selectCharacterLengthVC = segue.destination as? SelectCharacterLengthViewController {
            selectCharacterLengthVC.selectLevel = selectTag
        }
        else if segue.identifier == SegueIdentifier.toPersonalHistoryVC,
                let personalHistoryVC = segue.destination as? PersonalHistoryViewController {
            personalHistoryVC.selectLevel = selectLevel
            personalHistoryVC.selectLength = selectLength
        }
    }
    @IBAction func levelButtonAction(sender: UIButton) {
        selectTag = sender.tag
        performSegue(withIdentifier: SegueIdentifier.toSelectCharacterLengthVC, sender: nil)
    }
    
    @IBAction func personalHistoryAction(_ sender: UIButton) {
        if shouldPerformSegue(withIdentifier: SegueIdentifier.toPersonalHistoryVC, sender: nil) {
            performSegue(withIdentifier: SegueIdentifier.toPersonalHistoryVC, sender: nil)
        } else {
            print("Error: Segue identifier '\(SegueIdentifier.toPersonalHistoryVC)' not found.")
        }
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
