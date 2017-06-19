//
//  AddBinViewController.swift
//  Umer-Assignment3
//
//  Created by Umer Khan on 6/13/17.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import UIKit

class AddBinViewController: UIViewController, UITextFieldDelegate, LocationProtocol {

    var name: String?
    var entity:EntityBase?

    @IBOutlet weak var txtBin: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtBin.delegate = self
        btnSave.addTarget(self, action: #selector(addBinHandler), for: .touchUpInside)



        // Do any additional setup after loading the view.
    }
    
    func addBinHandler(sender: UIButton) {
        print("Save Button")
        
        self.name = txtBin.text

        self.performSegue(withIdentifier: "unwindToAddItem", sender: self)

        //self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // User finished typing (hit return): hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print("Text Field", txtBin.text!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
