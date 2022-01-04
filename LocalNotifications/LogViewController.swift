//
//  LogViewController.swift
//  LocalNotifications
//
//  Created by Najd Alsughaiyer on 04/01/2022.
//

import UIKit

class LogViewController: UITableViewController {

    var logItems = [(Int, Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return logItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "log cell", for: indexPath)

        // Configure the cell...

        return cell
    }


}
