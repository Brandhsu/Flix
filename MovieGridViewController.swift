//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Owner on 1/26/20.
//  Copyright © 2020 Brandon Hsu @ CodePath. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    var movies: [[String : Any?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // configuring collection view layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 40px between each row
        layout.minimumLineSpacing = 4
        
        // 40 px inbetween each cell
        layout.minimumInteritemSpacing = 4
        
        // grabs the width of the screen
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2)/3
        layout.itemSize = CGSize(width: width, height: width*1.5)

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/359724/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // Dictionary storing JSON data
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
                self.movies = dataDictionary["results"] as! [[String : Any]] // type casting
                self.collectionView.reloadData()
                print(self.movies)
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)!
        cell.posterView.af_setImage(withURL: posterURL)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let grid = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: grid)!
        let movie = movies[indexPath.item]
        
        // Pass the selected movie to the MovieDetialsViewController
        // create a variable of type MovieDetailsViewController
        let detailsViewController = segue.destination as! MovieGirdDetailsViewController
        
        // transfer data from one view controller to another
        detailsViewController.movie = movie
        
        // remove cell highlighting
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }

}

