//  Test.swift
//  Created by Clay Ackerland on 11/17/23 -EG
import Foundation

class Test: Codable {
    var operator_name: String = ""
    var offset: String = ""
    var testDate: Int64
    var runCount: Int
    var programId: Int64
    var average: Float
    var average13: Float
    var average23: Float
    var average33: Float
    var testSpeed: Float
    var condition: String = ""
    var runList: [Run]

    init() {
        self.testDate = 0
        self.runCount = 0
        self.programId = 0
        self.average = 0.0
        self.average13 = 0.0
        self.average23 = 0.0
        self.average33 = 0.0
        self.testSpeed = 0.0
        self.runList = []
    }

    func addRun(run: Run) {
        runList.append(run)
    }

    func calculateAverage() -> Float {
        if runList.count > 0 {
            let sum = runList.reduce(0) { $0 + $1.value }
            return sum / Float(runList.count)
        }
        return 0.0
    }
}
