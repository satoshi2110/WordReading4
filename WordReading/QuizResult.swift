//
//  QuizResult.swift
//  WordReading4
//
//  Created by N S on 2025/02/23.
//

import Foundation
import RealmSwift

class QuizResult: Object {
    @objc dynamic var quizImageName: String = ""
    @objc dynamic var selectedAnswer: String = ""
    @objc dynamic var isCorrect: Bool = false
    @objc dynamic var timeTaken: Double = 0.0
    @objc dynamic var date: Date = Date()
    @objc dynamic var correctCount: Int = 0
}

