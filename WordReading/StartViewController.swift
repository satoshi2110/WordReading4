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

        // UILabelの設定
        titleLabal.textAlignment = .left // テキストを左揃えに設定
        titleLabal.numberOfLines = 1
        titleLabal.lineBreakMode = .byClipping
        titleLabal.baselineAdjustment = .alignBaselines

        // AutoLayout制約をプログラムで追加
        titleLabal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabal.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -130), // 左端を画面中央から100ポイント左に固定
            
            titleLabal.widthAnchor.constraint(equalToConstant: 250) // UILabelの幅を固定
        ])

        // テキストを一文字ずつ表示
        titleLabal.text = ""
        var charIndex = 0.0
        let titleText = "よめるかな？"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.5 * charIndex, repeats: false) { (timer) in
                self.titleLabal.text?.append(String(letter))
            }
            charIndex += 1
        }
    }
}

