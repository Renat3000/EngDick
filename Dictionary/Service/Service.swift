//
//  Service.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 22.10.2023.
//

import Foundation

class Service {
    
    static let shared = Service() //singleton object
    
    func fetchJSON(searchTerm: String, completion: @escaping ([JSONStruct], Error?) -> ()) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchTerm)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            if let err = err {
                print("failed to fetch", err)
                completion([], err)
                return
            }
            
            // success
            guard let data = data else { return }
            
            do {
                let searchResult = try
                    JSONDecoder().decode([JSONStruct].self, from: data)
                
                completion(searchResult, nil)
//                print(searchResult)
                
            } catch let jsonErr {
                print("failed to decode", jsonErr)
                completion([], jsonErr)
            }
            
        }.resume() //fire the request
    }
}
