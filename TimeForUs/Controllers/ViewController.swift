//
//  ViewController.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-20.
//

import UIKit
import CoreData
import SwipeCellKit

class ViewController: UIViewController, CustomCellUpdater {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadItems()
        tableView.register(UINib(nibName: "LocationTimeCell", bundle: nil), forCellReuseIdentifier: "ReuseableCell")
        tableView.rowHeight = 70.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTimes", sender: self)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        let rows = itemArray.count-1
        if (rows > -1) {
            for row in 0...rows {
                context.delete(itemArray[row])
            }
            itemArray = [Item]()
        }
        
        let currentTimeZone = TimeZone.current
        let newTimeZone = Item(context: context)
        newTimeZone.location = currentTimeZone.identifier
        newTimeZone.name = String(currentTimeZone.identifier.split(separator: "/").last!)
        
        saveItems()
        currentTime = Date()
        loadItems()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var textField = UITextField()
        let alert = UIAlertController(title: "Rename \(itemArray[indexPath.row].name!)", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemArray[indexPath.row].name = textField.text!
            self.saveItems()
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = String(self.itemArray[indexPath.row].location!.split(separator: ",").first!)
        }
        
        present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath) as! LocationTimeCell
        cell.delegate = self
        cell.updaterDelegate = self
        cell.label.text = itemArray[indexPath.row].name
        cell.datePicker.timeZone = TimeZone(identifier: itemArray[indexPath.row].location!)
        cell.datePicker.date = currentTime
        return cell
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func updateTableView(date: Date) {
        currentTime = date
        tableView.reloadData()
    }
    
}
