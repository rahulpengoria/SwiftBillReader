//
//  HistoryCSVModel.swift
//  SwiftBillReader
//
//  Created by Ravi Tripathi on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import Foundation

struct HistoryCSVModel: Codable {
    var fileDisplayName: String
    var filePath: URL
    var submitDate: Date
}
