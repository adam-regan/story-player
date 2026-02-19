//
//  LibraryView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct LibraryView: View {
    @StateObject var viewModel = StoriesViewModel()
    var body: some View {
        TabContent(topColor: Color.theme.palette1, headerImageSystemName: "book.pages", headerTitle: "Library") {
            ScrollView {
                StoryListView()
                StoryListView()
                StoryListView()
                StoryListView()
                StoryListView()
                StoryListView()
                StoryListView()
                StoryListView()
                StoryListView()
                Spacer()
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    LibraryView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
