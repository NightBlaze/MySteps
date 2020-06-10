//
//  UIImage+Rounded.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 10.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

extension UIImage {
    // I use clip of image just to avoid offscreen rendering.
    // We can skip this and just use imageView.layer.cornerRadius = imageView.bounds.size.width / 2
    // Also we can improve this method and create rounded image on background queue
    // but it requires changing in UI and showing a placeholder while we are modifying the image
    static func roundedImage(named: String) -> UIImage? {
        let roundedImageFileURL = self.roundedImageFileName(for: named)
        var roundedImage = UIImage(contentsOfFile: roundedImageFileURL.path)
        if roundedImage != nil {
            return roundedImage
        }

        let squareImage = UIImage(named: named)
        roundedImage = makeRoundedImage(image: squareImage)
        if roundedImage != nil {
            saveRoundedImage(roundedImage!, to: roundedImageFileURL)
        }
        return roundedImage
    }
}

// MARK: - Private

private extension UIImage {
    static func roundedImageFileName(for imageName: String) -> URL {
        return FileManager.cachesDirectory().appendingPathComponent(imageName + "_rounded", isDirectory: false)
    }

    static func makeRoundedImage(image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }

        UIGraphicsBeginImageContextWithOptions(image.size, true, UIScreen.main.scale);
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIBezierPath(roundedRect: rect, cornerRadius: image.size.width / 2).addClip()
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }

    static func saveRoundedImage(_ image: UIImage, to: URL) {
        if let imageData = image.pngData() {
            try? imageData.write(to: to)
        }
    }
}
