//
//  GameSleuthApp.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//

import SwiftUI
import FirebaseCore
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
  }
}

@main
struct GameSleuthApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authService = FirebaseAuthService.shared
    let persistenceController = PersistenceController.shared

        var body: some Scene {
            WindowGroup {
                if authService.user == nil {
                    // Show the modern AuthView if no user is logged in.
                    AuthView()
                } else {
                    // Main TabView with four tabs: Deals, Search, Favorites, Profile.
                    TabView {
                        DealsListView()
                            .tabItem {
                                Label("Deals", systemImage: "list.bullet")
                            }
                        
                        SearchView()
                            .tabItem {
                                Label("Search", systemImage: "magnifyingglass")
                            }
                        
                        FavoritesView()
                            .tabItem {
                                Label("Favorites", systemImage: "star.fill")
                            }
                        
                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle")
                            }
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
}
