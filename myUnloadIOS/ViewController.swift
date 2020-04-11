//
//  ViewController.swift
//  
//
//  Created by Cagan Sevencan on 3/25/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit

struct Item: Decodable {
   let _id: String
    let name, desc: String
    let zip, dimen, weight: String
    let seller: String
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
        navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    @objc fileprivate func handleLogin(){
        print("Performs login and refetch items list")
        // fire off a login request to server of localhost - backend
        guard let url = URL(string: "http://localhost:3000/login") else {return}
        
        var loginRequest = URLRequest(url: url)  //typecasting to URLRequest - takes in above url object
        loginRequest.httpMethod = "POST"
        
        let params = ["email" : "cagansvncn@gmail.com", "password": "12345"]
        do{
            //Passing params as our object
            loginRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options:  .init())
            
            //When we use this, it keeps Session information inside of the cookies in IOS app
            URLSession.shared.dataTask(with: loginRequest) { (data, resp, err) in
               //check error
                if let err = err{
                    print("Failed to login:", err)
                    return
                }
                print("Logged in successfully")
                //self.fetchItems()
            }.resume() //don't forget!
        }catch{
            print("Failed to serialize data:", error)
        }
        
        
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
                self.items.remove(at: indexPath.row)  //also have to remove it from the array
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

