//
//  ContentView.swift
//  API Calling
//
//  Created by Tyler Berlin on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var breeds: [String] = []
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3), .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                List(breeds, id: \ .self) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)) {
                        HStack {
                            Image(systemName: "pawprint.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text(breed.capitalized)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.8)).shadow(radius: 2))
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Dog Breeds")
            }
            .task {
                await fetchBreeds()
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Loading Error"), message: Text("There was a problem loading the Dog Breeds"))
            })
        }
    }
    func fetchBreeds() async {
        let query = "https://dog.ceo/api/breeds/list/all"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(BreedResponse.self, from: data) {
                    breeds = decodedResponse.message.keys.sorted()
                    return
                }
            }
        }
        showingAlert = true
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
