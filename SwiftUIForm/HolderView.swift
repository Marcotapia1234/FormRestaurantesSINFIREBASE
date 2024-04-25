//
//  HolderView.swift
//  SwiftUIForm
//
//  Created by Marco on 25/4/24.
//

import SwiftUI

struct HolderView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    
    var body: some View {
        
        Group {
        if authModel.user == nil {
            SingUpView()
        } else {
            let almacenInicial = SettingStore()
            // Crear una instancia de RestaurantViewModel y pasarle el almacen
            let viewModel = RestaurantViewModel(almacen: SettingStore())
            ContentView(viewModel: viewModel).environmentObject(almacenInicial)
        }
        }
        .onAppear {
            authModel.listenToAuthState()
        }
        
    }
}

struct HolderView_Previews: PreviewProvider {
    static var previews: some View {
        HolderView()
    }
}
