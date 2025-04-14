//
//  FavoritesView.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @ObservedObject var authService = FirebaseAuthService.shared
    @StateObject var firebaseFavoritesService = FirebaseFavoritesService()
    
    // Core Data fetch request for locally saved favorites
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedDeal.title, ascending: true)],
        animation: .default)
    private var coreFavorites: FetchedResults<SavedDeal>
    
    var body: some View {
        NavigationView {
            Group {
                // If an error occurred fetching from Firebase, fallback to Core Data.
                if firebaseFavoritesService.errorOccurred {
                    VStack {
                        Text("Offline Mode: Using local favorites")
                            .foregroundColor(.secondary)
                            .padding(.top)
                        List {
                            ForEach(coreFavorites) { savedDeal in
                                HStack {
                                    if let urlString = savedDeal.thumb,
                                       let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            if let image = phase.image {
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(8)
                                                    .shadow(radius: 5)
                                            } else if phase.error != nil {
                                                Color.red.frame(width: 60, height: 60)
                                            } else {
                                                ProgressView().frame(width: 60, height: 60)
                                            }
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        Text(savedDeal.title ?? "Unknown")
                                            .font(.headline)
                                        Text("Sale: \(savedDeal.salePrice ?? "$0.00")")
                                            .foregroundColor(.green)
                                            .font(.subheadline)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                            .onDelete(perform: deleteLocalFavorites)
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    // If no Firebase error, show favorites from Firebase.
                    List {
                        ForEach(firebaseFavoritesService.favorites) { favorite in
                            HStack {
                                AsyncImage(url: URL(string: favorite.thumb)) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                            .shadow(radius: 5)
                                    } else if phase.error != nil {
                                        Color.red.frame(width: 60, height: 60)
                                    } else {
                                        ProgressView().frame(width: 60, height: 60)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(favorite.title)
                                        .font(.headline)
                                    Text("Sale: $\(favorite.salePrice)")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        if let uid = authService.user?.uid {
                            firebaseFavoritesService.fetchFavorites(forUser: uid)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                EditButton()
            }
        }
    }
    
    // Delete local favorites in Core Data.
    private func deleteLocalFavorites(offsets: IndexSet) {
        withAnimation {
            offsets.map { coreFavorites[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting local favorite: \(error.localizedDescription)")
            }
        }
    }
}
