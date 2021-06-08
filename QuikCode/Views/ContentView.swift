//
//  ContentView.swift
//  QuikCode
//
//  Created by Conor on 08/06/2021.
//

import SwiftUI
import SwiftUIX

struct ContentView: View {
    @State private var showingImagePicker = false
    @State private var showingResults = false
    @State private var data: Data?
    @State private var selectedImage: UIImage?
    @ObservedObject private var savedScans = SavedScans.shared
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if (savedScans.scans.isEmpty) {
                        Text("You have not scanned an image yet! Scan it to see the result here.")
                    } else {
                        ForEach(savedScans.scans) { scan in
                            ScanRowView(scan: scan)
                        }
                    }
                }
                
                VStack {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Scan new image").frame(maxWidth: 300)
                    }
                    .controlProminence(.increased)
                    .keyboardShortcut(.defaultAction)
                    
                    Button(action: clear) {
                        Text("Clear previous scans").frame(maxWidth: 300)
                    }
                    .tint(.accentColor)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding()
            }
            .sheet(isPresented: $showingResults) {
                ResultsView(image: $selectedImage, showingResults: $showingResults)
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: {
                showingResults = true
            }) {
                ImagePicker(image: $selectedImage)
            }
            .background(Color.systemGroupedBackground)
            .navigationTitle("QuikCode")
        }
    }
    
    func clear() {
        SavedScans.shared.scans = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
