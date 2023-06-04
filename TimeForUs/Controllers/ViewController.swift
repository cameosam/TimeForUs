//
//  ViewController.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-20.
//

import UIKit
import CoreData

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
        loadDefaultLocation()
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
        currentTime = Date()
        loadDefaultLocation()
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
    
    func loadDefaultLocation(){
        if itemArray.count == 0 {
            let currentTimeZone = TimeZone.current
            let newTimeZone = Item(context: context)
            newTimeZone.location = currentTimeZone.identifier
            newTimeZone.name = String(currentTimeZone.identifier.split(separator: "/").last!)
            saveItems()
        }
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
            let location = self.itemArray[indexPath.row].location!
            let clean_location = location.replacingOccurrences(of: "_", with: " ").components(separatedBy: "/")
            let city = clean_location.last! as String
            let region = clean_location.first! as String
            let abv = TimeZone(identifier: location)!.abbreviation()! as String
            let name = "\(city), \(region) (\(abv))"
            textField.placeholder = name
        }
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                self.context.delete(self.itemArray[indexPath.row])
                self.itemArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.saveItems()
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath) as! LocationTimeCell
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
