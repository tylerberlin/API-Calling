//
//  BreedDetailView.swift
//  API Calling
//
//  Created by Tyler Berlin on 3/6/25.
//

import SwiftUI

struct BreedDetailView: View {
    let breed: String
    @State private var breedImageURL: String?
    
    var body: some View {
        ZStack {
            VStack {
                Text(breed.capitalized)
                    .font(.largeTitle.bold())
                    .padding()
                
                AsyncImage(url: URL(string: breedImageURL ?? ""))
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Spacer()
            }
        }
        .onAppear(perform: fetchBreedImage)
    }
    
    func fetchBreedImage() {
        URLSession.shared.dataTask(with: URL(string: "https://dog.ceo/api/breed/\(breed)/images/random")!) { data, _, _ in
            if let data = data, let response = try? JSONDecoder().decode(ImageResponse.self, from: data) {
                DispatchQueue.main.async {
                    breedImageURL = response.message
                }
            }
        }.resume()
    }
}
