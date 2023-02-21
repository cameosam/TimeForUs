//
//  TableViewController.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-20.
//

import UIKit

class TableViewController: UITableViewController {
    
    var timeZoneBrain = TimeZoneBrain()
    var allLocations = [TimeZoneItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        allLocations = timeZoneBrain.getTimeZones()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeZoneCell", for: indexPath)
        cell.textLabel?.text = String(allLocations[indexPath.row].name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Timezone", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
           
            let newTimeZone = Item()
            newTimeZone.location = self.allLocations[indexPath.row].location
            newTimeZone.name = textField.text!
//           save location to core data
        }

        alert.addAction(action)

        alert.addTextField { (field) in
            textField = field
            textField.text = String(self.allLocations[indexPath.row].name.split(separator: ",").first!)
        }

        present(alert, animated: true, completion: nil)
    }
}


//MARK: - Search bar methods
extension TableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            allLocations = timeZoneBrain.getTimeZones().filter{$0.name.contains(searchBar.text!)}
        } else {
            allLocations = timeZoneBrain.getTimeZones()
        }
        tableView.reloadData()
    }
}