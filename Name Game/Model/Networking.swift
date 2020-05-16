//
//  Networking.swift
//  Name Game
//
//  Created by Michal Hus on 5/16/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import Foundation

class Networking {
    
    class func getTrees(completion: @escaping ([Tree]?, String?) -> ()){
        let urlString = "https://willowtreeapps.com/api/v1.0/profiles/"
        let url = URL(string: urlString)
        
        _ = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    DispatchQueue.main.async {
                        completion(nil, error!.localizedDescription)
                    }
                    return
            }
            
            let decoder = JSONDecoder()
            let treesResponse = try! decoder.decode([Tree].self, from: data)
            DispatchQueue.main.async {
                let filteredTreesResponse = treesResponse.filter { $0.headshot.url != nil }
                let randomTreeSubSet = Array(filteredTreesResponse.shuffled().prefix(6))
                completion(randomTreeSubSet, nil)
            }
        }.resume()
    }
}
