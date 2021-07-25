//
//  BookService.swift
//  SXMBooks
//
//  Created by Laxman Penmetsa on 7/24/21.
//

import Foundation
enum GeneralError: Error, LocalizedError {
    case somethingWentWrong
    case errorDescription(String)
    case error(Error)
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias ResultCallBack<T> = (Result<T>) -> Void

protocol BookServiceProtocol {
    func getBooksForSearch(text: String, completion: ResultCallBack<Books>?)
}

class BookService: BookServiceProtocol {
    
    let apiKey = "AIzaSyDimx8YuCYoYG29bI37E8TdGe8GhUaDj4k"
    
    func getBooksForSearch(text: String, completion: ResultCallBack<Books>?) {
        // handling whitespaces in search text
        let urlText = text.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(urlText)&key=\(apiKey)"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.fetchBooksTask(with: url) { (books, response, error) in
                if let error = error{
                    DispatchQueue.main.async {
                        completion?(.failure(GeneralError.error(error)))
                    }
                    return
                }
                if let books = books {
                    completion?(.success(books))
                } else {
                    completion?(.failure(GeneralError.errorDescription("Books response parse error")))
                }
            }
            task.resume()
        } else {
            completion?(.failure(GeneralError.errorDescription("URL ERROR")))
        }
    }
}


extension URLSession {
    func fetchBooksTask(with url: URL, completionHandler: @escaping (Books?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return codableTask(with: url, completionHandler: completionHandler)
    }
    
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
}
