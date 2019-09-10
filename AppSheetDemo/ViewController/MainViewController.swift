//
//  ViewController.swift
//  AppSheetDemo
//
//  Created by mac on 9/7/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMain()
    }

    private func setupMain() {
        //register XIB to table view
        mainTableView.register(UINib(nibName: PersonTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: PersonTableCell.identifier)
        //set viewmodel as personService delegate
        personService.delegate = viewModel
        viewModel.getList()
        //set view model delegate as self
        viewModel.delegate = self
        //remove unused table view cells
        mainTableView.tableFooterView = UIView(frame: .zero)
    }

}

//MARK: TableView
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.youngestPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableCell.identifier, for: indexPath) as! PersonTableCell
        let person = viewModel.youngestPeople[indexPath.row]
        cell.person = person
        return cell
    }
    
    
    
}
extension MainViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: ViewModelDelegate {
    
    func update() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
}
