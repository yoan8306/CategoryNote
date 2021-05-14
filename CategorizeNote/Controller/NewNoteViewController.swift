//
//  NewNoteViewController.swift
//  CategorizeNote
//
//  Created by Yoan on 26/03/2021.
//

import UIKit

class NewNoteViewController: UIViewController, CategorizeChoice {
    var note = NoteData()
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBAction func didPressCategoryButton() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CreateCategorieViewController") as? CreateCategorieViewController {
                    vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
                }
    }
    
    @IBOutlet weak var newTitleField: UITextField!
    @IBOutlet weak var newDescriptionField: UITextView!
    
    @IBAction func saveButton() {
        let title = newTitleField.text
        let description = newDescriptionField.text
        let category = getCategorize()
        if category != nil && title != "" && description != "" {
            note.save(titleNote: title, descriptionNote: description, category: category)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func renameButton(categorizeName: String) {
        categoryButton.setTitle(categorizeName, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newDescriptionField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
           }

           @objc func tapDone(sender: Any) {
               self.view.endEditing(true)
    }
    
    
    
    private func presentAlert (alertTitle title: String, alertMessage message: String,buttonTitle titleButton: String, alertStyle style: UIAlertAction.Style ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    private func getCategorize() -> Categorize? {
        let category = Categorize.all
     for stringCategory in category {
        if stringCategory.title == String(categoryButton.currentTitle!) {
                return stringCategory
        } else {
            presentAlert(alertTitle: "Erreur", alertMessage: "Veuillez sélectionner une catégorie", buttonTitle: "Ok", alertStyle: .default)
        }
     }
        return nil
    }
}

extension NewNoteViewController: UITextViewDelegate, UITextFieldDelegate {
     func textViewDidBeginEditing(_ textView: UITextView) {
        if newDescriptionField.textColor == UIColor.lightGray {
            newDescriptionField.text = nil
            newDescriptionField.textColor = UIColor.blue
        }
    }
    
  func textViewDidEndEditing(_ textView: UITextView) {
        if newDescriptionField.text.isEmpty {
            newDescriptionField.text = "Description"
            newDescriptionField.textColor = UIColor.lightGray
        }
    }

   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if newTitleField.isFirstResponder {
            newDescriptionField.becomeFirstResponder()
        } else {
            note.save(titleNote: newTitleField.text, descriptionNote: newDescriptionField.text, category: getCategorize())
            dismiss(animated: true, completion: nil)
        }
        return true
    }
}
