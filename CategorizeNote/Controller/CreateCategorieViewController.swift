//
//  CreateCategorieViewController.swift
//  CategorizeNote
//
//  Created by Yoan on 27/03/2021.
//

import UIKit

class CreateCategorieViewController: UIViewController {
    var delegate: CategorizeChoice?
    var category = Categorize.all
    
    @IBOutlet weak var listCategorieTable: UITableView!
    @IBOutlet weak var newCategorieTextField: UITextField!
    @IBOutlet weak var insertButon: UIButton!
    
    @IBAction func insertCategoryButton() {
        saveNewCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        category = Categorize.all
       drawInsertButton()
    }

    private func drawInsertButton () {
        insertButon.layer.cornerRadius = 8
        insertButon.layer.borderWidth = 1
    }
    
    private func saveNewCategory() {
        guard checkCategory() else {
            return
        }
        let newCategoryText = newCategorieTextField.text?.capitalizingFirstLetter()
        let text = newCategoryText!.trimmingCharacters(in: .whitespaces)
        
        let addCategory = Categorize(context: AppDelegate.viewContext)
        addCategory.title = text
        newCategorieTextField.text = ""
        try! AppDelegate.viewContext.save()
        category = Categorize.all
        listCategorieTable.reloadData()
    }
    
    private func checkCategory () -> Bool {
        let newCategoryText = newCategorieTextField.text?.capitalizingFirstLetter()
       let text = newCategoryText!.trimmingCharacters(in: .whitespaces)
        guard newCategorieTextField.text != "" else {
            presentAlert(alertTitle: "Erreur", alertMessage: "Veuillez renseigner une catégorie", buttonTitle: "Ok", alertStyle: .default)
            return false
        }
        
     for double in category {
         if double.title == text {
                 presentAlert(alertTitle: "Erreur", alertMessage: "Cette catégorie existe déjà", buttonTitle: "Ok", alertStyle: .default)
                 return false
             }
         }
      return true
     }
   
    private func presentAlert (alertTitle title: String, alertMessage message: String,buttonTitle titleButton: String, alertStyle style: UIAlertAction.Style ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}




extension CreateCategorieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorieCell", for: indexPath)
        
        let categoryCell = category[indexPath.row]
        cell.textLabel?.text = categoryCell.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySelectCell = category[indexPath.row]
        delegate?.renameButton(categorizeName: categorySelectCell.title!)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}


extension CreateCategorieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexpath: IndexPath) {
        
        if editingStyle == .delete {
            let commit = category[indexpath.row]
            AppDelegate.viewContext.delete(commit)
           category.remove(at: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .automatic)
           try? AppDelegate.viewContext.save()
        }
    }
}

extension CreateCategorieViewController: UITextFieldDelegate {
    func textFieldShouldReturn (_ textfield: UITextField) -> Bool {
        newCategorieTextField.resignFirstResponder()
        insertCategoryButton()
        return true
    }
}
