//
//  Photo.swift
//  Flickr
//
//  Created by Евгений Холкин on 06.06.2020.
//  Copyright © 2020 Евгений Холкин. All rights reserved.
//

import Foundation

struct Items: Codable {
    let title: String?
    let published: String?
    let date_taken: String?
    let media: PhotoLink?
    let tags: String?
}

struct PhotoLink: Codable {
    let m: String?
}
