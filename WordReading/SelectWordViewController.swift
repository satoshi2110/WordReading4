//
//  SelectWordViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/10.
//

import UIKit

class SelectWordViewController: UIViewController {
    
    var word: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordVC = segue.destination as! WordViewController
        wordVC.selectedWord = word
    }
    
    @IBAction func wordButtonAction(sender: UIButton){
        word = sender.title(for: .normal)
        performSegue(withIdentifier: "toWordVC", sender: nil)
    }

    @IBAction func topRetuen(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
