import UIKit

class RunCompleteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var resultValue: Float = 0.0  // This should be set before presenting the dialog
    var onAccept: (() -> Void)?
    
    private var tempTest = Test()
    private var tempRun = Run()
    private var selectedCondition: String = "" // To store the selected condition
    private let contaminate = UILabel()
    private let optionsButton = UIButton()
    private let optionsTableView = UITableView()
    private let acceptButton = UIButton()
    private let rejectButton = UIButton()
    private let options = ["Loose Snow (LSR)", "Packed Snow (PSR)", "Ice (IR)", "Wet (WR)", "Slush (SLR)", "Patchy Ice (PIR)", "Patchy Slush (PSR)"]
    private var isDropdownVisible = false
    private var accelerationController: AccelerationController
    init(controller: AccelerationController) {
        self.accelerationController = controller
        super.init(nibName: nil, bundle: nil)
        // Additional initialization if necessary
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.white
        let dialogBox = UIView()
        dialogBox.layer.borderWidth = 2
        dialogBox.layer.borderColor = UIColor.black.cgColor
        dialogBox.backgroundColor = UIColor.lightGray
        dialogBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dialogBox)

        // Setup the "Run Complete" title
        let titleLabel = UILabel()
        titleLabel.text = "Run Complete"
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogBox.addSubview(titleLabel)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textAlignment = .center

        // Setup the "Result" label
        let resultLabel = UILabel()
        resultLabel.text = "Result"
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogBox.addSubview(resultLabel)
        resultLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        resultLabel.textAlignment = .center

        // Display the percentage gravity
        let gravityLabel = UILabel()
        let gravityValue = String(format: "%.2f %% g", resultValue )
        gravityLabel.text = gravityValue
        gravityLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogBox.addSubview(gravityLabel)

        // make gravity lable larger font size, bold and green
        gravityLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        gravityLabel.textAlignment = .center
        gravityLabel.textColor = UIColor.green
        
        
        // Setup the accept button
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.backgroundColor = UIColor.blue
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(acceptButton)

        // Setup the reject button
        rejectButton.setTitle("Reject", for: .normal)
        rejectButton.backgroundColor = UIColor.red
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rejectButton)

        // Setup the options button
        optionsButton.setTitle("Select Option", for: .normal)
        optionsButton.backgroundColor = UIColor.blue
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsButton)

        // Setup the options table view
        optionsTableView.isHidden = true
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsTableView)

        // Constraints for options button
        NSLayoutConstraint.activate([
            optionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            optionsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            optionsButton.widthAnchor.constraint(equalToConstant: 200),
            optionsButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Constraints for options table view
        NSLayoutConstraint.activate([
            optionsTableView.topAnchor.constraint(equalTo: optionsButton.bottomAnchor),
            optionsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            optionsTableView.widthAnchor.constraint(equalToConstant: 200),
            optionsTableView.heightAnchor.constraint(equalToConstant: 175)  // Adjust as needed
        ])

        // Constraints for accept button
        NSLayoutConstraint.activate([
            acceptButton.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: -120), // y-pos
            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 220),        // x-pos
            acceptButton.widthAnchor.constraint(equalToConstant: 100),
            acceptButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Constraints for reject button
        NSLayoutConstraint.activate([
            rejectButton.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: -120), // y-pos
            rejectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -220),     // x-pos
            rejectButton.widthAnchor.constraint(equalToConstant: 100),
            rejectButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Button action
        optionsButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptPressed), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        // Setup the "Contaminate" label
        contaminate.text = "Contaminate"
        contaminate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contaminate)

        // Constraints for "Contaminate" label
        // place contaminant label above the options button. Put a red border around it too.
        NSLayoutConstraint.activate([
            contaminate.bottomAnchor.constraint(equalTo: optionsButton.topAnchor, constant: 10),
            contaminate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contaminate.widthAnchor.constraint(equalToConstant: 200),
            contaminate.heightAnchor.constraint(equalToConstant: 50)
        ])
        contaminate.font = UIFont.boldSystemFont(ofSize: 20.0)
        contaminate.textAlignment = .center

        // Constraints for dialog box
        NSLayoutConstraint.activate([
            dialogBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialogBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialogBox.widthAnchor.constraint(equalToConstant: 300),
            dialogBox.heightAnchor.constraint(equalToConstant: 300)
        ])

        // Constraints for "Run Complete" title
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dialogBox.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: dialogBox.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: dialogBox.widthAnchor)
        ])

        // Make "Run Complete" title white
        titleLabel.textColor = UIColor.white
        // increase the font size
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)

        // Constraints for "Result" label
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            resultLabel.centerXAnchor.constraint(equalTo: dialogBox.centerXAnchor)
        ])

        // Constraints for gravity label
        NSLayoutConstraint.activate([
            gravityLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: -2 ),
            gravityLabel.centerXAnchor.constraint(equalTo: dialogBox.centerXAnchor)
        ])
    }

    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        optionsTableView.isHidden = !isDropdownVisible
    }

    @objc private func acceptPressed() {
        onAcceptRun(condition: selectedCondition) // Call onAcceptRun with selected condition
        dismiss(animated: true, completion: nil)
    }

    func getCurrentDateTime() -> Int64 {
        return Int64(Date().timeIntervalSince1970)
    }

    func onAcceptRun(condition: String) {
        tempRun.condition = condition
        // call getCurrentDateTime() to get the current date and time then translate it to an int64
        tempRun.date = getCurrentDateTime()
        tempTest.addRun( run: tempRun )
        let avg = String( format: "%.0f", tempTest.calculateAverage()) + "% g"
        // avgLabel.text = avg
        // testCountLabel.text = String(format: NSLocalizedString("test_count_format_label", comment: ""), tempTest.runList.count)
        self.accelerationController.reset()  // Assuming reset() is a method of accelController
    }

    @objc private func dismissDialog() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionsButton.setTitle(options[indexPath.row], for: .normal)
        toggleDropdown()
    }
}
