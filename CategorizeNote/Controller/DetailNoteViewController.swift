//
//  DetailNoteViewController.swift
//  CategorizeNote
//
//  Created by Yoan on 14/05/2021.
//

import UIKit

class DetailNoteViewController: UIViewController {
    var noteDetailSelected  = NoteData()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteDescriptionField: UITextView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    @IBAction func saveButton() {
        noteDetailSelected.noteDescription = noteDescriptionField.text
        noteDetailSelected.title = titleField.text
        do {
            try AppDelegate.viewContext.save()
        } catch  {
            
        }
    }
    
    @IBAction func cancelButton() {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDetailNote()
        noteDescriptionHideKeyboard()
        titleFieldHideKeyboard()
    }
    
    private func initialiseDetailNote() {
        titleField.text = noteDetailSelected.title
        noteDescriptionField.text = noteDetailSelected.noteDescription
    }
    private func titleFieldHideKeyboard() {
        self.titleField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
           }

           @objc func tapDone(sender: Any) {
               self.view.endEditing(true)
    }
    
    private func noteDescriptionHideKeyboard() {
        self.noteDescriptionField.addDoneButton(title: "Done", target: self, selector: #selector(doneBar(sender:)))
           }

           @objc func doneBar(sender: Any) {
               self.view.endEditing(true)
    }

}
