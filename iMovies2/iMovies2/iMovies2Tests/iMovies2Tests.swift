//
//  iMovies2Tests.swift
//  iMovies2Tests
//
//  Created by Maria Davidenko on 20/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import XCTest
import Alamofire

@testable import iMovies2
@testable import Alamofire

class iMovies2Tests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testAllGenresRequestResultsEnglish () {
        
        var requestResults = Genres()
        
        let selectedLanguage = languageValues.english.rawValue
        
        
                let genres = [genre(id: 28, name: "Action"),
                genre(id: 12, name: "Adventure"),
                genre(id: 16, name: "Animation"),
                genre(id: 35, name: "Comedy"),
                genre(id: 80, name: "Crime"),
                genre(id: 99, name: "Documentary"),
                genre(id: 18, name: "Drama"),
                genre(id: 10751, name: "Family"),
                genre(id: 14, name: "Fantasy"),
                genre(id: 36, name: "History"),
                genre(id: 27, name: "Horror"),
                genre(id: 10402, name: "Music"),
                genre(id: 9648, name: "Mystery"),
                genre(id: 10749, name: "Romance"),
                genre(id: 878, name: "Science Fiction"),
                genre(id: 10770, name: "TV Movie"),
                genre(id: 53, name: "Thriller"),
                genre(id: 10752, name: "War"),
                genre(id: 37, name: "Western")]
                let allGenres = Genres(genres: genres)
        
        
        
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
                            XCTAssert((requestResults.genres as Any) is [genre])
                            XCTAssert(requestResults.genres!.count > 0)
                            XCTAssert(((requestResults.genres?.filter({ (genre) -> Bool in
                                
                                genre.id == genres.first?.id
                            })) != nil))
                            
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        XCTAssert(error.asAFError?.responseCode == 404)
                        
                    }
                }
                
            case .failure:
                
                print(response.error?.localizedDescription as Any)
            }
            
            
        }
        
        
    }
    
    func testAllGenresRequestResultsHebrew () {
        
        
        let genres = [genre(id: 28, name: "Action"),
        genre(id: 12, name: "Adventure"),
        genre(id: 16, name: "Animation"),
        genre(id: 35, name: "Comedy"),
        genre(id: 80, name: "Crime"),
        genre(id: 99, name: "Documentary"),
        genre(id: 18, name: "Drama"),
        genre(id: 10751, name: "Family"),
        genre(id: 14, name: "Fantasy"),
        genre(id: 36, name: "History"),
        genre(id: 27, name: "Horror"),
        genre(id: 10402, name: "Music"),
        genre(id: 9648, name: "Mystery"),
        genre(id: 10749, name: "Romance"),
        genre(id: 878, name: "Science Fiction"),
        genre(id: 10770, name: "TV Movie"),
        genre(id: 53, name: "Thriller"),
        genre(id: 10752, name: "War"),
        genre(id: 37, name: "Western")]
        let allGenres = Genres(genres: genres)

        var requestResults = Genres()
        
        let selectedLanguage = languageValues.hebrew.rawValue
        
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
                            XCTAssert((requestResults.genres as Any) is [genre])
                            XCTAssert(requestResults.genres!.count > 0)
                            XCTAssert(((requestResults.genres?.filter({ (genre) -> Bool in
                                
                                genre.id == genres.first?.id
                            })) != nil))

                            
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        XCTAssert(error.asAFError?.responseCode == 404)
                        
                    }
                }
                
            case .failure:
                
                print(response.error?.localizedDescription as Any)
            }
            
            
        }
        
        
    }
    
    func testGetPopularMoviesForPage() {
           
           
        let pg = 1
           print(pg)
           let selectedLanguage = languageValues.hebrew.rawValue
           let urlString = "\(requestURLs.getPopularMovie)\(selectedLanguage)&page=\(pg)"
           AF.request(urlString).responseJSON { (response) in
               
               switch(response.result) {
                   
               case .success:
                   
                   
                   if let data = response.data {
                       do {
                           
                           let decoder = JSONDecoder()
                           let responseArray = try decoder.decode(Result.self, from: data)
                           DispatchQueue.main.async {
                               
                               XCTAssert((responseArray.results as Any) is [Movie])
                               XCTAssert(responseArray.results!.count > 0)
                            
                            let movie = responseArray.results?.first
                            XCTAssert(movie?.poster_path != nil)
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
    
    func testGetVideos() {
           
           let id = 828
           let urlString = "\(requestURLs.getMovieVideos)\(id)/videos?api_key=\(APIKeys.moviesDBKey)&language=en-US"
           AF.request(urlString).responseJSON { (response) in
               
               switch(response.result) {
                   
               case .success:
                   
                   if let data = response.data {
                       do {
                           
                           let decoder = JSONDecoder()
                           let responseObject = try decoder.decode(MovieDetails.self, from: data)
                           
                           DispatchQueue.main.async {
                               
                            
                            XCTAssert((responseObject.results as Any) is MovieDetails)

                            for movieVideo in responseObject.results! {
                                   
                                XCTAssert(movieVideo.key != "")
                                let movieId = Int(movieVideo.id!)
                                XCTAssert(movieId == id)

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
    
    func testPerformanceExample() {
        
        var requestResults = Genres()
        
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            
            //            var requestResults = Genres()
            
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
    }
    
    
    
}
