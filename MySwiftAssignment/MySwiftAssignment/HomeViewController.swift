//
    //  HomeViewController.swift
//  MySwiftAssignment
//
//  Created by Nisum Technologies on 18/07/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let segmentBottomBorder = CALayer()
    let depositExpected: Float = 0.40
    var totalAmount : Double = 0.00

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewB: UIView!
    @IBOutlet weak var keyBoardView: UIView!
    
    @IBOutlet weak var lblDepositExpected: UILabel!
    @IBOutlet weak var lblVariance: UILabel!
    @IBOutlet weak var lblActualDeposit: UILabel!
    
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    weak var selectedTextField : setTextField!
    weak var activeTextField : setTextField!

    weak var selectedLabel : UILabel!
    var textFields : [setTextField] = [setTextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Count Cash Deposit - #302"
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: myNotificationKey),
                                               object: nil,
                                               queue: nil,
                                               using:catchNotification)
        
        
        
        containerViewB.isHidden = true
        segmentedControl.layer.cornerRadius = 0.0
        segmentedControl.tintColor = UIColor.clear
        
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)

        
        segmentBottomBorder.borderColor = UIColor( red: 19/255, green: 118/255, blue:200/255, alpha: 1.0 ).cgColor
        segmentBottomBorder.borderWidth = 3
        let width: CGFloat = segmentedControl.frame.size.width/2
        
        let x = CGFloat(segmentedControl.selectedSegmentIndex) * width
        let y = segmentedControl.frame.size.height - (segmentBottomBorder.borderWidth)
        segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
        segmentedControl.layer.addSublayer(segmentBottomBorder)
        
        setTextFields()
        // Do any additional setup after loading the view.
    }
    
    func setTextFields(){
        if containerViewA.isHidden{
        
            for view  in containerViewB.subviews  {
                if let txtField : setTextField = view as? setTextField{
                    self.textFields.append(txtField )
                }
            }
        } else{
            for view  in containerViewA.subviews  {
                if let txtField : setTextField = view as? setTextField{
                    self.textFields.append(txtField )
                }
            }
        }
    }
        
    func setTextFieldColor(color : UIColor){
        selectedTextField.setBottomBorder(color: color.cgColor)
        selectedLabel.textColor = color
    }
    
    /// Notification
    func catchNotification(notification:Notification) -> Void {
        
        
        
        let xPosition = keyBoardView.frame.origin.x
        
        //View will slide up
        let yPosition = self.view.frame.size.height - 360
        
        let height = keyBoardView.frame.size.height
        let width = keyBoardView.frame.size.width
            
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.keyBoardView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            
        })
        
        let tag :Int = notification.userInfo!["txtId"] as!Int
        print(tag)
        if tag == 1 {
            btnPrevious.isEnabled = false
            btnPrevious.alpha = 0.5;
        }
        else if tag >= 1 {
            btnPrevious.isEnabled = true
            btnPrevious.alpha = 1.0;

        }
        if tag == 17 {
            btnNext.isEnabled = false
            btnNext.alpha = 0.5;
        }
        else {
            btnNext.isEnabled = true
            btnNext.alpha = 1.0;
            
        }
        
        if selectedTextField != nil{
            selectedTextField.rightView = nil
            selectedTextField.rightViewMode = .never
            let color = (selectedTextField.text?.isEmpty)! ? selectedTextField.greyColor : selectedTextField.blueColor
            setTextFieldColor(color: color)
            selectedTextField.layer.removeAllAnimations()
            
            
        }
        selectedTextField = textFields.filter({ (textField) -> Bool in
            return textField.tag == tag
        }).first
        if !containerViewB.isHidden{
            
            selectedLabel = containerViewB.viewWithTag(tag) as! UILabel
            
        } else {
            
            selectedLabel = containerViewA.subviews.filter({ (view) -> Bool in
                return view.isKind(of: UILabel.self)
            }).first as! UILabel
        }
	        
        let color : UIColor = notification.userInfo!["color"] as! UIColor
        
        setTextFieldColor(color: color)
        countTotalValues()

    }
    

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
        
        
        totalAmount = 0.0
        lblActualDeposit.text = "-"
        lblVariance.text = "-$0.40"

        
        let labels = (sender.selectedSegmentIndex == 0) ? containerViewA.subviews.filter { (view) -> Bool in
            return view.isKind(of: UILabel.self)
            
            } as! [UILabel] : containerViewB.subviews.filter { (view) -> Bool in
                return view.isKind(of: UILabel.self)
        }as! [UILabel]
        
        for textfield in textFields{
            textfield.setBottomBorder(color: UIColor.darkGray.cgColor)
            textfield.text = ""
        
        }
        textFields.removeAll()
        print(labels)
        for label in labels{
            
        
            label.textColor = UIColor.darkGray
        }
        if selectedTextField != nil {
            
            selectedTextField.removeAddClearButton(add: false)
            selectedTextField.setBottomBorder(color: UIColor.darkGray.cgColor)
        }
        if sender.selectedSegmentIndex == 0 {
            
                UIView.animate(withDuration: 0.5, animations: {
                self.containerViewB.isHidden = true
                self.containerViewA.isHidden = false
                self.setTextFields()


            })
        } else {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                
                self.containerViewB.isHidden = false
                self.containerViewA.isHidden = true
                self.setTextFields()

                
            })
        }
        
        segmentBottomBorder.borderColor = UIColor( red: 19/255, green: 118/255, blue:200/255, alpha: 1.0 ).cgColor
        segmentBottomBorder.borderWidth = 3
        let width: CGFloat = sender.frame.size.width/2

        let x = CGFloat(sender.selectedSegmentIndex) * width
        let y = sender.frame.size.height - (segmentBottomBorder.borderWidth)
        segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
        sender.layer.addSublayer(segmentBottomBorder)
        
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

    
    @IBAction func keyBoardNumberPress(sender : UIButton){
        
        if selectedTextField != nil {
            
            selectedTextField.text = selectedTextField.text! + (sender.titleLabel?.text)!
            
            let txtValue = Float(selectedTextField.text!)
            
            print(txtValue! - depositExpected)
            lblVariance.text = String(txtValue! - depositExpected)
            
            lblActualDeposit.text = formatCurrency(value: Double(selectedTextField.text!)!)
            lblVariance.text = formatCurrency(value: Double(txtValue! - depositExpected))
            if selectedTextField.text?.characters.count == 1{
                selectedTextField.removeAddClearButton(add: true)
            }
            
            countTotalValues()

        }
        
    }
    func countTotalValues() {
        
        totalAmount = 0.0

        if !containerViewB.isHidden{

            for textfield in textFields{
                if textfield.text != nil && !((textfield.text?.isEmpty)!){

                    
                    if textfield.tag == 1 {totalAmount += Double(textfield.text!)! / 100
                    }
                    else if textfield.tag == 2 { totalAmount += Double(textfield.text!)! * 5/100
                    }
                    else if textfield.tag == 3 { totalAmount += Double(textfield.text!)! * 10/100
                    }
                    else if textfield.tag == 4 {totalAmount += Double(textfield.text!)! * 25/100
                    }
                    else if textfield.tag == 5 { totalAmount += Double(textfield.text!)! * 50/100
                    }
                    else if textfield.tag == 6 { totalAmount += Double(textfield.text!)!
                    }
                    else if textfield.tag == 7 { totalAmount += Double(textfield.text!)! * 50/100
                    }
                    else if textfield.tag == 8 { totalAmount += Double(textfield.text!)! * 2
                    }
                    else if textfield.tag == 9 {totalAmount += Double(textfield.text!)! * 5
                    }
                    else if textfield.tag == 10 {totalAmount += Double(textfield.text!)! * 10
                    }
                    else if textfield.tag == 11 { totalAmount += Double(textfield.text!)! * 1
                    }
                    else if textfield.tag == 12 {totalAmount += Double(textfield.text!)! * 2
                    }
                    else if textfield.tag == 13 {totalAmount += Double(textfield.text!)! * 5
                    }
                    else if textfield.tag == 14 {totalAmount += Double(textfield.text!)! * 10
                    }
                    else if textfield.tag == 15 {totalAmount += Double(textfield.text!)! * 20
                    }
                    else if textfield.tag == 16 {totalAmount += Double(textfield.text!)! * 50
                    }
                    else if textfield.tag == 17 {totalAmount += Double(textfield.text!)! * 100
                    }
                    


                    
                    print("Total", totalAmount)
                }
                lblActualDeposit.text = formatCurrency(value: Double(totalAmount))
                lblVariance.text = formatCurrency(value: Double(totalAmount - Double(depositExpected)))
                

            }
        }
    }
    
    
    ////// Test Case
    func testTotalValues(textField : UITextField)-> Double {
        
        totalAmount = 0.0
        if textField.text != nil && !((textField.text?.isEmpty)!){
            
            if textField.tag == 1 {
                totalAmount += Double(textField.text!)! - Double(depositExpected)
            }
            
            
        }
        return totalAmount

    }
    
    
    func formatCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
    
    @IBAction func keyboardDeletePress(sender : UIButton){
        if !(selectedTextField.text?.isEmpty)! && selectedTextField != nil {
            let text = selectedTextField.text
            let endIndex = text?.index((text?.endIndex)!, offsetBy: -1)
            selectedTextField.text =  selectedTextField.text?.substring(to: endIndex!)
            if (selectedTextField.text?.isEmpty)!{
                selectedTextField.removeAddClearButton(add: false)
                
                lblActualDeposit.text = "-"
                lblVariance.text = "-$0.40"
            }
            else
            {
                let txtValue = Float(selectedTextField.text!)
                
                print(txtValue! - depositExpected)
                lblVariance.text = String(txtValue! - depositExpected)
                
                lblActualDeposit.text = formatCurrency(value: Double(selectedTextField.text!)!)
                lblVariance.text = formatCurrency(value: Double(txtValue! - depositExpected))
            }
            
            countTotalValues()


            
        }
    }

    @IBAction func txtNextPrevious(sender : UIButton) {
        
        
        print(sender.tag)
        if sender.tag == 0 {
            let textfield = self.textFields.filter({ (textfield) -> Bool in
                return textfield.tag == selectedTextField.tag - 1
            }).first
            textfield?.becomeFirstResponder()
        }
        else
        {
        print("next & previous")
        print(selectedTextField.tag)
        
        let textfield = self.textFields.filter({ (textfield) -> Bool in
            return textfield.tag == selectedTextField.tag + 1
        }).first
            textfield?.becomeFirstResponder()

        }

    }
    
    @IBAction func keyBoardDown(_ sender: Any) {
        let xPosition = keyBoardView.frame.origin.x
        
        //View will slide 20px up
        let yPosition = self.view.frame.size.height - 70
        
        let height = keyBoardView.frame.size.height
        let width = keyBoardView.frame.size.width
        
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.keyBoardView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            
        })
    }
}
extension Float {
    var convertAsLocaleCurrency :String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }
}

