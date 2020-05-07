//
//  Parser.swift
//  jsonparser
//
//  Created by Daniel Jilg on 07.05.20.
//  Copyright © 2020 Daniel Jilg. All rights reserved.
//

import Foundation

class DirectMessagesParser {
    init(filename: String) {
        self.filename = filename
    }

    let filename: String

    func findMessages(with personID: String) -> [MessageContainer] {
        var relevantMessages: [MessageContainer] = []

        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filename))

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601withFractions
        let dmConvoContainers = try! decoder.decode([DmConversationContainer].self, from: jsonData)

        for dmConvoContainer in dmConvoContainers {
            for messageContainer in dmConvoContainer.dmConversation.messages { // TODO: Sort
                if let message = messageContainer.messageCreate {
                    if message.senderId == personID || message.recipientId == personID {
                        relevantMessages.append(messageContainer)
                    }
                }

                if let reaction = messageContainer.reactionCreate, reaction.senderId == personID {
                    relevantMessages.append(messageContainer)
                }
            }
        }

        return relevantMessages.sorted()
    }

}
