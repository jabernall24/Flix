//
//  SuperheroController.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 12/6/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import UIKit

class SuperheroController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var movies: [Movie] = []
    var movieId = 324857
    
    private var pageNumber = 1
    private var isFinishedLoading = true
    private var reachedBottom = false
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = movieId == 324857 ? "Superhero" : "Similar"
    }
    
    func fetchMovies() {
        if !isFinishedLoading || reachedBottom { return }
        isFinishedLoading = false
        activityIndicator.startAnimating()
        
        TheMovieDBAPI.shared.nowPlayingSimilar(for: movieId, page: pageNumber) { [weak self] result in
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
                self.collectionView.reloadData()
            case .failure(let error):
                Alert.shared.showFlixErrorAlert(with: error, on: self)
            }
        }
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        
        let moviesPerRow: CGFloat = 2
        let marginOffset = CGFloat(collectionView.layoutMargins.left)
        let width = (view.frame.size.width - marginOffset) / moviesPerRow
        layout.estimatedItemSize = CGSize(width: width, height: width * 1.5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? MovieDetailsController {
            guard let cell = sender as? UICollectionViewCell else { return }
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            
            destVC.movie = movies[indexPath.row]
        }
    }
}

extension SuperheroController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        
        if distanceFromBottom < height {
            fetchMovies()
        }
    }
    
}
