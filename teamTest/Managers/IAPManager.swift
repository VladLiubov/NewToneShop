//
//  IAPManager.swift
//  teamTest
//
//  Created by Admin on 16.12.2021.
//

import Foundation
//import Purchases
import UIKit

final class IAPManager {
    static let shared = IAPManager()
    
    private init () {}
    
    func isPremium () {
        
    }
    
    func subscribe () {
        
    }
    
    func restorePurchases() {
        
    }
    
}

class HapticsManager {
    
    static let shared = HapticsManager()

    private init() {}

    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
