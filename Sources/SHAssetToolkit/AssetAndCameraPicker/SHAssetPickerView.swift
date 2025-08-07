//
//  AssetPicker.swift
//  SHAssetToolkit
//
//  Created by Sajjad Hajavi on 8/7/25.
//

import PhotosUI
import SwiftUI

struct SHAssetPickerView: UIViewControllerRepresentable {
    var selectionLimit: Int = 0
    var onPick: ([PHAsset]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = selectionLimit // 0 means no limit
        config.filter = .any(of: [.images, .videos])

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: SHAssetPickerView

        init(_ parent: SHAssetPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                picker.dismiss(animated: true)
            }

            // Get all asset identifiers
            let assetIDs = results.compactMap { $0.assetIdentifier }

            guard !assetIDs.isEmpty else {
                parent.onPick([])
                return
            }

            // Fetch assets using identifiers
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIDs, options: nil)
            var assets: [PHAsset] = []
            fetchResult.enumerateObjects { asset, _, _ in
                assets.append(asset)
            }

            parent.onPick(assets)
        }
        
    }
}
