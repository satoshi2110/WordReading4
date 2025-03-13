//
//  SelectWordViewController0.swift
//  WordReading4
//
//  Created by N S on 2025/02/20.
//

import UIKit

class Select2WordViewController: UIViewController {
    var word: String?
    var tag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordVC = segue.destination as! Ssp2WordViewController
        wordVC.selectedTag = tag!
    }
    @IBAction func wordButtonAction(_ sender: UIButton) {
        tag = sender.tag
        performSegue(withIdentifier: "toWordVC", sender: nil)
    }
    @IBAction func returenButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
