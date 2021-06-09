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
    @State var scan: Scan? = nil
    @State var showingError = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                if showingError {
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom)
                        .padding(.leading)
                        .padding(.trailing)
                    
                    Text("Invalid QR code")
                        .padding(.bottom)
                    
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
                } else {
                    if self.scan == nil {
                        LoadingView()
                    } else {
                        QRResultView(scan: scan!, showingResults: $showingResults)
                    }
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
        guard let result = self.scan else { return }
        SavedScans.shared.scans.append(result)
    }
    
    /// Called when an image is received from ContentView
    /// Uses [CIImage] and [CIDetector] to read from the [UIImage] and returns a string of the QR's contents
    /// If the image is not a valid QR code, or an error occurs, a string containing "error" is returned
    func scanQRCode() {
        guard let ciImage = CIImage(image: self.image!) else {
            self.scan = nil
            self.showingError = true
            return
        }
        
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        
        guard let features = detector?.features(in: ciImage) else {
            self.scan = nil
            self.showingError = true
            return
        }
        
        guard let message = (features.first as? CIQRCodeFeature)?.messageString else {
            self.scan = nil
            self.showingError = true
            return
        }
        
        self.scan = Scan(image: image!.pngData()!, date: Date.now, result: message)
        self.scanned()
    }
}

struct LoadingView : View {
    var body: some View {
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
    }
}
