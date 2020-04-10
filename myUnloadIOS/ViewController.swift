//
//  ViewController.swift
//  myjournal_ios_lbta
//
//  Created by Cagan Sevencan on 3/25/20.
//  Copyright © 2019 Cagan Sevencan. All rights reserved.
//

import UIKit

struct Item: Decodable {
   let _id: String
    let name, desc: String
    let zip, dimen, weight: String
    let seller: String
}

class Service: NSObject {
    static let shared = Service()
    
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> ()) {
        guard let url = URL(string: "http://localhost:3000/item") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            DispatchQueue.main.async { //Whenever we fetch after its done dispatch it
                if let err = err {
                    print("Failed to fetch items:", err)
                    return
                }
                
                guard let data = data else { return }
                
                print(String(data: data, encoding: .utf8) ?? "")
                
                do {
                    let items = try JSONDecoder().decode([Item].self, from: data)
                    completion(.success(items))
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
                
                }.resume() // i always forget this
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

class ViewController: UITableViewController {
    
    fileprivate func fetchItems() {
        Service.shared.fetchItems { (res) in
            switch res {
            case .failure(let err):
                print("Failed to fetch items:", err)
            case .success(let items):
               print(items)
                self.items = items
                self.tableView.reloadData()
            }
        }
    }
    
    var items = [Item]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = .yellow
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.desc
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Items"
        navigationItem.rightBarButtonItem = .init(title: "Add an Item", style: .plain, target: self, action: #selector(handleCreateItem))
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete an Item")
            let item = self.items[indexPath.row]
           
            Service.shared.deletePost(id: item._id) { (err) in
                if let err = err {
                    print("Failed to delete:", err)
                    return
                }
                
                print("Successfully deleted the item from server")
                //self.fetchItems()  -- Reload the entire table
                self.items.remove(at: indexPath.row)  //also have to remove it from the arrau
                self.tableView.deleteRows(at: [indexPath], with: .automatic)  //deleting a particular index path //.automatic for the animation
            }
            
            
        }
    }
    
    @objc fileprivate func handleCreateItem() {
        print("Creating an item")
        Service.shared.createItem(name: "IOS TITLE2", desc: "IOS ITEM BODY", weight: "3lbs", dimen: "2 x 4 x 4", seller: "2424", zip: "95123" ) { (err) in   //make a call to the service class
            if let err = err {
                print("Failed to create an item object:", err)
                return
            }
            
            print("Finished creating an item")
            self.fetchItems()
        }
    }


}

