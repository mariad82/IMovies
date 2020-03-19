//
//  IMMovieDetailsViewController.swift
//  iMovies
//
//  Created by Maria Davidenko on 17/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import youtube_ios_player_helper

struct MovieDetails : Codable {
    
    var id : Int?
    var results: [MovieVideo]?
}

struct MovieVideo : Codable {
    
    var id : String?
    var iso_639_1 : String?
    var iso_3166_1 : String?
    var key : String?
    var name : String?
    var site : String?
    var size : Int?
    var type : String?
}

class IMMovieDetailsViewController: UIViewController {

    var selectedMovie: Movie? = nil
    private var movieDetails: MovieDetails?
    let playerviewHeight = 220.0
    
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var lableDate: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var buttonPlayTrailer: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var buttonAllTrailers: UIButton!
    @IBOutlet weak var playerViewYouTube: YTPlayerView!
    
    @IBOutlet weak var layoutConstraintPlayerViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.selectedMovie?.original_title
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        
        setInitialUI()
        getMovieVideos(movieId: self.selectedMovie?.id ?? 0)
        
        
        // Do any additional setup after loading the view.
    }
    

    func setInitialUI() {
        
        let imageURLString = requestURLs.imageBaseUrl + (selectedMovie?.poster_path ?? "")
        let imageUrl = URL(string: imageURLString)
        
        imageViewPoster.sd_setImage(with: imageUrl) { (img, error, type, urls) in}
        
        lableDate.text = self.selectedMovie?.release_date
        labelOverview.text = self.selectedMovie?.overview
        playerViewYouTube.layer.masksToBounds = true
        playerViewYouTube.layer.cornerRadius = 5.0
        
    }
    
    func getMovieVideos(movieId id : Int) {
        
        let urlString = "\(requestURLs.getMovieVideos)\(id)/videos?api_key=\(APIKeys.moviesDBKey)&language=en-US"
        AF.request(urlString).responseJSON { (response) in
            
            switch(response.result) {
                
            case .success:
                
                if let data = response.data {
                    do {
                        
                        let decoder = JSONDecoder()
                        let responseObject = try decoder.decode(MovieDetails.self, from: data)
                        self.movieDetails = responseObject
                        
                        DispatchQueue.main.async {
                            
                            for movieVideo in self.movieDetails!.results ?? [] {
                                
                                if self.checkOfficialTrailerForSelectedMovie(movie: movieVideo) {
                                    
                                    self.buttonPlayTrailer.isHidden = false
                                    self.buttonAllTrailers.isHidden = false
                                }
                            }

                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                
            case .failure:
                
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    
    @IBAction func didTapPlayTrailerButton(_ sender: UIButton) {
        
        var videoToPlay:MovieVideo? = nil
        
        for movieVideo in self.movieDetails!.results ?? [] {
            
            if self.checkOfficialTrailerForSelectedMovie(movie: movieVideo) {
                
                videoToPlay = movieVideo
            }
        }
        
        layoutConstraintPlayerViewHeight.constant = CGFloat(playerviewHeight)
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
        
        playerViewYouTube.isHidden = false
        playerViewYouTube.load(withVideoId: videoToPlay!.key!)
    }
    
    @IBAction func didTapPlayAllTrailersButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: SegueIdentifiers.GoToTrailers, sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let trailersViewController = segue.destination as! IMTrailersViewController
        trailersViewController.movieVideos = self.movieDetails?.results
        trailersViewController.movieTitle = self.selectedMovie?.original_title
    }
    
}

extension UIViewController {
    
    func checkOfficialTrailerForSelectedMovie(movie sMovie:MovieVideo?) -> Bool {
        
        
        return sMovie?.site == VideoSiteTypes.YouTube.rawValue &&
            sMovie?.name?.contains("Official") ?? false &&
            sMovie?.type == VideoTypes.trailer.rawValue
    }
}
