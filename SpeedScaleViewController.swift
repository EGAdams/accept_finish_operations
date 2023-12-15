// modifying on wednesday.  build gpt?
import UIKit
import AVFoundation
class SpeedScaleViewController: UIViewController, RunStatusChangeListener, AccelerationControllerDelegate  {
    private var accelerationController: AccelerationController?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()}
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        print("SpeedScaleViewController present called with viewController: \(viewControllerToPresent)")
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    private func setup() {
        let tempConfig = MeasureConfig(
            measurementUnits: MeasureConfig.MeasurementUnits.IMPERIAL,
            forceUnits: MeasureConfig.ForceUnits.PERCENT_G,
            monitorInterval: 25,
            targetStoppingSpeed: 50.0,
            tolerance: 1.0,
            minRecordingSpeed: 5.0,
            alignedValues: [1.0, 2.0, 3.0]
        )
        self.accelerationController = AccelerationController( config: tempConfig, runStatusChangeListener: self )
        accelerationController?.delegate = self
    }
    
    func playSound() {
        guard let soundURL = Bundle.main.url( forResource: "soundFileName", withExtension: "mp3" ) else { return }
        do {
            let soundPlayer = try AVAudioPlayer( contentsOf: soundURL )
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        } catch { print( "Error playing sound: \( error.localizedDescription )" )}}
    
    func onStatusChanged( runStatus: RunStatus ) {
        print( "run status is now: "); print( runStatus )
        let runStatusString = String( describing: runStatus )
        if runStatusString.contains( "STOP" ) {
            instruction.text = "Bring the vehicle to a complete stop. Press the \"Next Run\" button to begin the test."
        } else if runStatusString.contains( "ACCEL" ) {
            instruction.textColor = UIColor.blue
            instruction.text = "Accelerate to 20 mph."
        } else if runStatusString.contains( "BRAK" ) {
            if !isSoundPlayedInThisRun {
                isSoundPlayedInThisRun = true
                playSound()
            }
            instruction.text = "Apply brakes smoothly and firmly to induce a full skid."
            instruction.textColor = UIColor.blue }}

    private var measureConfig = MeasureConfig(
        measurementUnits: MeasureConfig.MeasurementUnits.IMPERIAL,
        forceUnits: MeasureConfig.ForceUnits.PERCENT_G,
        monitorInterval: 25,
        targetStoppingSpeed: 50.0,
        tolerance: 1.0,
        minRecordingSpeed: 5.0,
        alignedValues: [1.0, 2.0, 3.0]
    )
    
    private var isSoundPlayedInThisRun = false
    private var variable: Float = -2.0
    private var timer: Timer?
    private var variableUpdater: VariableUpdater!
    public var speedScaleView: SpeedScaleView!
    private var converter: RcrConverter!
    public var gravityValue = 0
    public var mphValue = 0
    private var test_data_file: FileHandle? = FileHandle(forReadingAtPath: "/Users/clay/Desktop/AirportNAC/Airport_Project/User_Interfaces/View_Controllers/test_data.txt" )
    public var test_data_array: [String] = []
    public var test_data_index: Int = 0
    var gravityLabel: UILabel!
    var mphLabel: UILabel!
    @IBOutlet weak var nextRunButton: UIButton!
    @IBOutlet weak var instruction: UITextView!
    @IBOutlet weak var speed: UITextField!
    var brakingValueSetForEndDialog: Bool = false
