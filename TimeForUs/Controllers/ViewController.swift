//
//  ViewController.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-20.
//

import UIKit
import CoreData
import SwipeCellKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentTimeZoneLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadItems()
        tableView.register(UINib(nibName: "LocationTimeCell", bundle: nil), forCellReuseIdentifier: "ReuseableCell")
        tableView.rowHeight = 80.0

        let currentTimeZone = TimeZone.current
        let currentTimeZoneCity = currentTimeZone.identifier.split(separator: "/").last!
        currentTimeZoneLabel.text = String(currentTimeZoneCity)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
        tableView.reloadData()
    }
    
    @IBAction func findButtonPressed(_ sender: UIBarButtonItem) {
        print("finding times!")
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTimes", sender: self)
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }

           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               self.context.delete(self.itemArray[indexPath.row])
               self.itemArray.remove(at: indexPath.row)
               self.saveItems()
           }
           deleteAction.image = UIImage(named: "delete-icon")

           return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath) as! LocationTimeCell
        cell.delegate = self
        cell.label.text = itemArray[indexPath.row].name
        cell.time.text = "Current Time"
        return cell
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
}
    

