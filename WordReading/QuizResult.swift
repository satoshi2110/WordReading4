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
    @Persisted var timeTaken: Double = 0.0
    @Persisted var date: Date = Date()
    @Persisted var correctCount: Int = 0
}

