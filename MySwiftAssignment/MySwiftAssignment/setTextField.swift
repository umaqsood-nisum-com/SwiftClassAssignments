//
//  myTextFieldClass.swift
//  MySwiftAssignment
//
//  Created by Nisum Technologies on 19/07/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import Foundation
import UIKit


let myNotificationKey = "notificationKey"
class setTextField: UITextField  {
    let blueColor =   UIColor( red: 19/255, green: 118/255, blue:200/255, alpha: 1.0 )
    let greyColor =   UIColor.gray
    var cursorView : UIView!
    var customRightView : UIView!
    var customButtonView : UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        setBottomBorder(color: greyColor.cgColor)
        self.delegate = self
        
        customRightView = UIView(frame: CGRect(x:0, y: 0, width: 2, height: self.frame.height))
        
        cursorView = UIView(frame: CGRect(x:0, y: 0, width: 2, height: self.frame.height))
        cursorView.backgroundColor = blueColor
        
        
        customButtonView = UIButton(frame: CGRect(x: 3, y: self.frame.height/4, width: 15, height: 15))
        customButtonView.addTarget(self, action: #selector(clear(sender:)), for: .touchUpInside)
        
        customButtonView.setImage(UIImage(named:"ClearButton"), for: .normal)
        customRightView.addSubview(cursorView)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        setBottomBorder(color: greyColor.cgColor)
        self.delegate = self
        
        customRightView = UIView(frame: CGRect(x:0, y: 0, width: 2, height: self.frame.height))
        
        cursorView = UIView(frame: CGRect(x:0, y: 0, width: 2, height: self.frame.height))
        cursorView.backgroundColor = blueColor
        
        
        customButtonView = UIButton(frame: CGRect(x: 3, y: self.frame.height/4, width: 15, height: 15))
        customButtonView.addTarget(self, action: #selector(clear(sender:)), for: .touchUpInside)
        
        customButtonView.setImage(UIImage(named:"ClearButton"), for: .normal)
        customRightView.addSubview(cursorView)

        
        
        
    }
    
    
    
    func clear(sender : Any){
        self.text = ""
        removeAddClearButton(add: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: myNotificationKey), object: nil, userInfo: ["txtId":self.tag,"color": greyColor])
    }
    
    func removeAddClearButton(add : Bool){
        
        var frame = customRightView.frame
      
        if add{
            frame.size =  CGSize(width: frame.width + customButtonView.frame.width, height: frame.height)
            customRightView.frame = frame
            customRightView.addSubview(customButtonView)
        } else{
            customButtonView.removeFromSuperview()
            frame.origin =  CGPoint(x: frame.origin.x - 7.5, y: frame.origin.y)
            frame.size =  CGSize(width: frame.width - customButtonView.frame.width, height: frame.height)
            customRightView.frame = frame

        }
    
    }
    
}
extension UITextField {
   
    func setBottomBorder(color : CGColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        //self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
 
}
extension setTextField: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: myNotificationKey), object: textField.tag)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: myNotificationKey), object: nil, userInfo: ["txtId":textField.tag,"color":self.blueColor])
        self.rightViewMode = .unlessEditing
        self.rightView = self.customRightView
        UIView.animate(withDuration: 0.8, delay: 0.4, options: [.curveEaseInOut,.repeat], animations: {
            self.cursorView.alpha = 0.0
        }, completion: { finished in
            //print("Save done")
            
            self.cursorView.alpha = 1.0
        })

   
    
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text?.isEmpty)!{
            setBottomBorder(color: greyColor.cgColor)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: myNotificationKey), object: nil, userInfo: ["txtId":textField.tag,"color": greyColor])
        } else{
        
            setBottomBorder(color: blueColor.cgColor)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: myNotificationKey), object: nil, userInfo: ["txtId":textField.tag ,"color": blueColor])
        }
        
        
            
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setBottomBorder(color: blueColor.cgColor)
    }
    
    

}
