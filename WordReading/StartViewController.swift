//
//  ViewController.swift
//  WordReading
//
//  Created by N S on 2024/09/10.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var titleText = "よめるかな？"
    var charIndex = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UILabelの設定
        titleLabel.textAlignment = .left // テキストを左揃えに設定
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byClipping
        titleLabel.baselineAdjustment = .alignBaselines
        
        // AutoLayout制約をプログラムで追加
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -130), // 左端を画面中央から130ポイント左に固定
            titleLabel.widthAnchor.constraint(equalToConstant: 250) // UILabelの幅を固定
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTextAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTextAnimation()
    }
    
    // タイピングアニメーションを開始
    func startTextAnimation() {
        // 前回のタイマーが存在する場合は無効化
        timer?.invalidate()
        
        // ラベルをリセット
        titleLabel.text = ""
        charIndex = 0
        
        // タイマーを設定
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateText), userInfo: nil, repeats: true)
    }
    
    // タイマーによって呼び出されるメソッド
    @objc func updateText() {
        // 文字列の範囲内であれば次の文字を表示
        if charIndex < titleText.count {
            let index = titleText.index(titleText.startIndex, offsetBy: charIndex)
            let char = titleText[index]
            titleLabel.text?.append(char)
            charIndex += 1
        } else {
            // すべての文字が表示されたらタイマーを無効化
            timer?.invalidate()
            timer = nil
        }
    }
    
    // タイピングアニメーションを停止
    func stopTextAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

