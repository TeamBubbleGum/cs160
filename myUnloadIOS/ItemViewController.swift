//
//  ItemViewController.swift
//  myUnloadIOS
//
//  Created by Cagan Sevencan on 4/11/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit

struct Item: Decodable {
   let _id: String
    let name, desc: String
    let zip, dimen, weight: String
    let seller: String
}

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
     func fetchItems() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fetchItems()
        //Delegate pattern: Two objects acting in coordination, tableView and ItemViewController
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       //After finishing composing, refresh the TableView to pull the new Item
        super.viewDidAppear(animated)
        
        self.fetchItems()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        let item = items[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.descLabel.text = item.desc
        cell.sellerLabel.text = item.weight
        cell.zipLabel.text = item.zip
         
        return cell
       }
    
    
    @objc func onTimer() {
       //Refresh Items
        
    }
    
    
}
