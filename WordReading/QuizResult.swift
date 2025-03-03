//
//  QuizResult.swift
//  WordReading4
//
//  Created by N S on 2025/02/23.
//

import Foundation
import RealmSwift

class QuizResult: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var quizID: String = ""
    @Persisted var quizImageName: String = ""
    @Persisted var selectedAnswer: String = ""
    @Persisted var isCorrect: Bool = false
    @Persisted var timeTaken: Double = 0.0 // 個々の問題にかかった時間
    @Persisted var totalTime: Double = 0.0 // セッション全体のトータル時間
    @Persisted var date: Date = Date()
    @Persisted var correctCount: Int = 0
    @Persisted var selectLevel: Int = 1 // デフォルトで「基礎」レベル
    @Persisted var selectLength: Int = 2 // デフォルトで「2文字」
    
    // プライマリキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // インデックスの設定
    override static func indexedProperties() -> [String] {
        return ["quizID", "date"]
    }
    
    // バリデーション
    override static func validateValue(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey key: String) throws {
        if key == "selectLevel" {
            let level = value.pointee as? Int ?? 0
            if level < 1 || level > 2 {
                throw NSError(domain: "InvalidLevel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid selectLevel value"])
            }
        }
    }
    
    // 日付をフォーマットするメソッド
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        return dateFormatter.string(from: date)
    }
    
    // 所要時間をフォーマットするメソッド
    func formattedTimeTaken() -> String {
        return String(format: "%.1f秒", timeTaken)
    }
    
    // トータル時間をフォーマットするメソッド
    func formattedTotalTime() -> String {
        return String(format: "%.1f秒", totalTime)
    }
}
