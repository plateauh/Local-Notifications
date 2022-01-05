//
//  LogViewController.swift
//  LocalNotifications
//
//  Created by Najd Alsughaiyer on 04/01/2022.
//

import UIKit

class LogViewController: UITableViewController {

    var log = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print(log)
            tableView.reloadData()
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return log.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "log cell", for: indexPath)
        cell.textLabel?.text = log[indexPath.row].0
        cell.detailTextLabel?.text = log[indexPath.row].1
        return cell
    }

}
