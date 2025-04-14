//
//  FirebaseFavoritesService.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//

import SwiftUI
import FirebaseFirestore

struct Favorite: Identifiable, Codable {
    @DocumentID var id: String?
    var dealID: String
    var title: String
    var salePrice: String
    var thumb: String
}

class FirebaseFavoritesService: ObservableObject {
    @Published var favorites: [Favorite] = []
    @Published var errorOccurred: Bool = false
    private var db = Firestore.firestore()
    
    func fetchFavorites(forUser uid: String) {
        db.collection("users").document(uid).collection("favorites")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching favorites: \(error.localizedDescription)")
                    self.errorOccurred = true
                    return
                }
                self.errorOccurred = false  // Reset error flag when successful
                self.favorites = snapshot?.documents.compactMap { document in
                    try? document.data(as: Favorite.self)
                } ?? []
            }
    }
    
    func addFavorite(deal: Deal, forUser uid: String) {
        let favorite = Favorite(dealID: deal.dealID, title: deal.title, salePrice: deal.salePrice, thumb: deal.thumb)
        do {
            _ = try db.collection("users").document(uid).collection("favorites").addDocument(from: favorite)
        } catch {
            print("Error adding favorite: \(error.localizedDescription)")
        }
    }
    
    func removeFavorite(favoriteID: String, forUser uid: String) {
        db.collection("users").document(uid).collection("favorites").document(favoriteID).delete { error in
            if let error = error {
                print("Error removing favorite: \(error.localizedDescription)")
            }
        }
    }
}
