//
//  ViewController.swift
//  myjournal_ios_lbta
//
//  Created by Cagan Sevencan on 3/25/20.
//  Copyright © 2019 Cagan Sevencan. All rights reserved.
//

import UIKit

struct Item: Decodable {
    let id: Int
    let title, body: String
    let zip, dimensions, weight: String
}

class Service: NSObject {
    static let shared = Service()
    
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> ()) {
        guard let url = URL(string: "http://localhost:1337/items") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to fetch items:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let items = try JSONDecoder().decode([Item].self, from: data)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
    func createItem(title: String, body: String, completion: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:1337/item") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let params = ["title": title, "itemBody": body]
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
                
            URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
                // check error
                
                guard let data = data else { return }
                
                completion(nil)
                
                }.resume() // i always forget this
        } catch {
            completion(error)
        }
    }
    
    func deletePost(id: Int, completion: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:1337/item/\(id)") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(err)
                    return
                }
                
                if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
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
//                print(items)
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
//        cell.backgroundColor = .red
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.body
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
            Service.shared.deletePost(id: item.id) { (err) in
                if let err = err {
                    print("Failed to delete:", err)
                    return
                }
                
                print("Successfully deleted the item from server")
                self.items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    @objc fileprivate func handleCreateItem() {
        print("Creating an item")
        Service.shared.createItem(title: "4444", body: "5555") { (err) in
            if let err = err {
                print("Failed to create an item object:", err)
                return
            }
            
            print("Finished creating an item")
            self.fetchItems()
        }
    }


}

