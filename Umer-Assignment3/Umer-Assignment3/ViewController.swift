//
//  ViewController.swift
//  Umer-Assignment3
//
//  Created by Nisum Technologies on 13/06/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem?.title = "Add Location"
        btnSave.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)

        txtBin.delegate = self
        txtBin.allowsEditingTextAttributes = false
        txtLocation.delegate = self
        myPicker.delegate = self
        myPicker.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var txtBin: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var myPicker: UIPickerView!
    

    var binDataPicker = ["My Bin One", "My Bin Two", "My Bin Three"]

    var locationDataPicker = ["My Location One", "My Location Two", "My Location Three"]

    var pickerData = [String]()
    enum EntityType {
        case Bin
        case Location
    }

    var pickerRowSelectedHandler: ((Int) -> Void)?

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
        
        self.pickerRowSelectedHandler = {(selectedIndex:Int) -> Void in
            var entityType: EntityType?
            switch textField {
            case self.txtLocation:
                entityType = EntityType.Location
                self.txtLocation.text = self.pickerData[selectedIndex]
            case self.txtBin:
                entityType = EntityType.Bin
                self.txtBin.text = self.pickerData[selectedIndex]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

