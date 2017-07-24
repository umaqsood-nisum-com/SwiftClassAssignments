//
//  CustomBorders.swift
//  MySwiftAssignment
//
//  Created by Nisum Technologies on 18/07/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import Foundation
import UIKit



extension UISegmentedControl {
    func setBottomBorder(indexNo: Int) {
        

        if indexNo == 0{
            let segmentBottomBorder = CALayer()

            segmentBottomBorder.borderColor = UIColor( red: 19/255, green: 118/255, blue:200/255, alpha: 1.0 ).cgColor
            segmentBottomBorder.borderWidth = 3
            let width: CGFloat = self.frame.size.width/2
            
            let x = CGFloat(indexNo) * width
            let y = self.frame.size.height - (segmentBottomBorder.borderWidth)
            segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
            self.layer.addSublayer(segmentBottomBorder)
            
            
            let segmentBottomBorder2 = CALayer()
            
            segmentBottomBorder2.borderColor = UIColor.darkGray.cgColor
            segmentBottomBorder2.borderWidth = 2
            let width2: CGFloat = self.frame.size.width/2
            
            let x2 = CGFloat(1) * width
            let y2 = self.frame.size.height - (segmentBottomBorder.borderWidth)
            segmentBottomBorder.frame = CGRect(x: x2, y: y2, width: width2, height: (segmentBottomBorder.borderWidth))
            self.layer.addSublayer(segmentBottomBorder2)
            
        }
        else if indexNo == 1{
                let segmentBottomBorder = CALayer()
                
                segmentBottomBorder.borderColor = UIColor( red: 19/255, green: 118/255, blue:200/255, alpha: 1.0 ).cgColor
                segmentBottomBorder.borderWidth = 3
                let width: CGFloat = self.frame.size.width/2
                
                let x = CGFloat(1) * width
                let y = self.frame.size.height - (segmentBottomBorder.borderWidth)
                segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
                self.layer.addSublayer(segmentBottomBorder)
                
                
                let segmentBottomBorder2 = CALayer()
                
                segmentBottomBorder2.borderColor = UIColor.darkGray.cgColor
                segmentBottomBorder2.borderWidth = 2
                let width2: CGFloat = self.frame.size.width/2
                
                let x2 = CGFloat(0) * width
                let y2 = self.frame.size.height - (segmentBottomBorder.borderWidth)
                segmentBottomBorder.frame = CGRect(x: x2, y: y2, width: width2, height: (segmentBottomBorder.borderWidth))
                self.layer.addSublayer(segmentBottomBorder2)
                
            }
        
        
    }
}
