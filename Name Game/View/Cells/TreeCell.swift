//
//  TreeCell.swift
//  Name Game
//
//  Created by Michal Hus on 5/16/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import UIKit

class TreeCell: UICollectionViewCell {
    var pictureData: Data?
    
    @IBOutlet weak var treeImage: UIImageView!
    
    func downloadImage(from url: URL, imageSize: CGSize) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                guard let image = UIImage(data: data) else { return }
                self?.imageScalling(imageSize: imageSize, treeImage: image, overlayImage: nil)
                self?.pictureData = data
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func updateImageGuess(imageSize: CGSize, correctGuess: Bool = true) {
        
        guard let pictureData = pictureData, let bottomImage = UIImage(data: pictureData) else { return }
        let overlayImage = guessOverlay(correctGuess: correctGuess)
        imageScalling(imageSize: imageSize, treeImage: bottomImage, overlayImage: overlayImage)
    }
    
    func imageScalling(imageSize: CGSize, treeImage: UIImage, overlayImage: UIImage?) {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        treeImage.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        if let overlayImage = overlayImage {
            overlayImage.draw(in: CGRect(origin: CGPoint.zero, size: imageSize ), blendMode: .normal, alpha: 0.5)
        }
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.treeImage.image = scaledImage
    }
   
    func guessOverlay(correctGuess: Bool) -> UIImage {
        return correctGuess ? UIImage(named: "Frame 1")! : UIImage(named: "Frame 2")!
    }
}
