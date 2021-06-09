//
//  ScanRowView.swift
//  QuikCode
//
//  Created by Conor on 08/06/2021.
//

import SwiftUI

struct ScanRowView: View {
    @State private var showingSheet = false
    var scan: Scan
    
    var body: some View {
        HStack(spacing: 12) {
            Image(image: UIImage(data: scan.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            Text("Scan from \(self.scan.date.getLocaleDateAndTime())")
        }
        .onTapGesture {
            self.showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            NavigationView {
                QRResultView(scan: scan, showingResults: $showingSheet)
                .navigationTitle("Scan from \(self.scan.date.getLocaleDateAndTime())")
            }
        }
    }
}
