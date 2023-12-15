//  Created by Clay Ackerland on 11/17/23 -EG
import Foundation

class Program: Codable {
    var airportName: String
    var location: String
    var comment: String
    var testList: [Test]?

    init(airportName: String, location: String, comment: String) {
        self.airportName = airportName
        self.location = location
        self.comment = comment
    }

    init(airportName: String, location: String, comment: String, testList: [Test]) {
        self.airportName = airportName
        self.location = location
        self.comment = comment
        self.testList = testList
    }

    // getters and setters are not typically used as properties are accessed directly.
    // If you need to observe or modify the properties during getting and setting,
    // you can use property observers like didSet and willSet.
}
