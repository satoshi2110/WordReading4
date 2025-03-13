//
//  SelectWordViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/10.
//

import UIKit

class Select3WordViewController: UIViewController {
    
    var tag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordVC = segue.destination as! Ssp3WordViewController
        wordVC.selectedTag = tag!
    }
    
    @IBAction func wordButtonAction(sender: UIButton){
        tag = sender.tag
        performSegue(withIdentifier: "toWordVC", sender: nil)
    }

    @IBAction func topRetuen(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
