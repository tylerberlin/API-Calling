//
//  ContentView.swift
//  API Calling
//
//  Created by Tyler Berlin on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var competitions = [Competition]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(competitions) { competition in
                NavigationLink(competition.name) {
                    VStack {
                        Text(competition.name).font(.title).padding()
                        Text("Area").font(.caption)
                        Text(competition.area.name)
                        if let url = competition.emblem {
                            AsyncImage(url: URL(string: url)).padding()
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Football Competitions")
            .task {
                await loadData()
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Loading Error"), message: Text("There was a problem loading the Football Competitions"))
            })
        }
    }

    func loadData() async {
        let query = "https://api.football-data.org/v4/competitions"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Competitions.self, from: data) {
                    competitions = decodedResponse.competitions
                    return
                }
            }
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}

struct Area: Codable {
    var name: String
    var flag: String?
}

struct Competition: Identifiable, Codable {
    var id: Int
    var name: String
    var emblem: String?
    var area: Area
}

struct Competitions: Codable {
    var competitions: [Competition]
}
