//
//  StoryDetailView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var story: Story

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .tint(.black)
                    .onTapGesture { dismiss() }
                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.md)
            .background(Color.theme.pallete4)
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        Color.theme.pallete4
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                        Image(story.imageUrl)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .clipped()
                            .cornerRadius(Radius.md)
                    }
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(story.title)
                                    .font(.title)
                                    .bold()
                                    .padding(.bottom, Spacing.xs)
                                Text("By \(story.author)")
                                    .font(.body)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        StoryDetailView(story: Story.testData[0])
    }
}
