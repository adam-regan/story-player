//
//  StoryTests.swift
//  StoryTests
//
//  Created by Adam Regan on 23/02/2026.
//

@testable import StoryPlayer
import XCTest

@MainActor
final class StoryTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!

    override func setUpWithError() throws {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        encoder = nil
        decoder = nil
    }

    // MARK: - Encoding Tests

    func testStoryEncoding() throws {
        let story = try Story(
            id: XCTUnwrap(UUID(uuidString: "12345678-1234-1234-1234-123456789012")),
            title: "Test Story",
            description: "A test description",
            author: "Test Author",
            imageUrl: "test-image",
            url: "test-url",
            isFavorite: true
        )

        let data = try encoder.encode(story)

        XCTAssertFalse(data.isEmpty, "Encoded data should not be empty")

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json?["title"] as? String, "Test Story")
        XCTAssertEqual(json?["description"] as? String, "A test description")
        XCTAssertEqual(json?["author"] as? String, "Test Author")
        XCTAssertEqual(json?["imageUrl"] as? String, "test-image")
        XCTAssertEqual(json?["url"] as? String, "test-url")
        XCTAssertEqual(json?["isFavorite"] as? Bool, true)
    }

    func testStoryEncodingWithDefaultValues() throws {
        let story = Story(
            title: "Test Story",
            description: "A test description",
            author: "Test Author",
            imageUrl: "test-image",
            url: "test-url"
        )

        let data = try encoder.encode(story)

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json?["isFavorite"] as? Bool, false, "Default isFavorite should be false")
        XCTAssertNotNil(json?["id"], "ID should be generated")
    }

    func testStoryArrayEncoding() throws {
        let stories = [
            Story(title: "Story 1", description: "Description 1", author: "Author 1", imageUrl: "image1", url: "url1"),
            Story(title: "Story 2", description: "Description 2", author: "Author 2", imageUrl: "image2", url: "url2", isFavorite: true)
        ]

        let data = try encoder.encode(stories)

        XCTAssertFalse(data.isEmpty)
        let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        XCTAssertNotNil(jsonArray)
        XCTAssertEqual(jsonArray?.count, 2)
    }

    // MARK: - Decoding Tests

    func testStoryDecoding() throws {
        let json = """
        {
            "id": "12345678-1234-1234-1234-123456789012",
            "title": "Test Story",
            "description": "A test description",
            "author": "Test Author",
            "imageUrl": "test-image",
            "url": "test-url",
            "isFavorite": true
        }
        """.data(using: .utf8)!

        let story = try decoder.decode(Story.self, from: json)

        XCTAssertEqual(story.id.uuidString.uppercased(), "12345678-1234-1234-1234-123456789012")
        XCTAssertEqual(story.title, "Test Story")
        XCTAssertEqual(story.description, "A test description")
        XCTAssertEqual(story.author, "Test Author")
        XCTAssertEqual(story.imageUrl, "test-image")
        XCTAssertEqual(story.url, "test-url")
        XCTAssertTrue(story.isFavorite)
    }

    func testStoryDecodingWithMissingRequiredField() throws {
        let json = """
        {
            "id": "12345678-1234-1234-1234-123456789012",
            "description": "A test description",
            "author": "Test Author",
            "imageUrl": "test-image",
            "url": "test-url"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try decoder.decode(Story.self, from: json)) { error in
            XCTAssertTrue(error is DecodingError, "Should throw DecodingError")
        }
    }

    func testStoryArrayDecoding() throws {
        let json = """
        [
            {
                "id": "12345678-1234-1234-1234-123456789012",
                "title": "Story 1",
                "description": "Description 1",
                "author": "Author 1",
                "imageUrl": "image1",
                "url": "url1",
                "isFavorite": false
            },
            {
                "id": "87654321-4321-4321-4321-210987654321",
                "title": "Story 2",
                "description": "Description 2",
                "author": "Author 2",
                "imageUrl": "image2",
                "url": "url2",
                "isFavorite": true
            }
        ]
        """.data(using: .utf8)!

        let stories = try decoder.decode([Story].self, from: json)

        XCTAssertEqual(stories.count, 2)
        XCTAssertEqual(stories[0].title, "Story 1")
        XCTAssertFalse(stories[0].isFavorite)
        XCTAssertEqual(stories[1].title, "Story 2")
        XCTAssertTrue(stories[1].isFavorite)
    }

    // MARK: - Round-Trip Tests

    func testStoryEncodingDecodingRoundTrip() throws {
        let originalStory = Story(
            id: UUID(),
            title: "Test Story",
            description: "A test description",
            author: "Test Author",
            imageUrl: "test-image",
            url: "test-url",
            isFavorite: true
        )

        let encodedData = try encoder.encode(originalStory)
        let decodedStory = try decoder.decode(Story.self, from: encodedData)

        XCTAssertEqual(originalStory, decodedStory, "Story should be equal after encoding and decoding")
        XCTAssertEqual(originalStory.id, decodedStory.id)
        XCTAssertEqual(originalStory.title, decodedStory.title)
        XCTAssertEqual(originalStory.description, decodedStory.description)
        XCTAssertEqual(originalStory.author, decodedStory.author)
        XCTAssertEqual(originalStory.imageUrl, decodedStory.imageUrl)
        XCTAssertEqual(originalStory.url, decodedStory.url)
        XCTAssertEqual(originalStory.isFavorite, decodedStory.isFavorite)
    }

    func testStoryArrayRoundTrip() throws {
        let originalStories = [
            Story(title: "Story 1", description: "Desc 1", author: "Author 1", imageUrl: "img1", url: "url1"),
            Story(title: "Story 2", description: "Desc 2", author: "Author 2", imageUrl: "img2", url: "url2", isFavorite: true),
            Story(title: "Story 3", description: "Desc 3", author: "Author 3", imageUrl: "img3", url: "url3")
        ]

        let encodedData = try encoder.encode(originalStories)
        let decodedStories = try decoder.decode([Story].self, from: encodedData)

        XCTAssertEqual(originalStories.count, decodedStories.count)
        for (original, decoded) in zip(originalStories, decodedStories) {
            XCTAssertEqual(original, decoded)
        }
    }
}
