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
            //observer change in people array and once set, set youngestPeople equal to the result of getYoungest function
            youngestPeople = getYoungestPeople(from: people)
        }
    }
    
    var youngestPeople = [Person]() {
        didSet {
            //call delegate to update the view once set
            delegate?.update()
        }
    }
    
    
    func getList() {
        personService.getListOf(ppl: [], token: nil)
        
    }
}

extension ViewModel {
    
    private func getYoungestPeople(from group: [Person]) -> [Person] {
        //sort array based on age, non-decreasing
        let youngest = group.sorted(by: {$0.age < $1.age})
        //choose top 5 youngest people with a valid number
        let valid = topValid(people: youngest)
        //sort array by name in alphabetical order
        let sorted = Array(valid).sorted(by: {$0.name < $1.name})
        return sorted
    }
    
    private func topValid(people: [Person]) -> [Person] {
        var validPeople = [Person]()
        var pointer = 0
        //loop through array while valid people count is less than 5 and our pointer is not out of bounds in array
        while validPeople.count < 5 && pointer < people.count - 1 {
            
            let person = people[pointer]
            //remove all characters except numbers in array
            let number = person.number.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
            //if numbers total equals 10, then it is a valid number
            switch number.count == 10 {
            case true:
                validPeople.append(person)
            case false:
                break
            }
            //increase pointer to continue onto the next iteration
            pointer += 1
        }
        
        
        return validPeople
    }
}

extension ViewModel: PersonDelegate {
    func pass(people: [Person]) {
        self.people = people
        print("Received People: \(self.people)")
    }
    
}
