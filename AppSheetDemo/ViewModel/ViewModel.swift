//
//  ViewModel.swift
//  AppSheetDemo
//
//  Created by mac on 9/7/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func update()
}

class ViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    var people = [Person]() {
        didSet {
            //observer to call getYoungest function and set it equal to youngestpeople arr
            youngestPeople = getYoungestPeople(from: people)
        }
    }
    
    var youngestPeople = [Person]() {
        didSet {
            //once youngest people is set, call delegate to update view
            delegate?.update()
        }
    }
    
    
    func getList() {
        personService.getListOf(ppl: [], token: nil)
        
    }
}

extension ViewModel {
    //sort the array based on age and select the first 5 objects
    func getYoungestPeople(from group: [Person]) -> [Person] {
        let youngest = group.sorted(by: {$0.age < $1.age}).prefix(5)
        let sorted = Array(youngest).sorted(by: {$0.name < $1.name})
        return sorted
    }
}

extension ViewModel: PersonDelegate {
    func pass(people: [Person]) {
        self.people = people
        print("Received People: \(self.people.count)")
    }
    
}
