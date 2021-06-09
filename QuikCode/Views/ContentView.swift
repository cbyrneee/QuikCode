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
    @State private var showingCamera = false
    @State private var showingActionSheet = false

    @State private var data: Data?
    @State private var selectedImage: UIImage?
    
    @ObservedObject private var savedScans = SavedScans.shared
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Previous scans")) {
                        if (savedScans.scans.isEmpty) {
                            Text("You have not scanned an image yet! Scan it to see the result here.")
                        } else {
                            ForEach(savedScans.scans) { scan in
                                ScanRowView(scan: scan)
                            }
                        }
                    }
                }
                
                VStack {
                    Button(action: {
                        showingActionSheet = true
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
            .background(Color.systemGroupedBackground)
            .navigationTitle("QuikCode")
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Scan new image"),
                    message: Text("Choose where to scan a new image from"),
                    buttons: [
                        .default(Text("Camera"), action: {
                            showingCamera = true
                        }),
                        .default(Text("Photo Library"), action: {
                            showingImagePicker = true
                        }),
                        .cancel()
                    ]
                )
            }
        }
        .sheet(isPresented: self.$showingImagePicker, onDismiss: {
            showingResults = self.selectedImage != nil
        }) {
            ImagePickerView(image: $selectedImage, isPresented: $showingImagePicker)
        }
        .sheet(isPresented: self.$showingCamera, onDismiss: {
            showingResults = self.selectedImage != nil
        }) {
            ImagePickerView(sourceType: .camera, image: $selectedImage, isPresented: $showingCamera)
                .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showingResults, onDismiss: {
            self.selectedImage = nil
        }) {
            ResultsView(image: $selectedImage, showingResults: $showingResults)
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
