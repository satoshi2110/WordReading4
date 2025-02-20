//
//  ViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/10.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var titleLabal: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabal.text = ""
        var charIndex = 0.0
        let titleText = "ひらがな　を　よもう"
        for letter in titleText {
            print("_")
            print(0.1 * charIndex)
            print(letter)
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabal.text?.append(letter)
            }
            charIndex += 1
        }
    }
}

