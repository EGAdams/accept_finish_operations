//  AccellerationController.swift
//  Airport_Project
//  Created by Clay Ackerland on 7/10/23.
import Foundation
import UIKit

struct ForceUnits { static let percentG = "PERCENT_G"; static let rcr = "RCR" }

struct MeasurementUnits { static let metrics = "METRICS" }

protocol AccelerationControllerDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

public class AccelerationController: OnActionListener {
    weak var delegate: AccelerationControllerDelegate?
    private var isDialogPresented = false
    private let NS2S: Float = 1.0 / 1000000000.0
    private let START_THRESHOLD: Double = 0.5
    private let SENSETIVITY_THRESHOLD: Double = 0.2
    private var config: MeasureConfig
    // private var speedometerView: SpeedometerView
    private var runStatus: String
    private var currentSpeed: Float = 0.0
    private var timestamp: Float
    private var minBreakingValue: Float
    private var resultBreakingValue: Float
    public var runStatusChangeListener: RunStatusChangeListener
    
    public enum RunStatus: String, Equatable {
        case readyToStart = "READY_TO_START"
        case invalid = "INVALID"
        case accelerating = "ACCELERATING"
        case startBraking = "START_BRAKING"
        case tooFast = "TOO_FAST"
        case braking = "BRAKING"
    }

    func getRunStatus() -> String { return runStatus }
    
    func convertToCurrentValues( rawValues: [ Double ] ) -> [ Double ] {
        if config.getForceUnits().rawValue == ForceUnits.percentG {
            return Converter.rawToGravityPercent( values: rawValues )
        } else { return Converter.rawToRcr( values: rawValues )}}

    func applySensitivity( values: [ Double ] ) -> [ Double ] {
        var newValues = values
        for i in 0..<newValues.count {
            if abs( newValues[ i ]) < SENSETIVITY_THRESHOLD { newValues[ i ] = 0.0 }}
        return newValues }
    
    public func updateAcceleration( rawValues: [Double], timestamp: Double ) {
        var values = [Double](repeating: 0.0, count: 3)
        let alignValues = config.getAlignedValues()
        if alignValues != nil {
            var i = 0
            while i < values.count {
                values[ i ] = -( rawValues[ i ] - Double(alignValues![ i ]))
                i += 1
            }
        } else {
            var i = 0
            while i < values.count {
                values[ i ] = -( rawValues[ i ])
                i += 1 }
            }
        // now that we have the values, apply sensitivity       
        values = applySensitivity( values: values )
        let doubleValues = values.map { Double($0) }
        let currentValues = convertToCurrentValues( rawValues: doubleValues )

        switch runStatus {
        case RunStatus.readyToStart.rawValue:
            if abs( values[2] ) < START_THRESHOLD {
                // runStatusChangeListener.onStatusChanged( runStatus: .readyToStart )

            } else {
                // runStatusChangeListener.onStatusChanged( runStatus: .invalid )
            }
            break
        // ...add more cases here if we need them
        default:
            print ( "default case for runstatus in AccelerationController" )}
        self.timestamp = Float( timestamp )
        // speedometerView.moveHand( newAngle: CGFloat(currentValues[ 2 ]) )
        // speedometerView.updateSpeedometerLabel( newLabelTextArg: CGFloat(currentValues[ 1 ]))
    }

    init( config: MeasureConfig, runStatusChangeListener: RunStatusChangeListener ) {
        self.config = config
        /// self.speedometerView = speedometerView
        self.runStatusChangeListener = runStatusChangeListener
        self.runStatus = RunStatus.readyToStart.rawValue
        self.timestamp = 0
        self.minBreakingValue = 0
        self.resultBreakingValue = 0
        // speedometerView.setForceString( forceStringArg: config.getForceUnitsString() )
        // speedometerView.setMeasurementString( measurementStringArg: config.getMeasurementUnitsString())
    }

    func getCurrentSpeed( value: Float, newTimestamp: Float ) -> Float {
        let dT = ( newTimestamp - self.timestamp ) * NS2S
        let result = value * dT
        if config.getMeasurementUnits().rawValue == MeasurementUnits.metrics {
            return result * 3.6            // Convert to kph
        } else { return result * 2.2369 }} // Convert to mph

    func nextRun() {
        print ( "switching run status..." )
        print ( runStatus  )
        switch runStatus {
        case RunStatus.readyToStart.rawValue:
            print( "switching to ready to start..." )
            runStatus = RunStatus.accelerating.rawValue
            runStatusChangeListener.onStatusChanged(runStatus: .accelerating)
            currentSpeed = 0.0
        case RunStatus.accelerating.rawValue:
            print ( "switching to braking... " )
            runStatus = RunStatus.braking.rawValue
            runStatusChangeListener.onStatusChanged(runStatus: .braking)
            currentSpeed = 0.0
        case RunStatus.braking.rawValue:
            if !isDialogPresented {
                isDialogPresented = true
                print( "showing dialog..." )
                print("Attempting to present RunCompleteViewController")
                if delegate == nil {
                    print("Delegate is nil. Cannot present view controller.")
                } else {
                    print("Delegate is set. Attempting to present view controller.")
                }
                // Create and configure the custom dialog box
                let customDialogBox = RunCompleteViewController( controller: self )
                customDialogBox.modalPresentationStyle = .overCurrentContext
                customDialogBox.modalTransitionStyle = .crossDissolve
                customDialogBox.modalPresentationStyle = .overFullScreen // This ensures it covers the entire screen

                customDialogBox.resultValue = getResultBreakingValue() // Assuming you have the percent gravity value here.
                customDialogBox.onAccept = { [weak self] in
                    print("recording test...")
                    // Dismiss is called on the presenting view controller, not the delegate
                    customDialogBox.dismiss(animated: true, completion: nil)
                }
                // Present the custom dialog box using the delegate
                delegate?.present(customDialogBox, animated: true, completion: nil)
                
                customDialogBox.onAccept = { [weak self] in
                    self?.isDialogPresented = false
                    // ... existing code ...
                }
            }
            
        default:
            print( "default status." )
            break
        }
    }

    func reset() {
        runStatus = RunStatus.readyToStart.rawValue
        currentSpeed = 0.0 }

    func getResultBreakingValue() -> Float {
        return abs(resultBreakingValue) }

    func setResultBreakingValue(resultBreakingValue: Float) {
        self.resultBreakingValue = resultBreakingValue }}
