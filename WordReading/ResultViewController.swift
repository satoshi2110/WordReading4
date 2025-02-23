//
//  ResultViewController.swift
//  WordReading4
//
//  Created by N S on 2025/02/23.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var correct = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "正解は\(correct)問です！"
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
