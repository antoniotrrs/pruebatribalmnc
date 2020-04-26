//
//  Favoritos+CoreDataProperties.swift
//  pruebatribal
//
//  Created by Antonio Torres on 24/04/20.
//  Copyright © 2020 Antonio Torres. All rights reserved.
//
//

import Foundation
import CoreData


extension Favoritos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favoritos> {
        return NSFetchRequest<Favoritos>(entityName: "Favoritos")
    }

    @NSManaged public var informacion: String?

}
