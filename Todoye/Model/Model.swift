//
//  Model.swift
//  Todoye
//
//  Created by PavelM on 22/02/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Этот протокол нужен если мы хотим кодировать класс в Plist
class Item: Encodable, Decodable {
    
    var value: String = ""
    var done: Bool = false
    

}



