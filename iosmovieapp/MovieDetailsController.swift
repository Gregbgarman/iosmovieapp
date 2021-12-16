//
//  MovieDetailsController.swift
//  iosmovieapp
//
//  Created by Greg Garman on 12/15/21.
//

import UIKit
import AlamofireImage
import WebKit


class MovieDetailsController: UIViewController, WKUIDelegate {

    var TheMovie:[String:Any]!
    private var VideoResults = [[String:Any]]()      //contains arrays of dictionaries
    private var CastResults = [[String:Any]]()
    
    @IBOutlet weak var ivBackImage: UIImageView!
    
    @IBOutlet weak var ivPoster: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var WVyoutube: WKWebView!
    
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var ivActor1: UIImageView!
    
    @IBOutlet weak var lblActor1: UILabel!
    
    @IBOutlet weak var lblActor1Name: UILabel!

    @IBOutlet weak var ivActor2: UIImageView!
    
    @IBOutlet weak var lblActor2Role: UILabel!
    
    @IBOutlet weak var lblActor2Name: UILabel!
    
    @IBOutlet weak var ivActor3: UIImageView!
    
    @IBOutlet weak var lblActor3Role: UILabel!
    
    @IBOutlet weak var lblActor3Name: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = TheMovie["title"] as! String
        lblDesc.text = TheMovie["overview"] as? String
        lblDesc.sizeToFit()
        
        let CriticScore = TheMovie["vote_average"] as! Double
        lblScore.text = "Voter Rating: " + String(CriticScore) + "/10"
        
        let baseurl="https://image.tmdb.org/t/p/w185"
        let posterpath=TheMovie["poster_path"] as! String
        let posterUrl=URL(string: baseurl+posterpath)!
        ivPoster.af.setImage(withURL: posterUrl)
        
        let backdroppath=TheMovie["backdrop_path"] as! String
        let backdropurl=URL(string: "https://image.tmdb.org/t/p/w780"+backdroppath)
        ivBackImage.af.setImage(withURL: backdropurl!)
        let movieid = self.TheMovie["id"] as! Int
        let idstring = String(movieid)
        
        FirstAPICall(MovieId:idstring)
        SecondAPICall(MovieId:idstring)
    
    }
    
    func SecondAPICall(MovieId:String) -> Void {
        let CastURL = URL(string: "https://api.themoviedb.org/3/movie/" + MovieId + "/credits?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: CastURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             }
             else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.CastResults=dataDictionary["cast"] as! [[String:Any]]  //getting the json results
                 
                 if self.CastResults.count > 0{
                     let Actor1 = self.CastResults[0]
                     self.lblActor1.text = Actor1["character"] as? String
                     self.lblActor1Name.text = Actor1["name"] as? String
                     let Actor1imgpath = Actor1["profile_path"] as! String
                     let Actor1img = URL(string: "https://image.tmdb.org/t/p/w185/" + Actor1imgpath)!
                     self.ivActor1.af.setImage(withURL: Actor1img)
                 }
                 if self.CastResults.count >= 2{
                     let Actor2 = self.CastResults[1]
                     self.lblActor2Role.text = Actor2["character"] as? String
                     self.lblActor2Name.text = Actor2["name"] as? String
                     let Actor2imgpath = Actor2["profile_path"] as! String
                     let Actor2img = URL(string: "https://image.tmdb.org/t/p/w185/" + Actor2imgpath)!
                     self.ivActor2.af.setImage(withURL: Actor2img)
                 }
                  
                 if self.CastResults.count >= 3{
                     let Actor3 = self.CastResults[2]
                     self.lblActor3Role.text = Actor3["character"] as? String
                     self.lblActor3Name.text = Actor3["name"] as? String
                     let Actor3imgpath = Actor3["profile_path"] as! String
                     let Actor3img = URL(string: "https://image.tmdb.org/t/p/w185/" + Actor3imgpath)!
                     self.ivActor3.af.setImage(withURL: Actor3img)
                 }
                 
                 
             }
        }
        task.resume()
        
    }
    
    
    func FirstAPICall(MovieId:String) -> Void {
       
        let VideoURL = URL(string: "https://api.themoviedb.org/3/movie/" + MovieId + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: VideoURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             }
             else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.VideoResults=dataDictionary["results"] as! [[String:Any]]  //getting the json results
                 
                 var FoundOfficial = false
                 var YoutubeKey: String!
                 for video in self.VideoResults{
                     
                     if video["name"] as! String == "Official Trailer"{
                         YoutubeKey=video["key"] as! String
                         FoundOfficial = true
                         break
                     }
                 }
                 
                 if FoundOfficial == false{
                     let video = self.VideoResults[0]
                     YoutubeKey = video["key"] as! String
                 }
                 
                // let YoutubeURL = URL(string: "https://www.youtube.com/watch?v=" + YoutubeKey)!
                 let YoutubeURL = URL(string: "https://www.youtube.com/embed/" + YoutubeKey)!

                 
                self.WVyoutube.load(URLRequest(url: YoutubeURL))
             }
        }
        task.resume()
    }
    

}
