//
//  BookListModel.swift
//  Ohaya.Chika.iOSCodingChallenge
//
//  Created by Makaveli Ohaya on 8/15/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//

import Foundation


struct BookLists: Codable, Equatable {
    let title: String
    let imageURL: String?
    let author: String?
}

enum CodingKeys: String, CodingKey {
        case title
        case imageUrl = "imageURL"
        case author
    }


