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
    var movies: [Movie] = []
    
    private var pageNumber = 1
    private var isFinishedLoading = true
    private var reachedBottom = false
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        loadNowPlayingMovies()
    }
    
    func loadNowPlayingMovies() {
        if !isFinishedLoading || reachedBottom { return }
        isFinishedLoading = false
        activityIndicator.startAnimating()
        
        TheMovieDBAPI.shared.nowPlaying(page: pageNumber) { [weak self] result in
            guard let self = self else { return }
            self.isFinishedLoading = true
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let movies):
                if movies.count == 0 {
                    self.reachedBottom = true
                    return
                }
                self.movies.append(contentsOf: movies)
                self.pageNumber += 1
                self.tableView.reloadData()
            case .failure(let error):
                Alert.shared.showFlixErrorAlert(with: error, on: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let movieDetailsController = segue.destination as? MovieDetailsController {
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            movieDetailsController.movie = movies[indexPath.row]
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
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        
        if distanceFromBottom < height {
            loadNowPlayingMovies()
        }
    }
}

// MARK: Set Up
extension NowPlayingController {
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
