//
//  Model.swift
//  Todoye
//
//  Created by PavelM on 22/02/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    var value: String = ""
    var done: Bool = false
    
    var dictionary: Dictionary <String, Bool>  = [:]
    
    var set: Set <String> = []

}
