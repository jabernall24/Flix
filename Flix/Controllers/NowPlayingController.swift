//
//  NowPlayingController.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 11/25/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import UIKit

class NowPlayingController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var movies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNowPlayingMovies()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }

    func loadNowPlayingMovies() {
        TheMovieDBAPI.nowPlaying { (result) in
            switch result {
            case .success(let data):
                self.movies = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: Table view
extension NowPlayingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let url = URL(string: "https://image.tmdb.org/t/p/w500" + (movie["poster_path"] as! String))!
        
        cell.moviePostImageView.downloaded(from: url)
        cell.titleLabel.text = movie["title"] as? String
        cell.overviewLabel.text = movie["overview"] as? String
        
        return cell
    }
    
    
}
