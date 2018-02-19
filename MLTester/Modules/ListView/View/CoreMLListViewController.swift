//
//  CoreMLListViewController.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 09.01.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class CoreMLListViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let models = CoreMLProvider.instance.getMLModelArray()
    
    public var dismissBlock: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }

    fileprivate func setCornerRadius() {
        self.mainView.layer.cornerRadius = 20.0
        self.mainView.layer.masksToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        setCornerRadius()
    }

    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismissBlock?()
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TableView
extension CoreMLListViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let model = self.models[indexPath.row]
        cell.textLabel?.text = model.name
        let selectedModel = CoreMLProvider.instance.getSelectedModel()
        
        if selectedModel?.name == model.name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        CoreMLProvider.instance.setMLModel(model)
        self.tableView.reloadData()
    }
    
}

