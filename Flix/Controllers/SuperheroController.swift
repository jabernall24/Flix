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
    var movies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        setGridLayout()
        fetchMovies()
    }
    
    func fetchMovies() {
        TheMovieDBAPI.nowPlayingSimilar { (result) in
            switch result {
            case .success(let movies):
                self.movies = movies
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setGridLayout() {
        
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5

        layout.minimumLineSpacing = layout.minimumInteritemSpacing
                
        let moviesPerRow: CGFloat = 2
        let marginOffset = CGFloat(collectionView.layoutMargins.left)
        let width = (view.frame.size.width - marginOffset) / moviesPerRow
        layout.estimatedItemSize = CGSize(width: width, height: width * 1.5)
    }

}

extension SuperheroController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        let movie = movies[indexPath.row]
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movie["poster_path"] as! String))!
        cell.posterImageView.downloaded(from: posterURL)
        return cell
    }
        
}
