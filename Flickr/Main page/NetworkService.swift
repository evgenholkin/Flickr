//
//  NetworkService.swift
//  Flickr
//
//  Created by Евгений Холкин on 06.06.2020.
//  Copyright © 2020 Евгений Холкин. All rights reserved.
//

import Foundation

class NetworkService {
    
    func getData(_ tag: String, completion: @escaping ([Items]?) -> Void) {
        
        let urlString = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=" + tag
       
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            let decoder = JSONDecoder()
            guard let data = data else {
                print("no data")
                return
            }
            print(data)
            
            do {
                let response = try decoder.decode(PhotosListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.items)
                }
            } catch {
                print("decoding error")
                completion(nil)
            }
        }.resume()
    }
}

struct PhotosListResponse: Codable {
    let items: [Items]?
}
