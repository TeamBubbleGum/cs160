//
//  ViewController.swift
//  
//
//  Created by Cagan Sevencan on 3/25/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit



class ViewController: UITableViewController {
    
    fileprivate func fetchItems() {
        Service.shared.fetchItems { (res) in
            //To test the result, do a switch statement
            switch res {
            case .failure(let err):
                print("Failed to fetch items:", err)
            case .success(let items):
              // print(items)
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
        //navigationItem.rightBarButtonItem = .init(title: "Add an Item", style: .plain, target: self, action: #selector(handleCreateItem))
        //navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
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
}

