//
//  ListNotesViewController.swift
//  CategorizeNote
//
//  Created by Yoan on 23/03/2021.
//

import UIKit

class ListNotesViewController: UIViewController {
    let notes = NoteData.all
    var filteringNotes = NoteData.all
    var note = NoteData()
    var refreshControl = UIRefreshControl()
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uISearchBarField: UISearchBar!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteringNotes = NoteData.all
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        filteringNotes = NoteData.all
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        filteringNotes = NoteData.all
        tableView.reloadData()
    }
    @IBAction func searchBarButton(_ sender: Any) {
        if uISearchBarField.isHidden {
            uISearchBarField.isHidden = false
        } else {
            uISearchBarField.isHidden = true
        }
    }
}


extension ListNotesViewController: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteringNotes.count
        //return notes.count // nombre de catégorie
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // return 1 // nombre de ligne par catégorie
       return filteringNotes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCellTableViewCell else {
            return UITableViewCell()
        }
         note = filteringNotes[indexPath.section][indexPath.row]
        cell.configure(title: note.title ?? "Sans titre" , description: note.noteDescription ?? "Sans detail" , date: note.dateTime ?? Date())
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let titleCategory = filteringNotes[section].first?.categorize, let categorie = titleCategory.title else {
        return nil
        }
        var totalNote = 0
        for _ in filteringNotes[section] {
            totalNote += 1
        }
        return categorie + ": \(totalNote)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         note = filteringNotes[indexPath.section][indexPath.row]
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
            let commit = filteringNotes[indexpath.section][indexpath.row]
            AppDelegate.viewContext.delete(commit)
            filteringNotes[indexpath.section].remove(at: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .automatic)
            try? AppDelegate.viewContext.save()
        }
    }
}

extension ListNotesViewController: UISearchBarDelegate {
  
}

