//
//  schemes.swift
//  jsonparser
//
//  Created by Daniel Jilg on 06.05.20.
//  Copyright © 2020 Daniel Jilg. All rights reserved.
//

import Foundation

struct Message:  Codable, Equatable {
    let createdAt: Date
    let recipientId: String
    let text: String
    let mediaUrls: [String]
    let senderId: String
    let id: String

    let reactionKey: String?
    let eventId: String?
}

struct Reaction: Codable, Equatable {
    let senderId: String
    let createdAt: Date
    let reactionKey: String
}

struct MessageContainer: Codable, Comparable {
    let messageCreate: Message?
    let reactionCreate: Reaction?

    var createdAt: Date {
        return messageCreate?.createdAt ?? reactionCreate?.createdAt ?? Date()
    }

    static func < (lhs: MessageContainer, rhs: MessageContainer) -> Bool {
        return lhs.createdAt < rhs.createdAt
    }

    static func == (lhs: MessageContainer, rhs: MessageContainer) -> Bool {
        return lhs.messageCreate == rhs.messageCreate && lhs.reactionCreate == rhs.reactionCreate
    }
}

struct DmConversation: Codable {
    let conversationId: String
    let messages: [MessageContainer]
}

struct DmConversationContainer: Codable {
    let dmConversation: DmConversation
}
