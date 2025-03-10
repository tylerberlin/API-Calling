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
    @State private var showingAlert = false
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(breed.capitalized)
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                    .padding(.top, 20)

                AsyncImage(url: URL(string: breedImageURL ?? ""))
                    .frame(width: 500, height: 500)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                
                Spacer()
            }
            .padding()
        }
        .task {
            await fetchBreedImage()
        }
        .alert("Failed to load image", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    func fetchBreedImage() async {
        let query = "https://dog.ceo/api/breed/\(breed)/images/random"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(ImageResponse.self, from: data) {
                    breedImageURL = decodedResponse.message
                    return
                }
            }
        }
        showingAlert = true
    }
}
