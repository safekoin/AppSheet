//
//  ObjectAPI.swift
//  AppSheetDemo
//
//  Created by mac on 9/7/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct PersonAPI {
    
    var id: Int
    var base = "https://appsheettest1.azurewebsites.net/sample/detail/"
    //init struct based on id
    init(id: Int) {
        self.id = id
    }
    
    //return optional url for person API request
    var getUrl: URL? {
        return URL(string: base + "\(id)")
    }
}
