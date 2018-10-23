//
//  SearchData.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/1/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

struct SearchData: Codable {
    let collection: CollectionData
    
    init(){
        collection = CollectionData()
    }
}

struct CollectionData: Codable {
    let metadata: Meta?
    let items: [Item]?
    let links: [LinkCollection]?
    let version: String?
    let href: String?
    
    init() {
        metadata = Meta()
        items = [Item()]
        links = [LinkCollection()]
        version = ""
        href = ""
    }
}

struct Meta: Codable {
    let total_hits: Int?
    
    init(){
        total_hits = 0
    }
}

struct Item: Codable {
    let links: [LinkItems]?
    let data: [DataInfo]?
    let href: String?
    
    init(){
        links = [LinkItems()]
        data = [DataInfo()]
        href = ""
    }
}

struct LinkItems: Codable {
    let render: String?
    let rel: String?
    let href: String?
    
    init(){
        render = ""
        rel = ""
        href = ""
    }
}

struct LinkCollection: Codable {
    let prompt: String?
    let rel: String?
    let href: String?
    
    init(){
        prompt = ""
        rel = ""
        href = ""
    }
}

struct DataInfo: Codable {
    let description: String?
    let title: String?
    let date_created: String?
    let keywords: [String]?
    let nasa_id: String?
    let album: String?
    let media_type: String?
    let location: String?
    let center: String?
    
    init(){
        description = ""
        title = ""
        date_created = ""
        keywords = [""]
        nasa_id = ""
        album = ""
        media_type = ""
        location = ""
        center = ""
    }
}

