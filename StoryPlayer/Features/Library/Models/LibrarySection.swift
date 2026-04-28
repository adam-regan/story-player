//
//  LibrarySection.swift
//  StoryPlayer
//
//  Created by Adam Regan on 28/04/2026.
//
import Foundation

struct LibrarySection: Identifiable {
    let id = UUID()
    let title: String
    let filter: LibraryFilter
    let listType: StoryListType
}
