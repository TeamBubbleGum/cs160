//
//  Service.swift
//  myUnloadIOS
//
//  Created by Cagan Sevencan on 4/10/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import Foundation


class Service: NSObject {
    static let shared = Service()
    
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> ()) {
        guard let url = URL(string: "http://localhost:3000/item") else { return }
        
        var fetchItemsRequest = URLRequest(url: url)
        fetchItemsRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        URLSession.shared.dataTask(with: fetchItemsRequest) { (data, resp, err) in
            DispatchQueue.main.async { //Whenever we fetch after its done dispatch it- for threading
                if let err = err {
                    print("Failed to fetch items:", err)
                    return
                }
                
                guard let data = data else { return }
                
                print(String(data: data, encoding: .utf8) ?? "")
                
                do {
                    let items = try JSONDecoder().decode([Item].self, from: data)
                    completion(.success(items))
                    print("Fetched items successfully")
                } catch {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
    
    func createItem(name: String, desc: String, weight: String, dimen: String, seller: String, zip: String, completion: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:3000/item") else { return }
        
        var urlRequest = URLRequest(url: url)  //declare urlRequest, and feed in url
        urlRequest.httpMethod = "POST"
        
        let params = ["name": name, "desc": desc, "weight": weight, "dimen": dimen, "seller": seller, "zip": zip]
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            urlRequest.httpBody = data  //this httpBody sent along with request!!
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")  //need to set a header for JSON
                
            URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
                // check error

                guard let data = data else { return }
                print(String(data: data, encoding: .utf8) ?? "")
                
                completion(nil)
                
                }.resume() // never forget this
        } catch {
            completion(error)
        }
    }
    
    func deletePost(id: String, completion: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:3000/item/\(id)") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
            DispatchQueue.main.async { //Everythings going to occur in the main thread for smoother response
                if let err = err {
                    completion(err)
                    return
                }
                //When we hit 404 in order to catch it:
                if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {  //if response is not 200 then it shouls show error
                    let errorString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    completion(NSError(domain: "", code: resp.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                    return
                }
                
                completion(nil)
                
            }
            // check error
            
            }.resume() // i always forget this
    }
}
