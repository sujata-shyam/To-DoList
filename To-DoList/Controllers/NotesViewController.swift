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
    @IBOutlet weak var noteTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var globalNote:Notes? = nil
    var globalNoteText:String? = nil
    var isNew = true
    
//    var selectedCategory:Category? {
//        didSet
//        {
//            loadUpdateNotes()
//        }
//    }
    
    var selectedCategory = Category()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadUpdateNotes()
        setContent()
    }

//    func saveChanges() {
//        let newNote = Notes(context: self.context)
//
//        if(isNew)
//        {
//            newNote.parentCategory = self.selectedCategory
//            newNote.note = noteTextView.text
//            isNew = false
//
//            self.saveNotes()
//        }
//        else
//        {
//            loadUpdateNotes(isUpdate:true)
//        }
//    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton)
    {
        //saveChanges()

        let newNote = Notes(context: self.context)
        
        if(isNew)
        {
            newNote.parentCategory = self.selectedCategory
            newNote.note = noteTextView.text
            isNew = false
            
            self.saveNotes()
        }
        else
        {
            loadUpdateNotes(isUpdate:true)
        } //navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton)
    {
        noteTextView.text = globalNote?.note
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton)
    {
        //Delete the row from the data source
        if globalNote != nil
        {
            context.delete(globalNote!)
            saveNotes()
            noteTextView.text = nil
        }
    }
    
    @IBAction func btnExitTapped(_ sender: UIButton)
    {
        //Delete the row from the data source
        if globalNote != nil
        {
            context.delete(globalNote!)
            saveNotes()
        }
    }
    //MARK: - Model Manipulation Methods
    
    func saveNotes()
    {
        if context.hasChanges
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
    }
    
    func loadUpdateNotes(with request: NSFetchRequest<Notes> = Notes.fetchRequest(), predicate: NSPredicate? = nil, isUpdate:Bool = false)
    {
        if(isUpdate == false)
        {
            request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory.name!)
            do
            {
                let notes = try context.fetch(request)
                if(notes.count>0)
                {
                    isNew = false
                    globalNote = notes[0]
                }
            }
            catch
            {
                print("Error fetching data from context:\(error)")
            }
        }
        else
        {
            print(globalNote)
            globalNote?.setValue(noteTextView.text, forKey: "note")
            saveNotes()
        }
    }
    
    func setContent()
    {
        titleTextView.text = selectedCategory.name
        if(globalNote != nil)
        {
            if let note = globalNote?.note
            {
                noteTextView.text = note
            }
        }

    }
}
