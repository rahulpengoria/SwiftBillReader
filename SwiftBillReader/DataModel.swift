//
//  DataModel.swift
//  SwiftBillReader
//
//  Created by Ravi Tripathi on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import Foundation

struct DataModel: Codable {
    var category: String
    var date: Date
    var desc: String?
    var total: Double
    var image: Data
}
