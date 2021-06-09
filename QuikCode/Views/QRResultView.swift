//
//  QRResultView.swift
//  QuikCode
//
//  Created by Conor on 09/06/2021.
//

import SwiftUI

struct QRResultView: View {
    var scan: Scan
    @Binding var showingResults: Bool
    
    var body: some View {
        VStack {
            Image(data: self.scan.image)!
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom)
                .padding(.leading)
                .padding(.trailing)
            
             if self.scan.result == "Error" {
                 Text("Invalid QR code")
                     .padding(.bottom)
             } else {
                 Text("Content:\n``\(self.scan.result.isEmpty ? "Empty QR Code" : self.scan.result)``")
                     .contextMenu {
                         Button(action: {
                             UIPasteboard.general.string = self.scan.result
                         }) {
                             Text("Copy to clipboard")
                             Image(systemName: "doc.on.doc")
                         }
                      }
                     .padding(.bottom)
                     .multilineTextAlignment(.center)
             }
            
            Spacer()
            
            VStack {
                Button(action: {
                    showingResults = false
                }) {
                    Text("Back").frame(maxWidth: 300)
                }
                .controlProminence(.increased)
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding()
        }
    }
}
