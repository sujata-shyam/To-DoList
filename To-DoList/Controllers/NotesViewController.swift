//
//  NotesViewController.swift
//  To-DoList
//
//  Created by Sujata on 29/11/19.
//  Copyright © 2019 Sujata. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController
{
    @IBOutlet weak var titleTextView: UITextView!
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedCategory:Category? {
        didSet
        {
            loadItems()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func btnSaveTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton)
    {
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving notes:\(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
        request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        do
        {
            let notes = try context.fetch(request)
            print(notes)
        }
        catch
        {
            print("Error fetching data from context:\(error)")
        }
    }
    
    
}
