// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct MovieData: Decodable {
    public let adult: Bool
    public let backdrop_path: String?
    public let genre_ids: [Int]
    public let id: Int
    public let original_language: String
    public let original_title: String
    public let overview: String
    public let popularity: Double
    public let poster_path: String?
    public let release_date: String
    public let title: String
    public let video: Bool
    public let vote_average: Double
    public let vote_count: Int
    public init(adult: Bool, backdrop_path: String?, genre_ids: [Int], id: Int, original_language: String, original_title: String, overview: String, popularity: Double, poster_path: String?, release_date: String, title: String, video: Bool, vote_average: Double, vote_count: Int) {
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.genre_ids = genre_ids
        self.id = id
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.release_date = release_date
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
}

public struct MovieResponse: Decodable {
    public let page: Int
    public let results: [MovieData]
    public let total_pages: Int
    public let total_results: Int
    public init(page: Int, results: [MovieData], total_pages: Int, total_results: Int) {
        self.page = page
        self.results = results
        self.total_pages = total_pages
        self.total_results = total_results
    }
}

public enum TMDBSwift {
    public static func requestMovieSearch(searchQuery: String, token: String) async throws -> [MovieData] {
        var components = URLComponents(string: "https://api.themoviedb.org/3/search/movie")!
        components.queryItems = [
            URLQueryItem(name: "query", value: searchQuery),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "page", value: "1")
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return movieResponse.results
    }
}
