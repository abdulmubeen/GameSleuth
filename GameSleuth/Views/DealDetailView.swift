//
//  DealDetailView.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//

import SwiftUI

struct DealDetailView: View {
    let deal: Deal
    @ObservedObject var authService = FirebaseAuthService.shared
    @State private var showSavedAnimation = false
    @StateObject private var favoritesService = FirebaseFavoritesService()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: deal.thumb)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding()
                    } else if phase.error != nil {
                        Color.red.frame(height: 200)
                    } else {
                        ProgressView().frame(height: 200)
                    }
                }
                
                Text(deal.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Sale Price")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$\(deal.salePrice)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Normal Price")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$\(deal.normalPrice)")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                
                if let url = URL(string: "https://www.cheapshark.com/redirect?dealID=\(deal.dealID)") {
                    Link("View Deal", destination: url)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                }
                
                Button(action: {
                    if let uid = authService.user?.uid {
                        favoritesService.addFavorite(deal: deal, forUser: uid)
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showSavedAnimation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showSavedAnimation = false
                            }
                        }
                    }
                }) {
                    Text("Save to Favorites")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                if showSavedAnimation {
                    Text("Saved!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .transition(.scale)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Deal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
