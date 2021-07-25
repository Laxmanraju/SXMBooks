//
//  BookSearchModel.swift
//  SXMBooks
//
//  Created by Laxman Penmetsa on 7/24/21.
//

import Foundation

// MARK: - Books
struct Books: Codable {
    let kind: String
    let totalItems: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let kind: Kind?
    let id, etag: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    let accessInfo: AccessInfo?
}

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let embeddable, publicDomain: Bool
    let epub, pdf: Epub?
    let webReaderLink: String?
    let quoteSharingAllowed: Bool?
}

// MARK: - Epub
struct Epub: Codable {
    let isAvailable: Bool
    let downloadLink: String?
}

enum Kind: String, Codable {
    case booksVolume = "books#volume"
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title, publishedDate: String?
    let categories: [String]?
    let contentVersion: String?
    let imageLinks: ImageLinks?
    let previewLink: String?
    let authors: [String]?
    let subtitle, publisher, volumeInfoDescription: String?
    let pageCount: Int?
    let averageRating: Double?
    enum CodingKeys: String, CodingKey {
        case title, publishedDate, categories, contentVersion, imageLinks, previewLink, authors, subtitle, publisher
        case volumeInfoDescription = "description"
        case pageCount
        case averageRating
    }
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}

