//
//  ListAPI.swift
//  AppSheetDemo
//
//  Created by mac on 9/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct ListAPI {
    
    
    var token: String?
    var base = "https://appsheettest1.azurewebsites.net/sample/list"
    //init ListAPI with token
    init(token: String?) {
        self.token = token
    }
    
    //if token is nil, we need the default list, if not, we get the correct list for the token
    var getListUrl: URL? {
        switch token == nil {
        case true:
            return URL(string: base)
        case false:
            //if not nil, put token into the url
            return URL(string: base + "?token=\(token!)")
        }
    }
    
    
}
