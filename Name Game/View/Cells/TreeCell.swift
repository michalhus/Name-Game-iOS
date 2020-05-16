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
    let newSize = CGSize(width:( UIScreen.main.bounds.width - 20) / 2, height: (UIScreen.main.bounds.width - 20) / 2)
    
    @IBOutlet weak var treeImage: UIImageView!
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                let image = UIImage(data: data)

                UIGraphicsBeginImageContextWithOptions(self!.newSize, false, 0.0)
                image?.draw(in: CGRect(origin: CGPoint.zero, size: self!.newSize ), blendMode: .normal, alpha: 1.0)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                self?.treeImage.image = newImage
                self?.pictureData = data
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func saveImage(correctGuess: Bool = true) {
        
        let bottomImage = UIImage(data: pictureData!)!
        var topImage: UIImage
        
        if correctGuess {
            topImage = UIImage(named: "Frame 1")!
        } else {
            topImage = UIImage(named: "Frame 2")!
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        topImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize ), blendMode: .normal, alpha: 0.5)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.treeImage.image = newImage
    }
}
