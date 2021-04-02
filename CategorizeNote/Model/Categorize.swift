//
//  Categorize.swift
//  CategorizeNote
//
//  Created by Yoan on 23/03/2021.
//

import Foundation
import CoreData

protocol CategorizeChoice {
    func renameButton (categorizeName: String)
}


class Categorize: NSManagedObject {
    static var all: [Categorize]{
        let request: NSFetchRequest<Categorize> = Categorize.fetchRequest()
        guard let categorize = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return categorize
    }
}
