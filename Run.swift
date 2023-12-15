//  Run.swift
//  Created by Clay Ackerland on 11/17/23 -EG
import Foundation

class Run: Codable {
    var condition: String
    var date: Int64
    var value: Float
    var testId: Int64

    init( condition: String = "", date: Int64 = 0, value: Float = 0.0, testId: Int64 = 0 ) {
        self.condition = condition
        self.date = date
        self.value = value
        self.testId = testId
    }

    // Getters and setters are not required in Swift.
    // Properties are by default internal and can be accessed directly
}
