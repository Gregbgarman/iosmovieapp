//
//  AllMoviesViewController.swift
//  iosmovieapp
//
//  Created by Greg Garman on 12/16/21.
//

import UIKit
import AlamofireImage

class AllMoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var CVMovies: UICollectionView!
    private var Movies=[[String:Any]]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=CVMovies.dequeueReusableCell(withReuseIdentifier: "EachMovieCollectionViewCell", for: indexPath) as! EachMovieCollectionViewCell
        
        let movie=Movies[indexPath.item]
        
        let baseurl="https://image.tmdb.org/t/p/w185"
        let posterpath=movie["poster_path"] as! String
        let posterUrl=URL(string: baseurl+posterpath)!
        cell.ivMovie.af.setImage(withURL: posterUrl)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CVMovies.delegate=self
        CVMovies.dataSource=self
        
        let layout=CVMovies.collectionViewLayout as! UICollectionViewFlowLayout
        
    
        layout.minimumLineSpacing=4    //pixels between rows
        layout.minimumInteritemSpacing=4
        
        let width=(view.frame.size.width-layout.minimumInteritemSpacing*2)/3     //gets width of screen and will change based on phone app is running on
        
        layout.itemSize=CGSize(width: width, height: width*3/2)
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             }
             else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                self.Movies=dataDictionary["results"]as! [[String:Any]]  //getting the json results
                
                self.CVMovies.reloadData()
                
             }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell=sender as! UICollectionViewCell
        let indexPath=CVMovies.indexPath(for: cell)!
        let movie=Movies[indexPath.item]
        
        let detailsViewController=segue.destination as! MovieDetailsController
        detailsViewController.TheMovie=movie
    }

    

}
