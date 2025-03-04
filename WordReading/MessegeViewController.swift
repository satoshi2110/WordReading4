//
//  messege.swift
//  WordReading4
//
//  Created by N S on 2025/03/03.
//

import UIKit

class MessegeViewController :UIViewController {
    
    
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 元のテキスト
        let fullText = """
        アプリについて
        　このアプリは、お子さまが楽しくひらがなの読みを学べるように設計されています。
        　応用行動分析学の「継次的刺激ペアリング手続き」を取り入れ、観察するだけでひらがなと音声、絵の関係を自然に学習できる仕組みになっています。また、視線移動のスキル向上にも役立ちます。

        使い方
        　2～4文字のひらがなを選び、お子さまにタップさせてください。ひらがなが1文字ずつ表示され、タップするたびに対応する音声が流れます。すべての文字が表示された後、イラストが提示され、一部のイラストでは音も鳴ります。
        　繰り返し見ることで、文字と音声、絵の関係を無理なく習得できます。このアプリでは、「を」を除くひらがな50音を学習できます。

        テスト
        　基礎テスト：継次的刺激ペアリング手続きで使用したひらがなの読みを確認します。
        　応用テスト：未使用の単語を用いて、ひらがなの読みを確認します。
        　お子さまが正しく選べるようになったら、「もっと早く選んでみよう！」と声をかけてみてください。選択スピードが上がることで記憶が定着しやすくなり、アプリ以外の場面でも読める機会が増えていきます。
        　テスト履歴では、苦手な単語や選択反応の潜時を確認できます。（記録は1年後に自動的に消去されます。）

        このアプリは、以下の画像、音声、効果音を使用しています。
        
        画　像：フリーイラスト素材集 ジャパクリップ
        
        音　声：VOICEVOX Nemo
        
        効果音：Springin’ Sound Stock
        
        
        
        
        謝辞
        　最後になりましたが、筑波大学の野呂先生をはじめ、多くの先生方にご指導いただき、応用行動分析学や障害科学について学ぶ貴重な機会を得ることができました。
        　また、本アプリの開発に際し、ご支援いただいた茨城県教育委員会ならびに、所属する特別支援学校の校長先生、副校長先生、教頭先生、そして先生方に深く感謝申し上げます。
        　さらに、本アプリの作成にあたり、最後まで温かくサポートしていただいたiOSアカデミアの星様、本アプリで使用する画像や音声、効果音の提供・使用を許可してくださった皆様にも、心より御礼申し上げます。
        　
        
        製作者：nikaido
        """
        
        // NSAttributedStringを作成
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // 全体のフォントサイズを15に設定
        let defaultFontSize: CGFloat = 20
        let defaultFont = UIFont.systemFont(ofSize: defaultFontSize)
        attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: fullText.count))
        
        // 文字サイズを変更したい範囲を指定
        let range1 = (fullText as NSString).range(of: "アプリについて")
        let range2 = (fullText as NSString).range(of: "使い方")
        let range3 = (fullText as NSString).range(of: "テスト")
        let range4 = (fullText as NSString).range(of: "")
        let range5 = (fullText as NSString).range(of: "フリーイラスト素材集 ジャパクリップ")
        let range6 = (fullText as NSString).range(of: "VOICEVOX Nemo")
        let range7 = (fullText as NSString).range(of: "Springin’ Sound Stock")
        
        // 文字サイズを変更する属性を設定
        let fontSize: CGFloat = 20 // 変更したいフォントサイズ
        let font = UIFont.boldSystemFont(ofSize: fontSize) // 太字にしたい場合はboldSystemFontを使用
        
        // 指定した範囲にフォント属性を適用
        attributedString.addAttribute(.font, value: font, range: range1)
        attributedString.addAttribute(.font, value: font, range: range2)
        attributedString.addAttribute(.font, value: font, range: range3)
        attributedString.addAttribute(.font, value: font, range: range4)
        attributedString.addAttribute(.font, value: font, range: range5)
        attributedString.addAttribute(.font, value: font, range: range6)
        attributedString.addAttribute(.font, value: font, range: range7)
        // 「製作者：」を右詰めにする
        let rangeCreator = (fullText as NSString).range(of: "製作者：nikaido")
        if rangeCreator.location != NSNotFound {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right // 右詰めにする
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: rangeCreator)
        }
        
        // UITextViewにNSAttributedStringを設定
        text.attributedText = attributedString
        
        // UITextViewを編集不可にする
        text.isEditable = false
        text.isSelectable = false 
    }
    
    
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

