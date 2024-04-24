//
//  RestaurantViewModel.swift
//  SwiftUIForm
//

//

import SwiftUI
import Foundation
import FirebaseFirestore

class RestaurantViewModel: ObservableObject {
    
    @Published var restaurants: [Restaurant] = []
    @Published var selectedRestaurant: Restaurant?
    @Published var showSettings: Bool = false
    @Published var restaurantsDB: [Restaurant] = []

    @ObservedObject var almacen: SettingStore
    
    var databaseReference = Firestore.firestore().collection("restaurantes")
    
   
    init(almacen: SettingStore) {
        
        self.almacen = almacen
        checkIfDatabaseIsEmpty()
        
        // Initializamos los restaurantes
        self.restaurants = [
            Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", phone: "232-923423", image: "cafedeadend", priceLevel: 3),
            Restaurant(name: "Homei", type: "Cafe", phone: "348-233423", image: "homei", priceLevel: 3),
            Restaurant(name: "Teakha", type: "Tea House", phone: "354-243523", image: "teakha", priceLevel: 3, isFavorite: true, isCheckIn: true),
            Restaurant(name: "Cafe loisl", type: "Austrian / Casual Drink", phone: "453-333423", image: "cafeloisl", priceLevel: 2, isFavorite: true, isCheckIn: true),
            Restaurant(name: "Petite Oyster", type: "French", phone: "983-284334", image: "petiteoyster", priceLevel: 5, isCheckIn: true),
            Restaurant(name: "For Kee Restaurant", type: "Hong Kong", phone: "232-434222", image: "forkeerestaurant", priceLevel: 2, isFavorite: true, isCheckIn: true),
            Restaurant(name: "Po's Atelier", type: "Bakery", phone: "234-834322", image: "posatelier", priceLevel: 4),
            Restaurant(name: "Bourke Street Backery", type: "Chocolate", phone: "982-434343", image: "bourkestreetbakery", priceLevel: 4, isCheckIn: true),
            Restaurant(name: "Haigh's Chocolate", type: "Cafe", phone: "734-232323", image: "haighschocolate", priceLevel: 3, isFavorite: true),
            Restaurant(name: "Palomino Espresso", type: "American / Seafood", phone: "872-734343", image: "palominoespresso", priceLevel: 2),
            Restaurant(name: "Upstate", type: "Seafood", phone: "343-233221", image: "upstate", priceLevel: 4),
            Restaurant(name: "Traif", type: "American", phone: "985-723623", image: "traif", priceLevel: 5),
            Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", phone: "455-232345", image: "grahamavenuemeats", priceLevel: 3),
            Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", phone: "434-232322", image: "wafflewolf", priceLevel: 3),
            Restaurant(name: "Five Leaves", type: "Bistro", phone: "343-234553", image: "fiveleaves", priceLevel: 4, isFavorite: true, isCheckIn: true),
            Restaurant(name: "Cafe Lore", type: "Latin American", phone: "342-455433", image: "cafelore", priceLevel: 2, isFavorite: true, isCheckIn: true),
            Restaurant(name: "Confessional", type: "Spanish", phone: "643-332323", image: "confessional", priceLevel: 4),
            Restaurant(name: "Barrafina", type: "Spanish", phone: "542-343434", image: "barrafina", priceLevel: 2, isCheckIn: true),
            Restaurant(name: "Donostia", type: "Spanish", phone: "722-232323", image: "donostia", priceLevel: 1),
            Restaurant(name: "Royal Oak", type: "British", phone: "343-988834", image: "royaloak", priceLevel: 2, isFavorite: true),
            Restaurant(name: "CASK Pub and Kitchen", type: "Thai", phone: "432-344050", image: "caskpubkitchen", priceLevel: 1)
            ]
    }
    
    func checkIfDatabaseIsEmpty(){
        databaseReference.getDocuments { QuerySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let documents = QuerySnapshot?.documents else {
                print("No documents found")
                return
            }
            if documents.isEmpty {
                self.addInitialRestaurants()
            }else {
                print("La colección no está vacía, no se agregarán elementos")
            }
        }
    }
    func addInitialRestaurants() {
        for restaurant in restaurants {
            self.addRestaurant(restaurant: restaurant)
            }
        }
        
    func fetchRestaurants() {
        databaseReference.getDocuments { querySnapshot, error in
            if let error = error { print(error)
                return
            }
            guard let documents = querySnapshot?.documents else {
                return
            }
            if documents.isEmpty {
                
            } else {
                self.restaurantsDB = documents.compactMap {document in
                    do {
                        let restaurant = try document.data(as: Restaurant.self)
                        return restaurant
                    }catch {
                        return nil
                    }
                    }
                }
        }
    }
    func addRestaurant(restaurant: Restaurant){
        do{
        _ = try databaseReference.addDocument(from: restaurant)
        } catch {
            print("Erro adding restaurant: \(error.localizedDescription)")
        }
    }

    func deleteRestaurant(restaurant: Restaurant) {
        if let restaurantID = restaurant.id {
            databaseReference.document(restaurantID).delete { error in if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
        
    }

    func toggleFavorite(restaurant: Restaurant) {
        if let restaurantID = restaurant.id {
            databaseReference.document(restaurantID).updateData(
                ["isFavorite": !restaurant.isFavorite])
        }
        
        
    }

    func toggleCheckIn(restaurant: Restaurant) {
        if let restaurantID = restaurant.id {
            databaseReference.document(restaurantID).updateData(["isCheckIn": !restaurant.isCheckIn])
        }
        
    }

    func shouldShowItem(restaurant: Restaurant) -> Bool {
        return (!self.almacen.showCheckInOnly || restaurant.isCheckIn) && (restaurant.priceLevel <= self.almacen.maxPriceLevel)
    }
}
