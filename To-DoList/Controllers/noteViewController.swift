//
//  noteViewController.swift
//  To-DoList
//
//  Created by Sujata on 27/11/19.
//  Copyright © 2019 Sujata. All rights reserved.
//

import UIKit
import CoreData

class noteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var itemTitle:String? = nil
    var type:String? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //loadCategories(itemTitle!)
    }
    

    @IBAction func btnSaveTapped(_ sender: UIButton)
    {
        if let title = itemTitle
        {
            if (textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0)
            {
                let newNote = Note(context: self.context)
                newNote.note = textView.text!
                //newNote.category = title
            
                self.saveNotes()
            }
        }
        
    }
    
    
    @IBAction func btnCancelTapped(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadCategories(_ name:String)
    {
        do
        {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            let categoryPredicate = NSPredicate(format: "name MATCHES %@", name)
            request.predicate = categoryPredicate

            let category = try context.fetch(request)
            print(category)
        }
        catch
        {
            print("Error loading categories:\(error)")
        }
    }
    
    func saveNotes()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving notes: \(error)")
        }
    }
    
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
//    func loadItems()
//    {
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate
//        {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }
//        else
//        {
//            request.predicate = categoryPredicate
//        }
//
//        do
//        {
//            itemArray = try context.fetch(request)
//        }
//        catch
//        {
//            print("Error fetching data from context:\(error)")
//        }
//        tableView.reloadData()
//    }
 
}
