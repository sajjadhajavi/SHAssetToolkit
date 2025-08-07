//
//  CameraPicker.swift
//  SHAssetToolkit
//
//  Created by Sajjad Hajavi on 8/7/25.
//


import UIKit
import SwiftUI

public struct SHCameraPickerView: UIViewControllerRepresentable {
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        private let parent: SHCameraPickerView

        init(parent: SHCameraPickerView) {
            self.parent = parent
        }

        public func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let mediaType = info[.mediaType] as? String {
                if mediaType == "public.image",
                   let image = info[.originalImage] as? UIImage {

                    // Save to temporary directory
                    if let imageData = image.jpegData(compressionQuality: 0.9) {
                        let tempDir = FileManager.default.temporaryDirectory
                        let fileName = UUID().uuidString + ".jpg"
                        let fileURL = tempDir.appendingPathComponent(fileName)

                        do {
                            try imageData.write(to: fileURL)
                            parent.onAssetPicked?(fileURL) // You now have the image URL
                        } catch {
                            print("Failed to write image to disk: \(error)")
                        }
                    }
                } else if mediaType == "public.movie",
                          let videoURL = info[.mediaURL] as? URL {
                    parent.onAssetPicked?(videoURL)
                }
            }
        }


        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }

    @Environment(\.dismiss) private var dismiss

    public var onAssetPicked: ((URL) -> Void)?

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.videoQuality = .typeHigh
        picker.allowsEditing = false
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
