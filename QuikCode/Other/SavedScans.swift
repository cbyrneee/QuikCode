//
//  ScanController.swift
//  QuikCode
//
//  Created by Conor on 08/06/2021.
//

import Foundation
import Combine

class SavedScans : ObservableObject {
    static let shared = SavedScans()

    @Published var scans = [Scan]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(scans) {
                UserDefaults.standard.set(encoded, forKey: "scans")
            } else {
                print("Failed to encode \(scans)")
            }
        }
    }
    
    init() {
        if let scans = UserDefaults.standard.data(forKey: "scans") {
            if let decoded = try? JSONDecoder().decode([Scan].self, from: scans) {
                self.scans = decoded
                return
            }
        } else {
            print("Key scans not in userdefaults")
        }

        self.scans = []
    }
}
