//
//  PosterCell.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 12/6/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {

    @IBOutlet var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            posterImageView.downloaded(from: movie.getPosterPathUrlString())
        }
    }
}
