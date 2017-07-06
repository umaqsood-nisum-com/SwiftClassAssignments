//
//  CoreDataExtension.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/19/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation


enum EntityType {
    case Bin
    case Item
    case Location
}


extension EntityBase    {
    
    var entityType:EntityType?   {
        get {
            return EntityBase.entityTypeFromString(value: entityTypeValue!)
        }
        set {
            self.entityTypeValue = String(describing:newValue!)
        }
    }
    
    static func entityTypeFromString(value:String) -> EntityType?    {
        switch value {
        case String(describing:EntityType.Bin) : return EntityType.Bin
        case String(describing:EntityType.Item) : return EntityType.Item
        case String(describing:EntityType.Location) : return EntityType.Location
        default: return nil
        }
    }
    
    func setPropertiesFrom(jsonDictionary: Dictionary<String, Any>)  {
        for (key, value) in jsonDictionary {
            // If property exists
            if (self.responds(to: Selector(key)))  {
                print("Setting: \(key)")
                if let stringValue = value as? String   {
                    print("String value: \(stringValue)")
                    self.setValue(stringValue, forKey: key)
                }
                if let numberValue = value as? NSNumber   {
                    print("Number value: \(numberValue)")
                    self.setValue(numberValue, forKey: key)
                }
            }
        }
    }
    
    
}
