import UIKit

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testsArray.count
    }

    
    // MARK: IBOutlets
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    var testsArray: [Test] = []
    var dataSource: ProgramDataSource!
    var programCount: Int = 0
    
    // MARK: Start
    static func start(context: UIViewController, programCount: Int, requestCode: Int) {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil) // Replace "Main" with your storyboard's name if different.
        if let reviewVC = storyboard.instantiateViewController(withIdentifier: "ReviewViewControllerID") as? ReviewViewController {
            reviewVC.programCount = programCount
            context.present( reviewVC, animated: true, completion: nil )}}

    func generateTestData(count: Int) -> [Test] {
        var tests = [Test]()

        for _ in 0..<count {
            let test = Test()
            test.operator_name = "Operator \(Int.random(in: 1...10))"
            test.offset = "Offset \(Int.random(in: 1...50))"
            test.testDate = Int64(Date().timeIntervalSince1970) // Current timestamp
            test.runCount = Int.random(in: 1...20)
            test.programId = Int64.random(in: 1000...9999)
            test.average = Float.random(in: 10.0...100.0)
            test.average13 = Float.random(in: 10.0...100.0)
            test.average23 = Float.random(in: 10.0...100.0)
            test.average33 = Float.random(in: 10.0...100.0)
            test.testSpeed = Float.random(in: 50.0...200.0)
            test.condition = [ "Raining", "Wet", "Dry", "Foggy" ].randomElement() ?? "Dry"
            test.runList = generateMockRuns(count: test.runCount)

            tests.append(test)
        }

        return tests
    }

    func generateMockRuns(count: Int) -> [Run] {
        var runs = [Run]()

        for _ in 0..<count {
            let condition = [ "Raining", "Wet", "Dry", "Foggy" ].randomElement() ?? "Dry"
            let date = Int64(Date().timeIntervalSince1970) // Current timestamp
            let value = Float.random(in: 1.0...10.0)
            let testId = Int64.random(in: 1000...9999)

            let run = Run(condition: condition, date: date, value: value, testId: testId)
            runs.append(run)
        }

        return runs
    }

    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Debug: viewDidLoad called")
        
        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TestTableViewCell.self, forCellReuseIdentifier: "TestTableViewCell")
        
    

        setupTableViewConstraints()
        
        dataSource = ProgramDataSource()
        dataSource.open()
        updateProgramList(programCount: programCount)
        testsArray = generateTestData(count: 20)
        tableView.reloadData()
    }

    // view.bringSubviewToFront( delete ) // these two are now compile time failures.
    // view.bringSubviewToFront( export )
        
    func updateProgramList(programCount: Int) {
        print("Debug: updateProgramList called with programCount: \(programCount)")
        DispatchQueue.main.async {
            print( "Debug: reloadData was called on the main thread here before." )
        }
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = 1 // Or the actual number of sections you expect
        print("Debug: Number of sections in collectionView: \(sections)")
        return sections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Debug: TableView cellForRowAt called for indexPath: \(indexPath)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as? TestTableViewCell else {
            fatalError("Failed to dequeue a TestTableViewCell.")
        }
        let test = testsArray[indexPath.row]  // Assuming testsArray is your array of Test objects
        cell.configure(with: test)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // This should match the height set when initializing the headerView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Debug: viewWillAppear called")
        dataSource.open()
        // testsCollectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Debug: viewWillDisappear called")
        dataSource.close() }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Debug: viewDidAppear called, collectionView should be visible now.")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50) // Set your desired height
    }
    
    private func setupTableViewConstraints() {
        // Disable the autoresizing mask
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Set the constants for the spacing you need
        let sideSpacing: CGFloat = 20 // Adjust the side spacing to your needs
        let topSpacing: CGFloat = 120 // Adjust the top spacing to your needs, reducing the whitespace
        let bottomSpacing: CGFloat = 10 // Adjust the bottom spacing to your needs

        // Activate constraints
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideSpacing),
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: topSpacing),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -bottomSpacing)
        ])
    }
}

class TestCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        // Initialize the stack view and add the labels to it
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stack view to the cell's content view
        contentView.addSubview(stackView)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        // Additional cell styling
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = UIColor.white
        
        // Style the labels if needed
        titleLabel.textAlignment = .left
        descriptionLabel.textAlignment = .right
    }
}

class ProgramDataSource {
    func open() {}
    func close() {}
    func numberOfTests() -> Int { return 10 }
}
