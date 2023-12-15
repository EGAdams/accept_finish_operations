//  TestTableViewCell.swift
//  Created by Clay Ackerland on 12/7/23 -EG
import Foundation
import UIKit

class TestTableViewCell: UITableViewCell {
    let timeLabel = UILabel()
    let dateLabel = UILabel()
    let testsLabel = UILabel()
    let averageLabel = UILabel()
    let average13Label = UILabel()
    let average23Label = UILabel()
    let average33Label = UILabel()
    let contaminateLabel = UILabel()
    
    // Add a button for the checkbox
   // let selectButton = UIButton(type: .custom)
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       setupUI()
   }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    private func setupUI() {
        
        /// Setup the checkbox button
//        contentView.addSubview(selectButton)
//        selectButton.translatesAutoresizingMaskIntoConstraints = false
//        selectButton.setContentHuggingPriority(.required, for: .horizontal)
//        selectButton.setContentCompressionResistancePriority(.required, for: .horizontal)
//
//        // Set images for checkbox states
//        let uncheckedImage = UIImage(named: "unchecked_checkbox") // Replace with your image
//        let checkedImage = UIImage(named: "checked_checkbox") // Replace with your image
//        selectButton.setImage(uncheckedImage, for: .normal)
//        selectButton.setImage(checkedImage, for: .selected)
       
        
        // Add all labels as subviews
        let labels = [ timeLabel, dateLabel, testsLabel, averageLabel, average13Label, average23Label, average33Label, contaminateLabel /*, selectButton */ ]
        for label in labels {
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        // Time Label
        NSLayoutConstraint.activate([
            // start to the left 10 units
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2)
        ])
        
        // Date Label
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: -20 ),
            // Adjust this multiplier as needed
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2)
        ])
        
        // Tests Label
        NSLayoutConstraint.activate([
            testsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            testsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            testsLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: -30 ),
            // Adjust this multiplier as needed
            testsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.05 )
        ])
        
        // Average Label
        // Repeat the same pattern of constraints for averageLabel, adjusting leadingAnchor and widthAnchor
        NSLayoutConstraint.activate([
            averageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            averageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            averageLabel.leadingAnchor.constraint(equalTo: testsLabel.trailingAnchor, constant: 12 ),
            // Adjust this multiplier as needed
            averageLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1)
        ])
        
        // Average13 Label
        // Repeat the same pattern of constraints for average13Label, adjusting leadingAnchor and widthAnchor
        NSLayoutConstraint.activate([
            average13Label.topAnchor.constraint(equalTo: contentView.topAnchor),
            average13Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            average13Label.leadingAnchor.constraint(equalTo: averageLabel.trailingAnchor),
            // Adjust this multiplier as needed
            average13Label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1)
        ])
        
        // Average23 Label
        // Repeat the same pattern of constraints for average23Label, adjusting leadingAnchor and widthAnchor
        NSLayoutConstraint.activate([
            average23Label.topAnchor.constraint(equalTo: contentView.topAnchor),
            average23Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            average23Label.leadingAnchor.constraint(equalTo: average13Label.trailingAnchor),
            // Adjust this multiplier as needed
            average23Label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1)
        ])
        
        // Average33 Label
        // Repeat the same pattern of constraints for average33Label, adjusting leadingAnchor and widthAnchor
        NSLayoutConstraint.activate([
            average33Label.topAnchor.constraint(equalTo: contentView.topAnchor),
            average33Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            average33Label.leadingAnchor.constraint(equalTo: average23Label.trailingAnchor),
            // Adjust this multiplier as needed
            average33Label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1)
        ])
        
        // Contaminate Label
        NSLayoutConstraint.activate([
            contaminateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            contaminateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contaminateLabel.leadingAnchor.constraint(equalTo: average33Label.trailingAnchor, constant: 25 ),
            // Adjust this width as needed, or you can have it fill the remaining space
            contaminateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // Setup constraints for the checkbox button
//        selectButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            selectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            selectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10), // Adjust the padding as needed
//            selectButton.widthAnchor.constraint(equalToConstant: 44), // Adjust the size as needed
//            selectButton.heightAnchor.constraint(equalToConstant: 44) // Adjust the size as needed
//        ])
//
//        // Add action for button tap
//        selectButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }

    // @objc private func checkboxTapped(_ sender: UIButton) {
    //     sender.isSelected = !sender.isSelected
    //     // Handle the checkbox state change if needed, such as updating a model
    // }

    func configure(with test: Test) {
        // Configure the cell with data
        timeLabel.text = formatTestTime(from: test.testDate)
        dateLabel.text = formatTestDate(from: test.testDate)
        testsLabel.text = "\(test.runCount)"
        averageLabel.text = String(format: "%.2f%%", test.average)
        average13Label.text = String(format: "%.2f%%", test.average13)
        average23Label.text = String(format: "%.2f%%", test.average23)
        average33Label.text = String(format: "%.2f%%", test.average33)
        contaminateLabel.text = test.condition
    }
    
    private func formatTestDate(from timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
        return dateFormatter.string(from: date)
    }
    
    private func formatTestTime(from timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
}
