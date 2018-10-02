//
//  Data.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/1/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

struct SearchData: Codable {
    var collection: [CollectionData]
}

struct CollectionData: Codable {
    var metadata: [Meta]
    var items: [Item]
    var version: String
    var href: String
}

struct Meta: Codable {
    var total_hits: Int
}

struct Item: Codable {
    var links: [Link]
    var data: [DataInfo]
    var href: String
}

struct Link: Codable {
    var render: String
    var rel: String
    var href: String
}

struct DataInfo: Codable {
    var description: String
    var title: String
    var date_created: String
    var keywords: [String]
    var nasa_id: String
    var album: String
    var media_type: String
    var location: String
    var center: String
}
