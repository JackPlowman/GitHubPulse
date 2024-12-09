//
//  ContentView.swift
//  GitHubPulse
//
//  Created by Jack Plowman on 09/12/2024.
//

import SwiftUI
import Foundation

class RSSFeedViewModel: ObservableObject {
    @Published var feedItems: [String] = []

    func fetchFeed() {
        guard let url = URL(string: "https://github.blog/changelog/feed/") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return
            }

            if let data = data {
                let parser = XMLParser(data: data)
                let rssParserDelegate = RSSParserDelegate()
                parser.delegate = rssParserDelegate

                if parser.parse() {
                    DispatchQueue.main.async {
                        self.feedItems = rssParserDelegate.items
                    }
                }
            }
        }.resume()
    }
}

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var items: [String] = []
    private var currentElement = ""
    private var currentTitle = ""

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "title" {
            currentTitle += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(currentTitle)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        // Error handling can be implemented here if needed
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        // Error handling can be implemented here if needed
    }
}

struct RSSFeedView: View {
    @ObservedObject var viewModel: RSSFeedViewModel

    var body: some View {
        NavigationView {
            List(viewModel.feedItems, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("GitHub Pulse")
            .onAppear {
                viewModel.fetchFeed()
            }
        }
    }
}

#Preview {
    RSSFeedView(viewModel: RSSFeedViewModel())
}
