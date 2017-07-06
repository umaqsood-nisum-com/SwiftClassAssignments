//
//  SearchTableViewController.swift
//  Umer-Assignment3
//
//  Created by Umer Khan on 6/17/17.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController {
    @IBOutlet weak var refreshHandler: UIRefreshControl!
    
    var entity:EntityBase?
    private var filteredEntityArray = [EntityBase]()
    var fetchedResultsController: NSFetchedResultsController<Item>!
    let backgroundDataCoordinator:BackgroundDataCoordinator = BackgroundDataCoordinator()
    
    let searchController = UISearchController(searchResultsController: nil)
    let allScope = "All"
    var currentScope:String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeFetchedResultsController()
        navigationController!.navigationBar.topItem?.title = "Item Search View"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler(sender:)))
        self.loadTableData()
        currentScope = allScope
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Referesh")
        self.tableView.refreshControl = refreshControl
        self.refreshControl?.addTarget(self, action: #selector(SearchTableViewController.refreshHandler(_:)), for: .valueChanged)
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = [allScope, String(describing: EntityType.Item), String(describing: EntityType.Bin), String(describing: EntityType.Location)]
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func initializeFetchedResultsController() {
        let coreDataFetch:CoreDataFetch = CoreDataFetch()
        fetchedResultsController = coreDataFetch.getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchResultControllerPerform()
    }
    
    
    func fetchResultControllerPerform(){
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch{
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    func loadTableData()    {
        
        backgroundDataCoordinator.requestAndLoadEntities(objectType: "item", completionHandler: {[unowned self](success) -> Void in
            if self.refreshHandler != nil{
                self.refreshHandler.endRefreshing()
            }
            if success{
            } else{
            }
            
        })
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
        let item = self.fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = "\(item?.entityTypeValue ?? "<none>"): \((item?.name!)!)"
        cell.detailTextLabel?.text = "Bin: \(item?.itemToBinFK?.name ?? "<none>"), Location: \(item?.itemToBinFK?.binToLocationFK?.name ?? "<none>")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.entity = filteredEntityArray[indexPath.row]
        self.entity = fetchedResultsController.object(at: indexPath)
        print("\(String(describing: self.entity?.name!)) selected")
        self.performSegue(withIdentifier: "unwindToAddItem", sender: self)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        
    }
    
    @IBAction func refreshHandler(_ sender: UIRefreshControl) {
        loadTableData()
    }
    
    func cancelHandler(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        var predicate : NSPredicate?
        if searchBar.scopeButtonTitles![selectedScope] == "All" {
            
            predicate = ((searchBar.text!.isEmpty ) ? nil : NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!))
        } else {
            if searchBar.text!.isEmpty{
                predicate = NSPredicate(format: "entityTypeValue == %@", searchBar.scopeButtonTitles![selectedScope])
            } else {
                predicate = NSPredicate(format: "entityTypeValue == %@ && name CONTAINS[cd] %@ ", searchBar.scopeButtonTitles![selectedScope],searchBar.text!)
                
            }
        }
        self.fetchedResultsController.fetchRequest.predicate = predicate
        self.fetchResultControllerPerform()
        tableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.fetchedResultsController.fetchRequest.predicate = nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate : NSPredicate?
        if searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex] == "All" {
            
            predicate = ((searchBar.text!.isEmpty ) ? nil : NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!))
        } else {
            if searchBar.text!.isEmpty{
                predicate = NSPredicate(format: "entityTypeValue == %@", searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
            } else {
                predicate = NSPredicate(format: "entityTypeValue == %@ && name CONTAINS[cd] %@ ", searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex],searchBar.text!)
            }
        }
        self.fetchedResultsController.fetchRequest.predicate =  predicate
        self.fetchResultControllerPerform()
        tableView.reloadData()
        
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        var predicate : NSPredicate?
        if searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex] == "All" {
            
            predicate = ((searchBar.text!.isEmpty ) ? nil : NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!))
        } else {
            if searchBar.text!.isEmpty{
                predicate = NSPredicate(format: "entityTypeValue == %@", searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
            } else {
                predicate = NSPredicate(format: "entityTypeValue == %@ && name CONTAINS[cd] %@ ", searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex],searchBar.text!)
            }
        }
        self.fetchedResultsController.fetchRequest.predicate =  predicate
        self.fetchResultControllerPerform()
        tableView.reloadData()
        
    }
}



extension SearchTableViewController:NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        if self.refreshControl != nil && self.refreshControl!.isRefreshing   {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

