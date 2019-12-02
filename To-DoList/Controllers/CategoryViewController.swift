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
    //var indexToEdit:Int?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.tableView.estimatedRowHeight = 44.0

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedTableView))
        
        tableView.addGestureRecognizer(longPressRecognizer)
        loadCategories()
        
//        if let index = indexToEdit
//        {
//            let category = categories[index]
//        }
    }

    @objc func longPressedTableView(sender:UILongPressGestureRecognizer)
    {
        if(sender.state == .began)
        {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint)
            {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                //performSegue(withIdentifier: "goToItems", sender: tableView)
                performSegue(withIdentifier: "goToNotes", sender: tableView)
            }
        }
    }
    
//    @IBAction func addNoteButtonPressed(_ sender: UIButton)
//    {
//        var textField = UITextField()
//        
//        let alert = UIAlertController(title: "Add Category Note", message: "", preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            
////            let newCategory = Category(context: self.context)
////            newCategory.name = textField.text!
////
////            self.categories.append(newCategory)
////            self.saveCategories()
//        }
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            self.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(cancel)
//
//        alert.addAction(action)
//        
//        alert.addTextField { (field) in
//            textField = field
//            
//            textField.placeholder = "Note"
//        }
//        present(alert, animated: true, completion: nil)
//    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? categoryTableViewCell
        
        cell?.lblTitle.text = categories[indexPath.row].name
        
        //cell.textLabel?.text = categories[indexPath.row].name
        cell?.accessoryType = categories[indexPath.row].done ? .checkmark : .none
        
        return cell!
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        categories[indexPath.row].done = !categories[indexPath.row].done
        
        saveCategories()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let notesVC = segue.destination as? NotesViewController
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                notesVC.selectedCategory = categories[indexPath.row]
            }
        }
        else if let toDoVC = segue.destination as? ToDoListViewController
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                toDoVC.selectedCategory = categories[indexPath.row]
            }
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

    fileprivate func createAddAlertAction()
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            newCategory.done = false
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem)
    {
        createAddAlertAction()
    }
    
    //Override to support conditional editing of the table view.
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
//    {
//        //Return false if you do not want the specified item to be editable.
//        return true
//    }
    
    //Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
//    {
//        if editingStyle == .delete
//        {
//            //Delete the row from the data source
//            context.delete(categories[indexPath.row])
//
//            categories.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            saveCategories()
//
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return UITableView.automaticDimension
//    }
    
    //MARK: - Cell Swipe Actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let categoryTitle = categories[indexPath.row].name
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed:@escaping (Bool)->() ) in
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this task: \(categoryTitle!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
        
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                
                self.deleteCategory(index: indexPath.row)
                tableView.reloadData()
                actionPerformed(true)
            }))
            self.present(alert, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, actionPerformed:@escaping (Bool)->Void)
            in
            
            let alert = UIAlertController(title: "Edit", message: "Are you sure you want to edit this task?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
            
            var textField =  UITextField()
            
            alert.addTextField(configurationHandler: { (field) in
                textField = field
                textField.text = self.categories[indexPath.row].name
            })
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
                self.categories[indexPath.row].name = textField.text
                self.saveCategories()
                
                actionPerformed(true)
            }))
            
            self.present(alert, animated: true)
        }
        edit.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func deleteCategory(index:Int)
    {
        //Delete the row from the data source
        context.delete(categories[index])
        categories.remove(at: index)
        saveCategories()
    }
    
}

//extension CategoryViewController: UITextViewDelegate
//{
//    func textViewDidChange(_ textView: UITextView)
//    {
//        UIView.setAnimationsEnabled(false)
//        textView.sizeToFit()
//        self.tableView.beginUpdates()
//        self.tableView.endUpdates()
//        UIView.setAnimationsEnabled(true)
//    }
//}
