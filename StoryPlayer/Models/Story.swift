//
//  Story.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import Foundation

struct Story: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var author: String
    var imageUrl: String
    var url: String
    var isFavorite: Bool = false
}

#if DEBUG
extension Story {
    static let testData: [Story] = [
        Story(title: "Little Red Riding Hood", description: "A young girl is chased by a cunning wolf", author: "Charles Perrault", imageUrl: "little-red-riding-hood", url: "little-red-riding-hood"),
        Story(title: "The Emperors New Clothes", description: "", author: "Hans Christian Andersen", imageUrl: "emperors-new-clothes", url: "emperors-new-clothes"),
        Story(title: "The Little Mermaid", description: "", author: "Hans Christian Andersen", imageUrl: "little-mermaid", url: "little-mermaid"),
        Story(title: "Little Red Riding Hood", description: "A young girl is chased by a cunning wolf", author: "Charles Perrault", imageUrl: "little-red-riding-hood", url: "little-red-riding-hood"),
        Story(title: "The Emperors New Clothes", description: "", author: "Hans Christian Andersen", imageUrl: "emperors-new-clothes", url: "emperors-new-clothes"),
        Story(title: "The Little Mermaid", description: "", author: "Hans Christian Andersen", imageUrl: "little-mermaid", url: "little-mermaid")
    ]
}
#endif
