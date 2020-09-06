//
//  Video.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/02.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

struct Categories: Codable {
    var categories: [Category]?
    
    private enum CodingKeys: String, CodingKey {
        case categories
    }
}

struct Category: Codable {
    var name: String?
    var videos: [Video]?
    
    private enum CodingKeys: String, CodingKey {
        case name, videos
    }
}


struct Video: Codable {

    var title: String?
    var thumb: String?
    var subtitle: String?
    var sources: [String]?
    var description: String?

    private enum CodingKeys: String, CodingKey {
        case title, thumb, subtitle, sources, description
    }
}


