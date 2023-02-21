//
//  ViewController.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentTimeZoneLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let newItem = Item()
        newItem.location = "test"
        itemArray.append(newItem)

        let currentTimeZone = TimeZone.current
        let currentTimeZoneCity = currentTimeZone.identifier.split(separator: "/").last!
        currentTimeZoneLabel.text = String(currentTimeZoneCity)
    }
    
    @IBAction func findButtonPressed(_ sender: UIBarButtonItem) {
        print("finding times!")
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTimes", sender: self)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].location
        return cell
    }
    
}
    

