//
//  ContentView.swift
//  API Calling
//
//  Created by Tyler Berlin on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var recipes = [Recipe]()
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                NavigationLink(recipe.title) {
                    VStack {
                        Text(recipe.title).font(.title).padding()
                        if let imageUrl = recipe.image {
                            AsyncImage(url: URL(string: imageUrl))
                                .scaledToFit()
                                .frame(height: 200)
                                .padding()
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await loadData()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Loading Error"), message: Text("There was a problem loading the recipes."))
            }
        }
    }

    func loadData() async {
        let query = "https://api.spoonacular.com/recipes/complexSearch?apiKey=3939d6a64e164fa591ca7873112ce119&number=10"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(RecipeResponse.self, from: data) {
                    recipes = decodedResponse.results
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

struct Recipe: Identifiable, Codable {
    var id: Int
    var title: String
    var image: String?
}

struct RecipeResponse: Codable {
    var results: [Recipe]
}
