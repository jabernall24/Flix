//
//  MovieDetailsCell.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 2/13/20.
//  Copyright © 2020 Jesus Bernal Lopez. All rights reserved.
//

import UIKit
import SafariServices

class MovieDetailsCell: UITableViewCell {

    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var rateMovieButton: UIButton!
    
    var movie: Movie! {
        didSet {
            backdropImageView.downloaded(from: movie.getBackdropPathUrlString(), contentMode: .scaleAspectFill)
            posterImageView.downloaded(from: movie.getPosterPathUrlString())
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            dateLabel.text = movie.releaseDate
        }
    }
    
    @IBAction func onRateMovie(_ sender: UIButton) {

    }
}
