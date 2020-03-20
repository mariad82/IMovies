//
//  MasterViewController.swift
//  iMovies
//
//  Created by Maria Davidenko on 16/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import UIKit
import Alamofire

struct Genres : Codable {
    
    var genres : [genre]?
    
}

struct genre : Codable {
    
    var id : Int?
    var name: String?
    
}

class IMGenreItemCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var labelGenreName: UILabel!
    


    
    var newGenre: genre = genre() {
        
        didSet {
            
            self.labelGenreName.text = self.newGenre.name
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

class IMMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    
    @IBOutlet weak var collectionViewGenres: UICollectionView!
    
    @IBOutlet weak var genresLayout: IMGenresCollectionViewLayout!
      
    @IBOutlet weak var labelGenreSelection: UILabel!
    
    lazy private  var myGenres: Genres? = Genres()
    lazy private var genresArray : [genre] = self.myGenres?.genres ?? []
    private var selectedGenre: genre?
    
    override func viewDidLoad() {
        
//        self.changeLocale(languageValues.appleEnglish.rawValue)
        super.viewDidLoad()
        self.labelGenreSelection.text = "Select Genre"//NSLocalizedString("SelectGenre", comment: "Select Genre")
        self.navigationItem.title = "Genres"//NSLocalizedString("Genres", comment: "Genres")

        // Do any additional setup after loading the view.
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        setDefaultLanguageToEnglish()
        changeNavigationItemTitle()
        myGenres = getAllGenres()
        
        
    }
    
    func setDefaultLanguageToEnglish() {
        
        UserDefaults.standard.set(languageValues.english.rawValue, forKey: Global.kSelectedLanguage)
        UserDefaults.standard.synchronize()
        changeNavigationItemTitle()
//        self.changeLocale(languageValues.appleEnglish.rawValue)

    }

    @objc func didTapChangeLanguageButton () {
        
        
        let selectedCode  = languages(rawValue: (self.navigationItem.rightBarButtonItem?.title)!)!
        
        switch selectedCode {
        case .english:
            UserDefaults.standard.set(languageValues.hebrew.rawValue, forKey: Global.kSelectedLanguage)
            self.navigationItem.rightBarButtonItem?.title = languages.hebrew.rawValue
        case .hebrew:
            UserDefaults.standard.set(languageValues.english.rawValue, forKey: Global.kSelectedLanguage)
//            self.changeLocale(languageValues.appleEnglish.rawValue)
            self.navigationItem.rightBarButtonItem?.title = languages.english.rawValue
        case .russian:
            UserDefaults.standard.set(languageValues.russian.rawValue, forKey: Global.kSelectedLanguage)

        }
        
        UserDefaults.standard.synchronize()
        self.labelGenreSelection.text = "SelectGenre"//NSLocalizedString("SelectGenre", comment: "Select Genre")

        changeNavigationItemTitle()
        myGenres = getAllGenres()
        self.navigationItem.title = "Genres"  //NSLocalizedString("Genres", comment: "Genres")

    }
    
    fileprivate func changeNavigationItemTitle() {
        

        let selectedLanguageCode  = languageValues(rawValue:UserDefaults.standard.value(forKey: Global.kSelectedLanguage) as! String)
        var displayLanguage = ""
        var displayicon = ""
        
        switch selectedLanguageCode {
        case .english:
            displayLanguage = languages.english.rawValue
            displayicon = "United-Kingdom-Flag-3-icon"
        case .russian:
            displayLanguage = languages.russian.rawValue
            displayicon = "United-Kingdom-Flag-3-icon"
        case .hebrew:
            displayLanguage = languages.hebrew.rawValue
            displayicon = "Israel-Flag-3-icon"
        default:
            displayLanguage = languages.hebrew.rawValue
            displayicon = "Israel-Flag-3-icon"
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: displayLanguage, style: .bordered, target: self, action: #selector(didTapChangeLanguageButton))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.4796279073, blue: 0, alpha: 1)


        // Bar title text color
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        let color : UIColor = .black
        let titleFont : UIFont = UIFont(name: "AmericanTypewriter", size: 16.0)!

        let attributes = [
            NSAttributedString.Key.foregroundColor : color,
            NSAttributedString.Key.shadow : shadow,
            NSAttributedString.Key.font : titleFont
        ]

//        self.navigationItem.rightBarButtonItem?.image = UIImage(named: displayicon)
        UIBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)

    }
    
//    MARK: - Network calls
    
    func getAllGenres() -> Genres {

        
        var requestResults = Genres()
                
        let selectedLanguage = UserDefaults.standard.value(forKey: Global.kSelectedLanguage) as! String
        print(selectedLanguage)

        let stringUrl = "\(requestURLs.getGenres)\(selectedLanguage)"
        AF.request(stringUrl).responseJSON { (response) in
            
            switch(response.result) {
                
            case .success:
                
                
                if let data = response.data {
                    do {
                        
                        let decoder = JSONDecoder()
                        let responseArray = try decoder.decode(Genres.self, from: data)
                        DispatchQueue.main.async {
                            
                            requestResults = responseArray
                            self.myGenres = responseArray
                            
                            self.collectionViewGenres.reloadData()
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
        
        return requestResults
    }
    
    // MARK: - UICollectionViewDatasource Protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  myGenres?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IMGenreItemCollectionCell", for: indexPath) as? IMGenreItemCollectionCell
        
        let row = indexPath.row
        let movieGenre = myGenres?.genres?[row]
        
        cell?.newGenre = movieGenre!
        
        return cell!
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    // MARK: - UICollectionViewDelegate Protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        self.selectedGenre = myGenres?.genres?[row]
        performSegue(withIdentifier: SegueIdentifiers.GoToPopularMovies, sender: self)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueId = segue.identifier
        
        if segueId == SegueIdentifiers.GoToPopularMovies {
            
            let  viewController = segue.destination as! IMPopularMoviesViewController
            viewController.selectedGenre = selectedGenre
        }
    }

    func changeLocale(_ locale : String) {
        
        UserDefaults.standard.set(locale, forKey: Global.kAppleLanguages)
        UserDefaults.standard.synchronize()

    }
    
}


extension IMMainViewController {
    
    func getSelectedLanguage() -> String {
        
        let selectedLanguage = UserDefaults.standard.value(forKey: Global.kSelectedLanguage) as! String
        return selectedLanguage

    }
}
