//
//  Constants.swift
//  iMovies
//
//  Created by Maria Davidenko on 16/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import Foundation


struct Global {
    
    public static let EMPTY_STRING = ""
    public static let kSelectedLanguage = "SelectedLanguage"
    public static let kAppleLanguages = "AppleLanguages"
}
struct APIKeys {
    
    public static let moviesDBKey = "6ad67231fcf622e0470ac4def8d8213f"
}

struct requestURLs {
    
    public static let getGenres = "https://api.themoviedb.org/3/genre/movie/list?api_key=6ad67231fcf622e0470ac4def8d8213f&language="
    public static let getPopularMovie = "https://api.themoviedb.org/3/movie/popular?api_key=6ad67231fcf622e0470ac4def8d8213f&language="
    public static let getMovieVideos = "https://api.themoviedb.org/3/movie/"
    public static let imageBaseUrl = "https://image.tmdb.org/t/p/original"
}

struct SegueIdentifiers {
    
    
    public static let GoToGenres = "LaunchToGenresSegueIdentifier"
    public static let GoToPopularMovies = "GenresToMoviesSegueIdentifier"
    public static let GoToMovieDetails = "MovieToMovieDetailsSegueIdentifier"
    public static let GoToTrailers = "MovieDetailsToTrailersSegueIdentifier"
}

struct CellId {
    
    public static let IMTrailerCollectionViewCell = "IMTrailerCollectionViewCellId"
    
}

enum VideoSiteTypes : String {
    
    case YouTube = "YouTube"
    case Vimeo = "Vimeo"
}

enum VideoTypes : String {
    case trailer = "Trailer"
    case teaser = "Teaser"
    case clip = "Clip"
    case featurette = "Featurette"
    
}

enum TrailerSearchType : String {
    
    case official = "Official"
}

enum languages : String {
    
    case english = "EN"
    case hebrew = "HE"
}

enum languageCodes: Int {
    
    case english = 0
    case russian = 1
    case hebrew = 2
}

enum languageValues: String {
    
    case english = "en-US"
    case russian = "ru-RUS"
    case hebrew = "he-he"
    case appleEnglish = "en"
    case appleHebrew = "he"
    case appleRussina = "ru"
}
