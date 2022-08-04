//
//  ToDoList+CoreDataProperties.swift
//  SanjaySamuel_FinalExamLab7
//
//  Created by Sanjay Sekar Samuel on 2022-07-27.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var name: String?

}

extension ToDoList : Identifiable {

}
