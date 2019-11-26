//
//  ViewController.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 11/25/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var movies: [[String: Any]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNowPlayingMovies()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 220
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
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) { 
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
