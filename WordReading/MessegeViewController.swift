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
        　このアプリは、お子さまが楽しみながら ひらがなの読みを学習できるように設計されています。応用行動分析学（ABA）の 「継次的刺激ペアリング手続き」を取り入れ、文字・音声・絵の関係を自然に学習できる仕組みになっています。また、視線移動の練習にもなり、長い文章を読むための基礎作りにもなります。

        使い方
        　3つの選択肢から1つ選ぶと、単語がランダムに表示されます。ひらがなが1文字ずつ表示されるので、お子さまにタップさせてください。タップすると音声が流れ、最後までタップすると単語全体の音声が流れます。すべての文字（例：「あめ」）が表示された後にイラストが現れ、一部のイラストではタップすると効果音も再生されます。新しい単語が表示され、この流れを4〜5回繰り返します。
        
        　この「見る・聞く・触る」の繰り返しにより、無理なく、ひらがなの読みが習得できます。このアプリでは、「を」を除く、ひらがな50音を学ぶことができます。
        
        学習できる単語
        2文字の単語
        　左ボタン：あめ、いぬ、すず、ねこ、むし
        　中ボタン：せみ、へび、さる、よる、やま
        　右ボタン：よむ、ほん、にく、ふゆ、もも

        3文字の単語
        　左ボタン：はなび、たきび、とけい、おばけ
        　中ボタン：からす、おかね、やさい、ちくわ
        　右ボタン：じしん、おかし、てれび、といれ

        4文字の単語
        　左ボタン：そうじき、くつした、のみもの、ほうせき
        　中ボタン：えんぴつ、てぶくろ、かみなり、あおぞら
        　右ボタン：ふうりん、にわとり、ひまわり、こうえん

        テスト機能について
        　応用行動分析学（ABA）の「見本合わせ課題手続き」を活用し、絵に対応するひらがなを選ぶことで、文字と絵のつながりを確認、学習できる仕組みです。お子さまの習熟度に応じて、テストを先に実施することもできます。
        
        テストの種類
        　基礎テスト：学習した単語を使い、ひらがなの読みを確認
        　応用テスト：未学習の単語を使い、ひらがなの読みを確認
        
        テストのポイント！
        　お子さまが正しく選べるようになったら、「もっと早く選んでみよう！」と声をかけてみてください。選択スピードが上がると記憶が定着しやすくなり、アプリ以外の場面でもスムーズに読めるようになります。
        　また、テスト履歴では 苦手な単語や選択の速さを確認できます。記録はアプリ内に保存され、1年後に自動的に削除されるので、安心して利用できます。

        このアプリは、以下の画像、音声、効果音を使用しています。
        
        画　像：フリーイラスト素材集 ジャパクリップ
        
        音　声：VOICEVOX Nemo
        
        効果音：Springin’ Sound Stock
        
        　
        要望・不具合などはこちらへ：s2421339@u.tsukuba.ac.jp
        
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
        let range3 = (fullText as NSString).range(of: "テスト機能について")
        let range4 = (fullText as NSString).range(of: "学習できる単語")
        let range5 = (fullText as NSString).range(of: "フリーイラスト素材集 ジャパクリップ")
        let range6 = (fullText as NSString).range(of: "VOICEVOX Nemo")
        let range7 = (fullText as NSString).range(of: "Springin’ Sound Stock")
        let range8 = (fullText as NSString).range(of: "テストの種類")
        let range9 = (fullText as NSString).range(of: "テストのポイント！")


        
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
        attributedString.addAttribute(.font, value: font, range: range8)
        attributedString.addAttribute(.font, value: font, range: range9)
        
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