//    @IBAction func sliderValueChanged( _ sender: UISlider ) {
//        let sliderSpeed = sender.value  // This will be a value between -100 and 100
//        self.updateGauge(newSpeed: Int(sliderSpeed), newYaw: Int(sliderSpeed))
//    } // set the speed of the SpeedScaleView
    
    public func updateGauge( newSpeed: Int,  newYaw: Int ) {
        let number = Float(newYaw) / 1.0 // Your calculated number
        var formattedString = String(format: "%.2f %% g", number)

        if abs(number) < 10.0 {
            if number < 0 {
                // Insert "0" right after the "-" sign for negative numbers
                if let minusIndex = formattedString.firstIndex(of: "-") {
                    let nextIndex = formattedString.index(after: minusIndex)
                    formattedString.insert("0", at: nextIndex)
                }
            } else { formattedString.insert("0", at: formattedString.startIndex )}}
     
        self.gravityLabel.text = formattedString
        self.mphLabel.text = String(format: "%.2f mph", Float(newSpeed) / 1.0 )        
        self.mphLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        self.gravityLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        if newSpeed >= 20 && ( accelerationController?.getRunStatus().contains( "ACCEL" ) == true ) { // ACCEL in text?
            self.gravityLabel.isHidden = false
            self.mphLabel.isHidden = false
            accelerationController!.nextRun() } // yes, switch to next state
        
        print("value changed speed: \(newSpeed) yaw:  \(newYaw)")
        speedScaleView.speed = CGFloat( newSpeed )
        updateYawIndicator( yawValue: CGFloat( newYaw ))
        
        if newSpeed >= -5 && newSpeed <= 5 {
            nextRunButton.isEnabled = true
        } else { nextRunButton.isEnabled = false }
        
        if newSpeed <= 5 && ( accelerationController?.getRunStatus().contains( "BRAKING" ) == true ) { // BRAKING in text?
            self.gravityLabel.isHidden = false
            self.mphLabel.isHidden = false
            if ( self.brakingValueSetForEndDialog == false ) {
                accelerationController!.setResultBreakingValue( resultBreakingValue: Float( newYaw ))
                self.brakingValueSetForEndDialog = true // don't forget to set this to false if needed in the future!
            }
            accelerationController!.nextRun()
        } // yes, switch to next state
        // convertedSpeed.text = String( converter.convert( sliderSpeed: Int( sliderSpeed )))
    }

    @IBAction func runButtonTapped(_ sender: UIButton) {
        accelerationController!.nextRun()
    }

    override func viewDidLoad() {
        print("SpeedScaleViewController viewDidLoad called")
        super.viewDidLoad()
        let TEXT_X_POSITION  = 400
        let xPositionMph     = TEXT_X_POSITION
        let yPositionMph     = 270
        let xPositionGravity = TEXT_X_POSITION
        let yPositionGravity = 230
        let labelWidth       = 140
        let labelHeight      = 50
        
        nextRunButton.isEnabled = true
        instruction.text = "Bring the vehicle to a complete stop. Press the \"Next Run\" button to begin the test."
        view.backgroundColor = UIColor.white   // Initialize the SpeedScaleView and add it to the view hierarchy
        let gaugeSize: CGFloat = 30  // This is just an example size. Adjust it according to your needs.
        let gaugeOrigin = CGPoint(x: (view.bounds.width - gaugeSize) / 2, y: (view.bounds.height - gaugeSize) / 2)
        speedScaleView = SpeedScaleView(frame: CGRect(origin: gaugeOrigin, size: CGSize(width: gaugeSize, height: gaugeSize)))
        speedScaleView.backgroundColor = .clear
        view.insertSubview(speedScaleView, at: 0)
        let desiredLeadingPadding: CGFloat = -255.0 // Adjust this value as needed
        speedScaleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speedScaleView.topAnchor.constraint( equalTo: view.topAnchor ),
            speedScaleView.bottomAnchor.constraint( equalTo: view.bottomAnchor ),
            speedScaleView.leadingAnchor.constraint( equalTo: view.leadingAnchor, constant: desiredLeadingPadding ),
            speedScaleView.trailingAnchor.constraint( equalTo: view.trailingAnchor )])
        speedScaleView.speed = 0
        self.gravityLabel = UILabel()
        self.gravityLabel.frame = CGRect(x: xPositionGravity, y: yPositionGravity, width: labelWidth, height: labelHeight)
        self.mphLabel = UILabel()
        self.mphLabel.frame = CGRect(x: xPositionMph, y: yPositionMph, width: labelWidth, height: labelHeight)
        self.gravityLabel.textColor = UIColor.yellow
        self.mphLabel.textColor = UIColor.green
        self.gravityLabel.isHidden = true
        self.mphLabel.isHidden = true
        speedScaleView.addSubview( mphLabel )
        speedScaleView.addSubview( gravityLabel )
        speedScaleView.bringSubviewToFront( mphLabel )
        speedScaleView.bringSubviewToFront( gravityLabel )
        self.converter = RcrConverter()
        if self.test_data_file != nil {
            let data = test_data_file?.readDataToEndOfFile()
            let dataString = String(data: data!, encoding: .utf8)
            test_data_array = dataString!.components(separatedBy: "\n")
            test_data_file?.closeFile() }

        accelerationController = AccelerationController(config: measureConfig, runStatusChangeListener: self)
        accelerationController?.delegate = self
        variableUpdater = VariableUpdater( speedScaleViewController: self )
        variableUpdater.startUpdatingVariable() // startUpdatingVariable()  // Start timer here!
        }
    func updateYawIndicator( yawValue: CGFloat ) { speedScaleView.yawIndicator.moveIndicator(toYaw: yawValue )}
}
