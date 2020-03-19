//
//  IMPopularMoviesViewController.swift
//  iMovies
//
//  Created by Maria Davidenko on 16/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

struct Result: Codable {

    var page : Int?
    var total_results : Int?
    var total_pages: Int?
    var results: [Movie]?
    
    
}

struct Movie: Codable {
    
    var popularity: Float?
    var vote_count: Int?
    var video : Bool?
    var poster_path : String?
    var id: Int?
    var adult: Bool?
    var backdrop_path: String?
    var original_language: String?
    var original_title: String?
    var genre_ids: [Int]?
    var title: String?
    var vote_average:Float?
    var overview: String?
    var release_date:String?
}

class IMMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewMovieIcon: UIImageView!
    @IBOutlet weak var labelMovieTitle: UILabel!
    var movie:Movie? = Movie() {
        
        didSet {
            
            let imageURLString = requestURLs.imageBaseUrl + (movie?.poster_path ?? "")
            let imageUrl = URL(string: imageURLString) 
            
                
                imageViewMovieIcon.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "Folder-Movies-icon"), options: SDWebImageOptions.progressiveLoad) { (image, error, chacheType, url) in

            }
            
            
            labelMovieTitle.text = movie?.title

        }
    }
    
    override func prepareForReuse() {
        
        imageViewMovieIcon.image = nil
    }
}

class IMPopularMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    let numberOfPages = 5
    let ESTIMATED_ROW_HEIGHT : CGFloat = 143

    @IBOutlet weak var tableViewMovies: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedGenre:genre? = nil
    private var selectedMovie: Movie? = nil
    private var datasourceArray : [Movie]? = []
    private var dataSourceCopy :[Movie]? = []
    private var page = 1
    private var filteredDataSource : [Movie] = []
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Populars Movies"
        self.labelTitle.text = "Populars Movies"
        initTableView()
        initSearchController()
        getPopularMoviesForPage(page: page)
        // Do any additional setup after loading the view.
    }

    fileprivate func initSearchController() {
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func initTableView() {
        
        tableViewMovies.estimatedRowHeight = ESTIMATED_ROW_HEIGHT

    }
    //    MARK: -  UITableViewDataSource Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasourceArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let movie = datasourceArray?[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IMMovieTableViewCell", for: indexPath) as! IMMovieTableViewCell
        cell.movie = movie
        
        let existInGenresList = movie?.genre_ids?.contains(selectedGenre?.id ?? 0) ?? false
        
        if existInGenresList {
            
            cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4796279073, blue: 0, alpha: 1)

        }
        
        cell.labelMovieTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
//    MARK: - UITableViewDelegate Protocol
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        selectedMovie = self.datasourceArray?[row]
        performSegue(withIdentifier: SegueIdentifiers.GoToMovieDetails, sender: self)
    }
    
    
//    MARK: - Network functions
    
    private func getPopularMoviesForPage(page pg : Int) {
        
        
        print(page)
        let urlString = "\(requestURLs.getPopularMovie)\(getSelectedLanguage())&page=\(pg)"
        AF.request(urlString).responseJSON { (response) in
            
            switch(response.result) {
                
            case .success:
                
                
                if let data = response.data {
                    do {
                        
                        let decoder = JSONDecoder()                        
                        let responseArray = try decoder.decode(Result.self, from: data)
                        DispatchQueue.main.async {
                            
                            if self.datasourceArray?.count == 0 {
                                self.datasourceArray! += responseArray.results!
                            }
                            else {
                                
                                self.datasourceArray?.append(contentsOf: responseArray.results!)
                            }
                            
                            self.dataSourceCopy = self.datasourceArray
                            self.tableViewMovies.reloadData()
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
        
        if page >= numberOfPages {
            page  = 0
        }
        else {
            page += 1
        }

    }
    
//    MARK: = UIScrollViewDelegate Protocol
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            if  page <= numberOfPages, page != 0 {
                getPopularMoviesForPage(page: page)
            }
        }

    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


        let segueIdentifier = segue.identifier
        
        if segueIdentifier == SegueIdentifiers.GoToMovieDetails {
            
            let movieViewController = segue.destination as! IMMovieDetailsViewController
            movieViewController.selectedMovie = self.selectedMovie
        }
    }

}


extension IMPopularMoviesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    //    MARK: - UISearchResultsUpdating Protocol
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text
        filteredDataSource = datasourceArray?.filter({ (movie) -> Bool in
            
            
            (movie.title?.lowercased().contains(String((searchText?.lowercased())!)) ?? false)
        }) ?? []
        
        
        if filteredDataSource.count > 0 {
            
            datasourceArray = filteredDataSource
            filteredDataSource.removeAll()
        }
        
        tableViewMovies.reloadData()
    }
    
    //MARK: - UISearchBarDelegate Protocol
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        datasourceArray = dataSourceCopy
        tableViewMovies.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == Global.EMPTY_STRING {
                
            //Clear text searh reloadd old results
            
            datasourceArray = dataSourceCopy
            searchBar.resignFirstResponder()
            tableViewMovies.reloadData()
        }
        
    }

}

extension IMPopularMoviesViewController {
    
    func getSelectedLanguage() -> String {
        
        let selectedLanguage = UserDefaults.standard.value(forKey: Global.kSelectedLanguage) as! String
        return selectedLanguage

    }
}
