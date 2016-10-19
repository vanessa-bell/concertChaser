//
//  Favorite+CoreDataProperties.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/30/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorite {

    @NSManaged var displayName: String?
    @NSManaged var concertID: NSNumber?

}
