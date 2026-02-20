//
//  LoadingCardView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

import SwiftUI

struct LoadingCardView: View {
    var size: CGSize
    var index: Int
    @State private var animating = false

    var body: some View {
        RoundedRectangle(cornerRadius: Radius.md)
            .fill(Color.gray.opacity(animating ? 0.3 : 0.45))
            .frame(width: size.width, height: size.height)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.75).repeatForever(autoreverses: true).delay(Double(index) * 0.25)) {
                    animating = true
                }
            }
    }
}

#Preview("Horizontal") {
    LoadingCardView(size: StoryCardView.size(for: .horizontal), index: 0)
}

#Preview("Grid") {
    LoadingCardView(size: StoryCardView.size(for: .grid), index: 0)
}
