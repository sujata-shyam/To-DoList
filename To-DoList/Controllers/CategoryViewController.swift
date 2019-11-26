//
//  CategoryViewController.swift
//  To-DoList
//
//  Created by Sujata on 25/11/19.
//  Copyright © 2019 Sujata. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController
{
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadCategories()
    }

    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    //MARK: - Data manipulation methods

    func saveCategories()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest())
    {
        do
        {
            categories = try context.fetch(request)
        }
        catch
        {
            print("Error loading categories:\(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories

    @IBAction func barButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)

        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //Override to support conditional editing of the table view.
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        //Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //Delete the row from the data source
            context.delete(categories[indexPath.row])
            
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveCategories()
            
        }
    }

}
