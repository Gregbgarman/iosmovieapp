//
//  HomeViewController.swift
//  iosmovieapp
//
//  Created by Greg Garman on 12/15/21.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var TVMoview: UITableView!
    private var AllMovies = [[String:Any]]()      //contains array of dictionaries
    private var PosterBaseURL: String!
    private var IsIpad: Bool!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllMovies.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TVMoview.dequeueReusableCell(withIdentifier: "EachMovieCell") as! EachMovieCell
        
        let TheMovie = AllMovies[indexPath.row]
        let Title = TheMovie["title"] as! String
        let Description = TheMovie["overview"] as! String
        
        let posterpath = TheMovie["poster_path"] as! String
        let posterUrl=URL(string: self.PosterBaseURL+posterpath)!
        
        if IsIpad == true{
            cell.lblMovieTitle.font = cell.lblMovieTitle.font.withSize(21)
            cell.lblMovieDesc.font = cell.lblMovieDesc.font.withSize(22)
        }
        
        cell.ivMovieImage.af.setImage(withURL: posterUrl)
        cell.lblMovieTitle.text = Title
        cell.lblMovieDesc.text = Description

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IsIpad == true{
            return (view.frame.size.height/4)
        }
        return (view.frame.size.height)/5
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        TVMoview.dataSource = self
        TVMoview.delegate = self
        CallMovieAPI()
        
        PosterBaseURL = "https://image.tmdb.org/t/p/w185"       //for iphone
        if view.frame.size.width >= 415 {
            self.PosterBaseURL = "https://image.tmdb.org/t/p/w342"  //for ipad
            IsIpad = true
        }
        
    }
    

    func CallMovieAPI() -> Void {
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

                self.AllMovies=dataDictionary["results"] as! [[String:Any]]  //getting the json results
                
                self.TVMoview.reloadData()
        
             }
    
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        //function used for clicking on movie and going to another screen
        //sender in the fxn is the cell that is tapped on
        //this code itself will send user to the viewcontroller
        
        let cell=sender as! UITableViewCell
        let indexPath=TVMoview.indexPath(for: cell)!
        let movie=AllMovies[indexPath.row]
        
        let detailsViewController=segue.destination as! MovieDetailsController
        
        detailsViewController.TheMovie=movie
        
       TVMoview.deselectRow(at: indexPath, animated: true)
      
        
        
    }
    
}
