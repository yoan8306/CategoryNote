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

