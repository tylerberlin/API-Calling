//
//  ContentView.swift
//  API Calling
//
//  Created by Tyler Berlin on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var breeds: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                List(breeds, id: \ .self) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)) {
                        Text(breed.capitalized)
                    }
                }
                .navigationTitle("Dog Breeds")
            }
        }
        .onAppear(perform: fetchBreeds)
    }
    
    func fetchBreeds() {
        URLSession.shared.dataTask(with: URL(string: "https://dog.ceo/api/breeds/list/all")!) { data, _, _ in
            if let data = data, let response = try? JSONDecoder().decode(BreedResponse.self, from: data) {
                DispatchQueue.main.async {
                    breeds = response.message.keys.sorted()
                }
            }
        }.resume()
    }
}

struct BreedResponse: Codable {
    let message: [String: [String]]
}

struct ImageResponse: Codable {
    let message: String
}

#Preview {
    ContentView()
}
