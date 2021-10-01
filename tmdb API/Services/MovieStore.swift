//
//  MovieStore.swift
//  tmdb API
//
//  Created by Gustavo Fernandes da Cruz Lima on 28/09/21.
//

import Foundation

class MovieStore: MovieService {

    static let shared = MovieStore()
    private init(){}
    
    private let apiKey = "90d62a1c4132cb271b0c6f53a5794bdb"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder

    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)")else{
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)")else{
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response":"videos,credits"
        ], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie/")else{
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language":"en-US",
            "include_adult":"false",
            "region":"US",
            "query":query,
        ], completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) ->()){
        guard var urlComponents  = URLComponents(url: url, resolvingAgainstBaseURL: false) else{
                completion(.failure(.invalidEndpoint))
                return
            }
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map{ URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL){ [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil{
                self.executeCompletionHadlerMainThread(with: .failure(.apiError), completion: completion)
                completion(.failure(.apiError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else{
                self.executeCompletionHadlerMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else{
                self.executeCompletionHadlerMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do{
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHadlerMainThread(with: .success(decodedResponse), completion: completion)
            }catch{
                self.executeCompletionHadlerMainThread(with: .failure(.serializationError), completion: completion)
            }
            
        }.resume()
        
        }
    
    private func executeCompletionHadlerMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping(Result<D, MovieError>) -> ()){
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
