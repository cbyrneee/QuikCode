//
//  QuikCode+Date.swift
//  QuikCode
//
//  Created by Conor on 08/06/2021.
//

import Foundation

extension Date {
    func getLocaleDateAndTime() -> String {
         let formatter = DateFormatter()
         formatter.locale = Locale.current
         formatter.dateStyle = .medium
         formatter.timeStyle = .medium
        
         return formatter.string(from: self)
     }
}

