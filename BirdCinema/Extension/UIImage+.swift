//
//  UIImage+.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/25.
//

import Foundation
import UIKit

extension UIImage {
    func applyBlurEffect() -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        let beginImage = CIImage(image: self)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(30, forKey: kCIInputRadiusKey)

        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: output.extent) else { return nil }

        let processedImage = UIImage(cgImage: cgimg)
        return processedImage
    }
}
