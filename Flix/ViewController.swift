//
//  ViewController.swift
//  Flix
//
//  Created by Owner on 1/20/20.
//  Copyright © 2020 Brandon Hsu @ CodePath. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movies: [[String: Any]] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
             
                // Populate rows and cells
                self.tableView.reloadData()
            }
        }
        task.resume()
}
    // create amount of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // modification for each cell in a row
    func tableView(_ tableVirew: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell // typecast cell as MovieCell
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
       
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }


 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPath(for: cell)!
    let movie = movies[indexPath.row]
    
    // Pass the selected movie to the MovieDetialsViewController
    // create a variable of type MovieDetailsViewController
    let detailsViewController = segue.destination as! MovieDetailsViewController
    
    // transfer data from one view controller to another
    detailsViewController.movie = movie
    
    // remove cell highlighting
    tableView.deselectRow(at: indexPath, animated: true)
    
 }
 

}
