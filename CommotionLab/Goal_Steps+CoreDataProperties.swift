//
//  Goal_Steps+CoreDataProperties.swift
//  Commotion
//
//  Created by yinze cui on 2021/10/19.
//  Copyright © 2021 Eric Larson. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal_Steps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal_Steps> {
        return NSFetchRequest<Goal_Steps>(entityName: "Goal_Steps")
    }

    @NSManaged public var steps: String

}

extension Goal_Steps : Identifiable {

}
