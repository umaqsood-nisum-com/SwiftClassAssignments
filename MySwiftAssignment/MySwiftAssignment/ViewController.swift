//
//  ViewController.swift
//  MySwiftAssignment
//
//  Created by Nisum Technologies on 18/07/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
                // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnCashDeposit(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "HomeView")
        VC1.title = "Home"
        self.navigationController?.pushViewController(VC1, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

