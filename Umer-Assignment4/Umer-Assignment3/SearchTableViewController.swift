//
//  SearchTableViewController.swift
//  Umer-Assignment3
//
//  Created by Umer Khan on 6/17/17.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, LocationProtocol {

    var entity:EntityBase?
    private var entityArray = [EntityBase]()
    var name: String?

    private var filteredEntityArray = [EntityBase]()
    let searchController = UISearchController(searchResultsController: nil)
    let allScope = "All"
    var currentScope:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.title = "Item Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler(sender:)))
        self.loadTableData()
        currentScope = allScope
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = [allScope, "Item", "Bin", "Location"]
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadTableData()    {
        
        entityArray.append(Item(name: "Mobile", qty:1, bin: Bin(name: "Top Shelf", location: Location(name: "Shop"))))
        entityArray.append(Item(name: "Books", qty:12, bin: Bin(name: "Cabnet", location: Location(name: "Room"))))
        entityArray.append(Item(name: "Car", bin: Bin(name: "Parking", location: Location(name: "Office"))))
        entityArray.append((entityArray[0] as! Item).bin!)
        entityArray.append((entityArray[1] as! Item).bin!)
        entityArray.append((entityArray[2] as! Item).bin!)
        entityArray.append((entityArray[0] as! Item).bin!.location!)
        entityArray.append((entityArray[1] as! Item).bin!.location!)
        entityArray.append((entityArray[2] as! Item).bin!.location!)
        filteredEntityArray = entityArray
    }

    func cancelHandler(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        filteredEntityArray = entityArray.filter({[weak self] ( entity : EntityBase) -> Bool in
            self!.currentScope = scope
            let entityTypeMatch = (self!.currentScope == self!.allScope || String(describing:entity.entityType!) == scope)
            let name = entity.name!.lowercased()
            print("\(String(describing:entity.entityType!)) \(name) entityTypeMatch: \(entityTypeMatch) searchTextMatch: \(searchText == "" || entity.name!.lowercased().contains(searchText.lowercased()))")
            return entityTypeMatch && (searchText == "" || entity.name!.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredEntityArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
        let entity:EntityBase? = filteredEntityArray[indexPath.row]
        cell.textLabel?.text = entity!.name!
        if let item = entity as? Item? {
            cell.detailTextLabel?.text = "Bin: \(item!.bin!.name!), Location: \(item!.bin!.location!.name!)"
        } else if let bin = entity as? Bin? {
            cell.detailTextLabel?.text = "Location: \(bin!.location!.name!)"
        }
        else if let location = entity as? Location? {
            cell.detailTextLabel?.text = "(\(String(describing: location!.entityType!)))"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.entity = filteredEntityArray[indexPath.row]
        print("\((self.entity!.name)! ) selected")
        self.performSegue(withIdentifier: "unwindToAddItem", sender: self)
    }
    
}
extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
