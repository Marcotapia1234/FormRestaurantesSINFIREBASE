//
//  Application_utility.swift
//  SwiftUIForm
//
//  Created by Marco on 2/5/24.
//

import Foundation
import SwiftUI
import UIKit

final class Application_utility{
    
    static var rootViewController:UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
}
