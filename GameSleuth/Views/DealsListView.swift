//
//  DealsListView.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//


import SwiftUI

struct DealsListView: View {
    @ObservedObject var apiService = APIService.shared
    
    var body: some View {
        NavigationView {
            List(apiService.deals) { deal in
                NavigationLink(destination: DealDetailView(deal: deal)) {
                    HStack {
                        AsyncImage(url: URL(string: deal.thumb)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                Color.red.frame(width: 60, height: 60)
                            } else {
                                ProgressView().frame(width: 60, height: 60)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(deal.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Sale: $\(deal.salePrice)")
                                .font(.subheadline)
                                .foregroundColor(.green)
                            Text("Rating: \(deal.dealRating)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Game Deals")
            .onAppear {
                apiService.fetchDeals()
            }
        }
    }
}
