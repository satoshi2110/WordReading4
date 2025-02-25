//
//  SelectWordViewController0.swift
//  WordReading4
//
//  Created by N S on 2025/02/20.
//

import UIKit

class Select2WordViewController: UIViewController {
    var word: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordVC = segue.destination as! Ssp2WordViewController
        wordVC.selectedWord = word
    }
    @IBAction func wordButtonAction(_ sender: UIButton) {
        word = sender.title(for: .normal)
        performSegue(withIdentifier: "toWordVC", sender: nil)
    }
    @IBAction func returenButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
