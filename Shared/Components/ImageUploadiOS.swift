//
//  ImageUploadiOS.swift
//  Supportify (iOS)
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

import UIKit
import SwiftUI

struct ImageUploadView: View {
    var body: some View {
       EmptyView()
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.appData.selectedImage = selectedImage
        let generator = UIImpactFeedbackGenerator()
        generator.prepare()
        generator.impactOccurred(intensity: 0.7)
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}

struct ImagePickerView: UIViewControllerRepresentable {
    @EnvironmentObject var appData: AppData
    //@Binding var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var isPresented
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = appData.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        appData.hasImageBeenSelected = true
        
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

extension View {
    func asUiImage() -> UIImage {
        var uiImage = UIImage(systemName: "exclamationmark.triangle.fill")!
        let controller = UIHostingController(rootView: self)
        
        if let view = controller.view {
            let contentSize = view.intrinsicContentSize
            view.bounds = CGRect(origin: .zero, size: contentSize)
            view.backgroundColor = .clear
            
            let renderer = UIGraphicsImageRenderer(size: contentSize)
            uiImage = renderer.image { _ in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
        }
        return uiImage
    }
}


