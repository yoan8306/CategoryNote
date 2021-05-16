//
//  NoteData.swift
//  CategorizeNote
//
//  Created by Yoan on 23/03/2021.
//

import Foundation
import CoreData

class NoteData: NSManagedObject {
    //static var all : [NoteData] {
    static var all : [[NoteData]] {
        let request: NSFetchRequest<NoteData> = NoteData.fetchRequest()
      request.sortDescriptors = [
        NSSortDescriptor(key: "categorize.title", ascending: true)]
        guard let noteData = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return noteData.convertedToArrayofArray
    }
}

extension Array where Element == NoteData {
    var convertedToArrayofArray: [[NoteData]] {
        var dict = [Categorize: [NoteData]]()
        
        for noteData in self where noteData.categorize != nil {
            dict[noteData.categorize!, default: []].append(noteData)
                 }
        
        var result = [[NoteData]] ()
        for (_ , val) in dict {
            result.append(val)
        }
        return result
    }
}

extension NoteData {
    func save (titleNote: String?, descriptionNote: String?, category: Categorize?) {
        guard let title = titleNote, let description = descriptionNote, let category = category  else {
            return }
        
        let addNote = NoteData(context: AppDelegate.viewContext)
        let currentDate = Date()
        addNote.title = title
        addNote.noteDescription = description
        addNote.dateTime = currentDate
        addNote.categorize = category
       
       do {
            try AppDelegate.viewContext.save()
        } catch {
    }
}
}

extension NoteData {
   
    func serach (search: String) {
         var result : [[NoteData]] {
            let request :NSFetchRequest<NoteData> = NoteData.fetchRequest()
            request.value(forUndefinedKey:search )
            guard let result = try? AppDelegate.viewContext.fetch(request) else {
                return []
            }
            return result.convertedToArrayofArray
        }
    }
}
