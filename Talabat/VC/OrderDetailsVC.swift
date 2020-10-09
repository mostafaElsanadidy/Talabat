//
//  OrderDetailsVCT.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/4/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
//    var order_indx: Int?
//    var rstaurant_indx: Int?
//    var restaurantOrders_Details: GetRestaurantOrders_Details?
    var orderProducts = [orderProducts_Details]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        
//        order_indx = UserDefaults.standard.integer(forKey: "order_indx")
//        let data = UserDefaults.standard.data(forKey: "restaurantOrdr_Details")
//         self.restaurantOrders_Details = try! JSONDecoder().decode(GetRestaurantOrders_Details.self, from: data!)
//        orderDetails = restaurantOrders_Details!.return![order_indx!].order_details!
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getRestaurantOrders(){
//        APIClient.getRestaurantOrders
    }
}
    // MARK: - Table view data source

    
    extension OrderDetailsVC:UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderProducts.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)

        if let customCell = cell as? CustomOrderDetailsCell
        {
            customCell.configureCell(with: orderProducts[indexPath.row])
        }
        // Configure the cell...

        return cell
    }
    
}

