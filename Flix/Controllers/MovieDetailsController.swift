//
//  MovieDetailsController.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 12/6/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import UIKit
import SafariServices

class MovieDetailsController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var movie: Movie!
    var reviews: [Review] = []
    
    private var pageNumber = 1
    private var isFinishedLoading = true
    private var reachedBottom = false
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        getMovieReviews()
    }
    
    @objc func onTapPosterImageView() {
        let title = movie.title.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: "https://www.youtube.com/results?search_query=\(title)%20trailer") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        } else {
            print("https://www.youtube.com/results?search_query=\(movie.title)")
        }
    }
    
    func getMovieReviews() {
        if !isFinishedLoading || reachedBottom { return }
        isFinishedLoading = false
        activityIndicator.startAnimating()
        
        TheMovieDBAPI.shared.getReviewsFor(movie: movie.id, page: pageNumber) { [weak self] result in
            guard let self = self else { return }
            self.isFinishedLoading = true
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let reviews):
                if reviews.count == 0 {
                    self.reachedBottom = true
                    return
                }
                self.reviews.append(contentsOf: reviews)
                self.pageNumber += 1
                self.tableView.reloadData()
            case .failure(let error):
                Alert.shared.showFlixErrorAlert(with: error, on: self)
            }
        }
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SuperheroController {
            destVC.movieId = movie.id
        }
    }
    
}

extension MovieDetailsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1}
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsCell", for: indexPath) as! MovieDetailsCell
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTapPosterImageView))
            cell.posterImageView.addGestureRecognizer(recognizer)
            cell.movie = movie
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.review = reviews[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Reviews"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        
        if distanceFromBottom < height {
            getMovieReviews()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
