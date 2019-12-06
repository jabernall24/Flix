//
//  MovieDetailsController.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 12/6/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import UIKit

class MovieDetailsController: UIViewController {

    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    var movie: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateView()
    }
    
    func populateView() {
        guard let movie = movie else { return }

        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movie["poster_path"] as! String))!
        let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movie["backdrop_path"] as! String))!
        backdropImageView.downloaded(from: backdropURL, contentMode: .scaleAspectFill)
        moviePosterImageView.downloaded(from: posterURL)
        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String
        dateLabel.text = movie["release_date"] as? String
    }

}
