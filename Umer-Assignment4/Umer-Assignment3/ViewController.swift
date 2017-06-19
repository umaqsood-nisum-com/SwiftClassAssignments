//
//  ViewController.swift
//  Umer-Assignment3
//
//  Created by Nisum Technologies on 13/06/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, LocationProtocol
{

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var txtBin: UITextField!
    @IBOutlet weak var txtItem: UITextField!
    @IBOutlet weak var txtItemQty: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var myPicker: UIPickerView!
    
    var entity:EntityBase?
    var name: String?

    var pickerData = [String]()
    var pickerRowSelectedHandler: ((Int) -> Void)?
    //var locationArray:[String] =  ["Closet","Basement","Storage"]
    //var binArray:[String] = ["Top Shelf","Bottom Drawer","Last Cabinet"]
    
    enum EntityType {
        case Bin
        case Item
        case Location
    }
    var binDataPicker = ["My Bin One", "My Bin Two", "My Bin Three"]
    
    var locationDataPicker = ["My Location One", "My Location Two", "My Location Three"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem?.title = "Add Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchHandler(sender:)))

        self.navigationController?.navigationBar.topItem?.title = "Add Item"
        btnSave.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)

        txtBin.delegate = self
        txtBin.allowsEditingTextAttributes = false
        txtLocation.delegate = self
        myPicker.delegate = self
        myPicker.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    func searchHandler(sender: UIBarButtonItem) {
        print("Search clicked!")
        self.performSegue(withIdentifier: "itemSearchSegue", sender:self )
    }
    @IBAction func addBinLocation(_ sender: Any) {
        let button = sender as! UIButton
        let index = button.tag
        if index == 0 {
            self.showAddEntityAlertView(entityType: .Bin)
            
        }
        else if index == 1{
            self.showAddEntityAlertView(entityType: .Location)
            
        }
    }
    
    
    //// Alert view with Text Field
        
    func showAddEntityAlertView(entityType:EntityType)    {
        let alert = UIAlertController(title: "\(entityType)", message: "Enter \(entityType) name", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "\(entityType) name"}
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak alert, weak self] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text)")
            if entityType == EntityType.Bin {
                //self?.binArray.append(textField.text!)
                self?.binDataPicker.append(textField.text!)

                self?.txtBin.text = textField.text!
                self?.pickerData = (self?.binDataPicker)!

            }
            else if entityType == EntityType.Location {
                self?.locationDataPicker.append(textField.text!)
                self?.txtLocation.text = textField.text
                
                self?.pickerData = (self?.locationDataPicker)!

            }
            self?.myPicker.reloadAllComponents()

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveHandler() {
        
        print(self.txtBin.text!)
        print(self.txtLocation.text!)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRowSelectedHandler!(row)
        self.myPicker.isHidden = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var allowEditing = true
        switch textField {
        case self.txtBin:
            self.pickerData = binDataPicker
            myPicker.reloadAllComponents()
            self.myPicker.isHidden = false
            allowEditing = false

        case self.txtLocation:
            self.pickerData = locationDataPicker
            myPicker.reloadAllComponents()
            self.myPicker.isHidden = false
            allowEditing = false
        default: self.myPicker.isHidden = true

        }
        
        self.pickerRowSelectedHandler = {[weak self](selectedIndex:Int) -> Void in
            var entityType: EntityType?
            switch textField {
            case self!.txtLocation:
                entityType = EntityType.Location
                self!.txtLocation.text = self!.pickerData[selectedIndex]
            case self!.txtBin:
                entityType = EntityType.Bin
                self!.txtBin.text = self!.pickerData[selectedIndex]
            default: break
            }
            print("\(entityType!) selected: \(selectedIndex)")
        }
        return allowEditing;

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "unwindToAddItem" {
                        //let viewController:LocationViewController = segue.destination as! LocationViewController
            
        }
    }
    

    @IBAction func unwindToAddItem(sender: UIStoryboardSegue) {
        
        
        let AddBinViewController = sender.source as! AddBinViewController
        let item = AddBinViewController.name!
        
        self.binDataPicker.append(item)
        txtBin.text = item
        print("Value of add bin Text field - ", item)
        
    }
    
    @IBAction func unwindFromSearch(sender: UIStoryboardSegue) {
        let SearchTableViewController = sender.source as! LocationProtocol
        let entity:EntityBase? = SearchTableViewController.entity
        if let item = entity as? Item? {
            self.entity = item
            self.updateFields(fromItem: item!)
        } else if let bin = entity as? Bin? {
            self.updateFields(fromBin: bin!)
        }
        else if let location = entity as? Location? {
            self.updateFields(fromLocation: location!)
        }
    }
    
    func updateFields(fromItem:Item)    {
        self.txtItem.text = fromItem.name
        if let qty = fromItem.qty   {
            self.txtItemQty.text = String(qty)
        }
        self.txtLocation.text = fromItem.bin?.location?.name
        self.txtBin.text = fromItem.bin?.name
        //self.updateTitle(actionType: ActionType.Update)
    }
    
    func updateFields(fromBin:Bin)    {
        self.txtLocation.text = fromBin.location?.name
        self.txtBin.text = fromBin.name
    }
    
    func updateFields(fromLocation:Location)    {
        self.txtLocation.text = fromLocation.name
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

