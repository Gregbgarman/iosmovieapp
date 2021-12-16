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
    private var MovieTitlesSet = Set<String>()      //to avoid adding duplicate movies
    
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
        QueryMovies(PageNumber:"1")
      
    }
    
    
    func QueryMovies(PageNumber:String) -> Void {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=&page=" + PageNumber)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             }
             else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let TheResults=dataDictionary["results"] as! [[String:Any]]  //getting the json results
                 
                 for movie in TheResults{       //iterating through array of dictionaries
                     
                     if !self.MovieTitlesSet.contains(movie["title"] as! String){       //don't want to add duplicates
                         self.Movies.append(movie)                                  //adding dictionary to our array
                         self.MovieTitlesSet.insert(movie["title"] as! String)
                     }
                 }
                
                     self.CVMovies.reloadData()
                  
             }
            if PageNumber == "1"{                   //recursively calling this fxn so it always adds movies in certain order
                self.QueryMovies(PageNumber:"2")
            }
            
            else if PageNumber == "2"{
                self.QueryMovies(PageNumber:"3")
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
