//
//  CollectionViewCell.swift
//  Weather
//
//  Created by 徐艺文 on 9/8/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}


