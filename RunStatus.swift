//  RunStatus.swift
//  Airport_Project
//  Created by Clay Ackerland on 7/11/23.
public struct RunStatus {
    static let readyToStart = RunStatus(value: "READY_TO_START")
    static let invalid      = RunStatus(value: "INVALID")
    static let accelerating = RunStatus(value: "ACCELERATING")
    static let startBraking = RunStatus(value: "START_BRAKING")
    static let tooFast      = RunStatus(value: "TOO_FAST")
    static let braking      = RunStatus(value: "BRAKING")
    
    let value: String
}
