//
//  ResultsView.swift
//  QuikCode
//
//  Created by Conor on 08/06/2021.
//

import SwiftUI

struct ResultsView: View {
    @Binding var image: UIImage?
    @Binding var showingResults: Bool
    @State private var result: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                if self.result == nil {
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {}) {
                            Text("Back").frame(maxWidth: 300)
                        }
                        .controlProminence(.increased)
                        .keyboardShortcut(.defaultAction)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .disabled(true)
                    }
                    .padding()
                } else {
                    Image(image: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom)
                        .padding(.leading)
                        .padding(.trailing)
                      
                    if self.result == "Error" {
                        Text("Invalid QR code")
                            .padding(.bottom)
                    } else {
                        Text("Content:\n``\(self.result ?? "None")``")
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
            .task {
                scanQRCode()
            }
            .navigationTitle("Result")
        }
    }
    
    /// Called when the QR code has been scanned
    func scanned() {
        guard let result = self.result else { return }
        guard let image = self.image else { return }
        
        SavedScans.shared.scans.append(Scan(image: image.pngData()!, date: Date.now, result: result))
    }
    
    /// Called when an image is received from ContentView
    /// Uses [CIImage] and [CIDetector] to read from the [UIImage] and returns a string of the QR's contents
    /// If the image is not a valid QR code, or an error occurs, a string containing "error" is returned
    func scanQRCode() {
        guard let ciImage = CIImage(image: self.image!) else {
            self.result = "Error"
            return
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: CIContext(),
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        guard let features = detector?.features(in: ciImage) else {
            self.result = "Error"
            return
        }
        
        self.result = (features.first as? CIQRCodeFeature)?.messageString ?? "Error"
        scanned()
    }
}
