//
//  ListNotesViewController.swift
//  CategorizeNote
//
//  Created by Yoan on 23/03/2021.
//

import UIKit

class ListNotesViewController: UIViewController {
    var notes = NoteData.all
    var note = NoteData()
   
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailNoteDataView: UIView!
    @IBOutlet weak var titleNoteDetail: UITextField!
    @IBOutlet weak var noteDescriptionTextView: UITextView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = NoteData.all
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        notes = NoteData.all
        tableView.reloadData()
    }
}


extension ListNotesViewController: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return notes.count
        //return notes.count // nombre de catégorie
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // return 1 // nombre de ligne par catégorie
       return notes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCellTableViewCell else {
            return UITableViewCell()
        }
         note = notes[indexPath.section][indexPath.row]
        cell.configure(title: note.title ?? "Sans titre" , description: note.noteDescription ?? "Sans detail" , date: note.dateTime ?? Date())
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let titleCategory = notes[section].first?.categorize, let categorie = titleCategory.title else {
        return nil
        }
        var totalNote = 0
        for _ in notes[section] {
            totalNote += 1
        }
        return categorie + ": \(totalNote)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         note = notes[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "DetailNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailNote" {
            let noteSelectedVC = segue.destination as! DetailNoteViewController
            noteSelectedVC.noteDetailSelected = note
        }
    }
}
 
extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexpath: IndexPath) {
        if editingStyle == .delete {
            let commit = notes[indexpath.section][indexpath.row]
            AppDelegate.viewContext.delete(commit)
            notes[indexpath.section].remove(at: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .automatic)
            try? AppDelegate.viewContext.save()
        }
    }
}
