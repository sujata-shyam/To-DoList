//
//  ViewController.swift
//  To-DoList
//
//  Created by Sujata on 19/11/19.
//  Copyright © 2019 Sujata. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController
{
    let itemArray = ["ABCD", "EFGH", "IJKL"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .none)
        {
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

