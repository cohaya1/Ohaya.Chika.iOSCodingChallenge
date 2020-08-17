//
//  NetworkManager.swift
//  Ohaya.Chika.iOSCodingChallenge
//
//  Created by Makaveli Ohaya on 8/15/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//
import UIKit
import Foundation

class BookListClient {
    enum NetworkMethods: String {
            case GET
            case POST
            case PUT
            case DELETE
            case PATCH
        }
        
        static let shared = BookListClient()// Using a singleton for just this project this is not my regular practice
        
        

         let baseURL = "https://de-coding-test.s3.amazonaws.com/books.json"
        
        let cache = NSCache<NSString, UIImage>()// initialize NSCache to download image
        private init () {
            
        }
    
    typealias completionHandler = (Result<BookLists,ErrorMessages>) -> Void
    
        static func createRequest(method: NetworkMethods, url: URL) -> URLRequest {
               var request = URLRequest(url: url)
               request.httpMethod = method.rawValue
               return request
           }
        
    func getBookListInfo( completed: @escaping (Result<[BookLists], ErrorMessages>) -> Void) {
            let endPoint = baseURL //initialize endpoint
              
               guard let url = URL(string: endPoint) else {
                   completed(Result.failure(.invalid))
                   return
               }
            let request = BookListClient.self.createRequest(method: .GET, url: url) // create get request method
               
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                   if let _ = error {
                       completed(Result.failure(.unableToComplete))
                   }
                   
                   guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                       completed(Result.failure(.invalidResponse))
                       return
                   }
                   
                   guard let data = data else {
                       completed(Result.failure(.invalidData))
                       return
                   }
                   
                   do {
                       let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase // specifies the type of decoding
//                    decoder.dateDecodingStrategy = .iso8601
                    let bookinfo = try decoder.decode([BookLists].self, from: data)
                    
                   
                    completed(Result.success(bookinfo))
                        
                    
                   } catch  {
                        print(error)
                       completed(Result.failure(.invalidData))
                   }
            }
               task.resume()
           }
    
        func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
            let cacheKey = NSString(string: urlString)
            if let image = cache.object(forKey: cacheKey) {
                completed(image)
                return
            }
            
            guard let url = URL(string: urlString) else {
                completed(nil)
                return
            }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                    error == nil,
                    let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let data = data,
                    let image = UIImage(data: data) else {
                        completed(nil)
                        return
                }
                
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            }
            task.resume()
        }
    }


