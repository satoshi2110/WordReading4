//
//  SelectWord2ViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/11.
//

import UIKit

class Select4WordViewController: UIViewController {
    
    var word: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordVC = segue.destination as! Ssp4WordViewController
        wordVC.selectedWord = word
    }
    
    @IBAction func wordButtonAction(sender: UIButton){
        word = sender.title(for: .normal)
        performSegue(withIdentifier: "toWordVC", sender: nil)
    }
    
    @IBAction func returnToTop(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
