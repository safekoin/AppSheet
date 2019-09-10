//
//  ObjectService.swift
//  AppSheetDemo
//
//  Created by mac on 9/7/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

typealias PersonHandler = (Person?) -> Void
typealias PeopleHandler = ([Person]) -> Void
let personService = PersonService.shared

protocol PersonDelegate: class {
    func pass(people: [Person])
}

final class PersonService {
    
    
    static let shared = PersonService()
    private init() {}
    weak var delegate: PersonDelegate?
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //MARK: Get Person - from id
    private func getPerson(id: Int, completion: @escaping PersonHandler) {
        
        //check if the url is valid
        guard let url = PersonAPI(id: id).getUrl else {
            completion(nil)
            return
        }
        
        //create data task with url
        session.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                print("Bad Data Task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = dat {
                do {
                    //decoding person object
                    let person = try JSONDecoder().decode(Person.self, from: data)
                    completion(person)
                } catch {
                    print("Couldn't Decode Person: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
            }
            
            }.resume()
    }
    
    
    //MARK: Get List - async recursive function
    func getListOf(ppl: [Person], token: String?) {
        
        guard let url = ListAPI(token: token).getListUrl else {
            print("Couldn't Create URL")
            return
        }
        
        
        session.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                print("Bad Data Task: \(error.localizedDescription)")
                return
            }
            if let data = dat {
                
                var people = ppl
                
                do {
                    let dg = DispatchGroup()
                    let list = try JSONDecoder().decode(List.self, from: data)
                    
                    //loop through list from API response
                    for id in list.result {
                        //enter dispatch group
                        dg.enter()
                        self.getPerson(id: id, completion: { psn in
                            if let person = psn {
                                people.append(person)
                
                                //leave dispatch group
                                dg.leave()
                            } else {
                                //leave group in the event that a person can not be created
                                dg.leave()
                            }
                        })
                    }
                    
                    //this is called on completion of dispatch group
                    dg.notify(queue: .global(), execute: {
                        //if the token is not nil, we recursively call GetList Function
                        if list.token != nil {
                            self.getListOf(ppl: people, token: list.token!)
                        } else {
                            //if no token, we received all the people and pass info through delegate
                            self.delegate?.pass(people: people)
                        }
                    })
                    
                } catch {
                    print("Couldn't Decode List: \(error.localizedDescription)")
                    return
                }
            }
            }.resume()
    }
    
    
    
}
