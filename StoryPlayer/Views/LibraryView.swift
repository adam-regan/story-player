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
        VStack {
            StoryListView()
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    LibraryView()
}
