//
//  PhotoCell.swift
//  Flickr
//
//  Created by Евгений Холкин on 06.06.2020.
//  Copyright © 2020 Евгений Холкин. All rights reserved.
//

import Nuke
import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(items: Items) {

        guard let photoUrlString = items.media?.m else {
            return
        }
        guard let photoUrl = URL(string: photoUrlString) else {
            return
        }
        Nuke.loadImage(with: photoUrl, into: photoView)
        photoView.layer.cornerRadius = 15
        
        if items.title == " " {
            nameLabel.text = "No title"
        }
        else {
            nameLabel.text = items.title?.capitalized
        }
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        //nameLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        nameLabel.layer.masksToBounds = true
        nameLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowRadius = 1
        nameLabel.layer.shadowOpacity = 1
        photoView.layer.masksToBounds = true
        photoView.layer.shadowOffset = CGSize(width: 2, height: 2)
        photoView.layer.shadowColor = UIColor.black.cgColor
        photoView.layer.shadowRadius = 1
        photoView.layer.shadowOpacity = 1
    }
    
}
