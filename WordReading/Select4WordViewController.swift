//
//  SelectWord2ViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/11.
//

import UIKit

class Select4WordViewController: UIViewController {
    
    var tag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordVC = segue.destination as! Ssp4WordViewController
        wordVC.selectedTag = tag!
    }
    
    @IBAction func wordButtonAction(sender: UIButton){
        tag = sender.tag
        performSegue(withIdentifier: "toWordVC", sender: nil)
    }
    
    @IBAction func returnToTop(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
