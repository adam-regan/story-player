//
//  StoryTests.swift
//  StoryTests
//
//  Created by Adam Regan on 23/02/2026.
//

import Foundation
@testable import StoryPlayer
import Testing

@Suite("Story Model Tests")
@MainActor
struct StoryTests {
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    // MARK: - Encoding Tests
    
    @Test("Story encoding produces valid JSON with all fields")
    func storyEncoding() throws {
        // Given
        let story = try Story(
            id: #require(UUID(uuidString: "12345678-1234-1234-1234-123456789012")),
            title: "Test Story",
            description: "A test description",
            author: "Test Author",
            imageUrl: "test-image",
            url: "test-url",
            isFavorite: true
        )
        
        // When
        let data = try encoder.encode(story)
        
        // Then
        #expect(!data.isEmpty, "Encoded data should not be empty")
        
        let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        #expect(json["title"] as? String == "Test Story")
        #expect(json["description"] as? String == "A test description")
        #expect(json["author"] as? String == "Test Author")
        #expect(json["imageUrl"] as? String == "test-image")
        #expect(json["url"] as? String == "test-url")
        #expect(json["isFavorite"] as? Bool == true)
    }
    
    @Test("Story encoding with default values generates ID and sets isFavorite to false")
    func storyEncodingWithDefaultValues() throws {
        // Given
        let story = Story(
            title: "Test Story",
            description: "A test description",
            author: "Test Author",
            imageUrl: "test-image",
            url: "test-url"
        )
        
        // When
        let data = try encoder.encode(story)
        
        // Then
        let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        #expect(json["isFavorite"] as? Bool == false, "Default isFavorite should be false")
        #expect(json["id"] != nil, "ID should be generated")
    }
    
    @Test("Story array encoding produces valid JSON array")
    func storyArrayEncoding() throws {
        // Given
        let stories = [
            Story(title: "Story 1", description: "Description 1", author: "Author 1", imageUrl: "image1", url: "url1"),
            Story(title: "Story 2", description: "Description 2", author: "Author 2", imageUrl: "image2", url: "url2", isFavorite: true)
        ]
        
        // When
        let data = try encoder.encode(stories)
        
        // Then
        #expect(!data.isEmpty)
        let jsonArray = try #require(JSONSerialization.jsonObject(with: data) as? [[String: Any]])
        #expect(jsonArray.count == 2)
    }
    
    // MARK: - Decoding Tests
    
    @Test("Story decoding from valid JSON succeeds")
    func storyDecoding() throws {
        // Given
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
        
        // When
        let story = try decoder.decode(Story.self, from: json)
        
        // Then
        #expect(story.id.uuidString.uppercased() == "12345678-1234-1234-1234-123456789012")
        #expect(story.title == "Test Story")
        #expect(story.description == "A test description")
        #expect(story.author == "Test Author")
        #expect(story.imageUrl == "test-image")
        #expect(story.url == "test-url")
        #expect(story.isFavorite == true)
    }
    
    @Test("Story decoding with missing required field throws error")
    func storyDecodingWithMissingRequiredField() throws {
        // Given
        let json = """
        {
            "id": "12345678-1234-1234-1234-123456789012",
            "description": "A test description",
            "author": "Test Author",
            "imageUrl": "test-image",
            "url": "test-url"
        }
        """.data(using: .utf8)!
        
        // When/Then
        #expect(throws: DecodingError.self) {
            try decoder.decode(Story.self, from: json)
        }
    }
    
    @Test("Story array decoding from valid JSON succeeds")
    func storyArrayDecoding() throws {
        // Given
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
        
        // When
        let stories = try decoder.decode([Story].self, from: json)
        
        // Then
        #expect(stories.count == 2)
        #expect(stories[0].title == "Story 1")
        #expect(stories[0].isFavorite == false)
        #expect(stories[1].title == "Story 2")
        #expect(stories[1].isFavorite == true)
    }
    
    // MARK: - Round-Trip Tests
    
    @Test("Story encoding and decoding round trip preserves all data")
    func storyEncodingDecodingRoundTrip() throws {
        // Given
        let originalStory = Story(
            id: UUID(),
            title: "Test Story",
            description: "A test description",
            author: "Test Author",
            imageUrl: "test-image",
            url: "test-url",
            isFavorite: true
        )
        
        // When
        let encodedData = try encoder.encode(originalStory)
        let decodedStory = try decoder.decode(Story.self, from: encodedData)
        
        // Then
        #expect(originalStory == decodedStory, "Story should be equal after encoding and decoding")
        #expect(originalStory.id == decodedStory.id)
        #expect(originalStory.title == decodedStory.title)
        #expect(originalStory.description == decodedStory.description)
        #expect(originalStory.author == decodedStory.author)
        #expect(originalStory.imageUrl == decodedStory.imageUrl)
        #expect(originalStory.url == decodedStory.url)
        #expect(originalStory.isFavorite == decodedStory.isFavorite)
    }
    
    @Test("Story array encoding and decoding round trip preserves all stories")
    func storyArrayRoundTrip() throws {
        // Given
        let originalStories = [
            Story(title: "Story 1", description: "Desc 1", author: "Author 1", imageUrl: "img1", url: "url1"),
            Story(title: "Story 2", description: "Desc 2", author: "Author 2", imageUrl: "img2", url: "url2", isFavorite: true),
            Story(title: "Story 3", description: "Desc 3", author: "Author 3", imageUrl: "img3", url: "url3")
        ]
        
        // When
        let encodedData = try encoder.encode(originalStories)
        let decodedStories = try decoder.decode([Story].self, from: encodedData)
        
        // Then
        #expect(originalStories.count == decodedStories.count)
        for (original, decoded) in zip(originalStories, decodedStories) {
            #expect(original == decoded)
        }
    }
}
