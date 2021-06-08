//
//  ScanRowView.swift
//  QuikCode
//
//  Created by Conor on 08/06/2021.
//

import SwiftUI

struct ScanRowView: View {
    private let scan: Scan
    
    init(scan: Scan) {
        self.scan = scan
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(image: UIImage(data: scan.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            Text("Scan from \(self.scan.date.getLocaleDateAndTime())")
        }
    }
}
