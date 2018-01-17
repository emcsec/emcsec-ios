//
//  BaseSlider.swift
//  BitcoinBasic
//

import UIKit

class BaseSlider: UISlider {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ratio : CGFloat = CGFloat (value + 0.5)
        let thumbImage : UIImage = UIImage(named: "slider_image")!
        let size = CGSize(width: thumbImage.size.width * ratio, height: thumbImage.size.height * ratio)
        self.setThumbImage( self.imageWithImage(image: thumbImage, scaledToSize: size), for: UIControlState.normal )
    }
    
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{ UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext()
        return newImage }
}
