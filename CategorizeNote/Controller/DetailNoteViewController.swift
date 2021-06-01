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
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
        do {
            try AppDelegate.viewContext.save()
        } catch  {
            
        }
    }
    
    @IBAction func cancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDetailNote()
        noteDescriptionHideKeyboard()
        titleFieldHideKeyboard()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            noteDescriptionField.contentInset = .zero
        } else {
            noteDescriptionField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        noteDescriptionField.scrollIndicatorInsets = noteDescriptionField.contentInset

        let selectedRange = noteDescriptionField.selectedRange
        noteDescriptionField.scrollRangeToVisible(selectedRange)
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
