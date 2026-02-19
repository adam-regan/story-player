//
//  SettingsView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("colorTheme") private var isDarkMode = false
    var body: some View {
        TabContent(topColor: Color.theme.palette6, headerImageSystemName: "gear", headerTitle: "Settings") {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding(Spacing.lg)
        }
    }
}

#Preview {
    SettingsView()
}
