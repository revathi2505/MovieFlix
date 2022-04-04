//
//  WebServices.swift
//  MovieFlix
//
//  Created by Revathi on 01/04/22.
//

import Foundation
import Alamofire

enum NetworkManageError: Error {
    case badResponse(URLResponse)
    case badData
}

fileprivate struct APIResponse: Codable {
    let results: [Movie]
}

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private let session: URLSession
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    private var images = NSCache<NSString, NSData>()
    
    private let nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"

    //MARK: - Download Images
    private func image(for imageUrl: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        
        if let imageData = images.object(forKey: imageUrl.absoluteString as NSString) {
            completion(imageData as Data, nil)
            return
        }
       
        let task = session.downloadTask(with: imageUrl) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, error)
                return
            }
            
            guard let localUrl = localUrl else {
                completion(nil, error)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                self.images.setObject(data as NSData, forKey: imageUrl.absoluteString as NSString)
                completion(data,nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
        
    }
    
    func posterImage(for movie: Movie, completion: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: "https://image.tmdb.org/t/p/w342" + movie.posterPath)!
        image(for: url, completion: completion)
    }
    
    func backdropImage(for movie: Movie, completion: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: "https://image.tmdb.org/t/p/original" + movie.backdropPath)!
        image(for: url, completion: completion)
    }
    
    //MARK: - Get Movies
    func getNowPlayingMovies(completion: @escaping ([Movie]?, Error?) -> (Void)) {
        var request = URLRequest(url: URL(string: nowPlayingUrl)!)
        request.timeoutInterval = 30
        
         AF.request(request)
                   .responseDecodable(of: APIResponse.self) { [weak self] response in
                       print("decoded response:", response)
                       guard let playingMovies = response.value else {
                           completion(nil, response.error)
                           return
                       }
                       completion(playingMovies.results, nil)
                   }
    }
    
}
