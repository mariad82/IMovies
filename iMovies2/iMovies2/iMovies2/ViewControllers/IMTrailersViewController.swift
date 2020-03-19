//
//  IMTrailersViewController.swift
//  iMovies
//
//  Created by Maria Davidenko on 17/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class IMTrailerCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var viewYouTubePlayer: YTPlayerView!
    @IBOutlet weak var labelTrailerTitle: UILabel!
    
    var movie:MovieVideo = MovieVideo() {
        
        didSet {
          
            self.labelTrailerTitle.text = movie.name
            viewYouTubePlayer.load(withVideoId: movie.key ?? "")
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
    }
}

class IMTrailersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, IMTrailerCollectionViewLayoutDelegate {
    
    var movieTitle : String?
    var movieVideos: [MovieVideo]?
        
    @IBOutlet weak var trailerLayout: IMTrailerCollectionViewLayout!
//        {
//        
//        didSet {
//            
//            trailerLayout.estimatedItemSize = CGSize(width: self.collectionView.frame.size.width / 2,  height: self.collectionView.frame.size.height / 4)
//        }
//    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setIntialUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()

        
    }
    

    func setIntialUI() {
        
        self.navigationItem.title = movieTitle
        
        if let layout = collectionView?.collectionViewLayout as? IMTrailerCollectionViewLayout {
          layout.delegate = self
            
        }
    }
    
//    MARK: - UICollectionViewDataSource Protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieVideos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        let movieVideo = movieVideos?[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.IMTrailerCollectionViewCell, for: indexPath) as! IMTrailerCollectionViewCell
        cell.movie = movieVideo ?? MovieVideo()
        
        return cell
    }
    
//    MARK: - IMTrailerCollectionViewLayoutDelegate Protocol
    
    func theNumberOfItemsInCollectionView() -> Int {
        
        return movieVideos?.count ?? 0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

//    MARK: - IMTrailerCollectionViewLayoutDelegate Protocol
    
    
}



