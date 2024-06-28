//
//  DailyScrum.swift
//  ScrumdingerTest
//
//  Created by ksy on 6/28/24.
//

import Foundation

struct DailyScrum {
    var title: String
    var attendees: [String]
    var lengthInMinutes: Int
    var theme: Theme
}

//샘플데이터 제공
extension DailyScrum {
    static let sampleData: [DailyScrum] =
    [
        DailyScrum(title: "Design",
                   attendees: ["Cathy", "Daisy", "Simon", "Jonathan"],
                   lengthInMinutes: 10,
                   theme: .yellow),
        
        DailyScrum(title: "App Dev",
                   attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"],
                   lengthInMinutes: 5,
                   theme: .orange),
        
        DailyScrum(title: "Web Dav",
                   attendees: ["Chella", "chris", "christina", "Eden", "Karla", "Lindsey", "Aga", "chad", "Jenn", "Sarah"],
                   lengthInMinutes: 5,
                   theme: .popple)
    ]
}
