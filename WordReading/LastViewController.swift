//
//  LastViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/10.
//

import UIKit

class LastViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapButtonAction(_ sender: UIButton) {
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        
    }
}
