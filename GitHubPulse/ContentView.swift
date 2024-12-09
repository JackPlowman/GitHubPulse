//
//  ContentView.swift
//  GitHubPulse
//
//  Created by Jack Plowman on 09/12/2024.
//

import SwiftUI

struct RSSFeedView: View {
    @State private var feedItems: [String] = ["Item 1", "Item 2", "Item 3"]

    var body: some View {
        NavigationView {
            List(feedItems, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("GitHub Pulse")
        }
    }
}

#Preview {
    RSSFeedView()
}
