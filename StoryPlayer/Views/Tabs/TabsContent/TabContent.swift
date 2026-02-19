//
//  TabContent.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

import SwiftUI

struct TabContent<Content: View>: View {
    var topColor: Color
    var headerImageSystemName: String
    var headerTitle: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.contentBackground
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: headerImageSystemName)
                        Text(headerTitle)
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.lg)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.headerBackgroundColor)
                    content()
                    Spacer()
                }

                VStack {
                    topColor
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 0)
                    Spacer()
                }
            }
        }
        .background(.clear)
    }
}

#Preview {
    TabContent(topColor: Color.theme.palette1, headerImageSystemName: "book.pages", headerTitle: "Hello") {
        Text("Hello World").padding()
    }
}
