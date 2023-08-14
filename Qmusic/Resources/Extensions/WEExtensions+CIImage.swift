//
//  WEExtensions+CIImage.swift
//  FEMobile
//
//  Created by Anh Thi on 1/20/21.
//

import Foundation
import UIKit

extension CIImage {

    // Convert CIImage to UIImage
    
       public func convertCIImageToUIImage() -> UIImage {
           let context:CIContext = CIContext.init(options: nil)
           let cgImage:CGImage = context.createCGImage(self, from: self.extent)!
           let image:UIImage = UIImage.init(cgImage: cgImage)
           return image
       }
    
}
