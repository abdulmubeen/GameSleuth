//
//  APIService.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//

import Foundation
import Combine

struct Deal: Codable, Identifiable {
    var id: String { dealID }
    let internalName: String
    let title: String
    let dealID: String
    let storeID: String
    let salePrice: String
    let normalPrice: String
    let dealRating: String
    let thumb: String
}


struct Game: Codable, Identifiable {
    var id: String { gameID }
    let gameID: String
    let steamAppID: String?
    let cheapest: String
    let cheapestDealID: String
    let external: String
    let internalName: String
    let thumb: String
}

class APIService: ObservableObject {
    @Published var deals: [Deal] = []
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = APIService()
    
    private init() { }
    
    func fetchDeals(storeID: String = "1", upperPrice: String = "15") {
        guard let url = URL(string: "https://www.cheapshark.com/api/1.0/deals?storeID=\(storeID)&upperPrice=\(upperPrice)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Deal].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("API call error: \(error)")
                }
            } receiveValue: { [weak self] deals in
                self?.deals = deals
            }
            .store(in: &cancellables)
    }
    
    func searchGames(withTitle title: String, completion: @escaping (Result<[Game], Error>) -> Void) {
            guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://www.cheapshark.com/api/1.0/games?title=\(encodedTitle)") else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(URLError(.badServerResponse))) }
                    return
                }
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    DispatchQueue.main.async { completion(.success(games)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
        }
}

