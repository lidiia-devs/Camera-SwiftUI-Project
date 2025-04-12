//
//  CameraImageView.swift
//  Camera SwiftUI Project
//
//  Created by Lidiia Diachkovskaia on 4/10/25.
//

import SwiftUI
import SwiftData


struct CameraImageView: View {
    
    @State private var showImagePicker = false
    @State private var useCamera = false
    @State private var selectedImage: UIImage?
    
    @Environment(\.modelContext) private var context
    @Query var savedImages: [StoredImage]
    
    //Alert management
    @State private var showPermissionAlert = false
    @State private var alertMessage = ""
    @State private var showSettingsutton = false
    
    var body: some View {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                }

                HStack {
                    Button("Take Photo", systemImage: "camera.fill") {
                        //launch permission Checker
                        PermissionManager.checkPermission(for: .camera) { granted in
                            if granted {
                                useCamera = true
                                showImagePicker = true
                            } else {
                                alertMessage = "Camera access is required to take photos"
                                showSettingsutton = true
                                showPermissionAlert = true
                            }
                        }
                    } .foregroundColor(.black)

                    Button("Upload from Library") {
                        PermissionManager.checkPermission(for: .photoLibrary) { granted in
                            if granted {
                                useCamera = false
                                showImagePicker = true
                            } else {
                                alertMessage = "Photo library access is required to upload photos"
                                showSettingsutton = true
                                showPermissionAlert = true
                            }
                        }
                    }
                }

                if selectedImage != nil {
                    Button("Save to SwiftData") { //Important: when storing photos to swift data, must turn image into data first
                        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                            let newImage = StoredImage(imageData: imageData)
                            context.insert(newImage)
                            try? context.save()
                        }
                    }
                }

                Divider().padding()

                ScrollView {
                    ForEach(savedImages) { imageEntry in
                        if let uiImage = UIImage(data: imageEntry.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .padding(.bottom, 10)
                        }
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: useCamera ? .camera : .photoLibrary, selectedImage: $selectedImage)
            }
            .padding()
            .alert("Permission Required", isPresented: $showPermissionAlert) {
                if showSettingsutton {
                    Button("Open Settings") {
                        PermissionManager.openAppSettings()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
}

#Preview {
    CameraImageView()
        .modelContainer(for: StoredImage.self) // for SwiftData
}
