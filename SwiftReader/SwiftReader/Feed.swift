//
//  Feed.swift
//  SwiftReader
//
//  Created by Matt Colman on 24/03/2015.
//  Copyright (c) 2015 Matt Colman. All rights reserved.
//

import Foundation
import CoreData

class Feed: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var articles: NSSet

}
