//
//  Renderer.swift
//  jsonparser
//
//  Created by Daniel Jilg on 07.05.20.
//  Copyright © 2020 Daniel Jilg. All rights reserved.
//

import Foundation

typealias IDLookupTable = [String: String]

class Renderer {
    var idLookupTable: IDLookupTable = [:]
    var myID: String = ""
    var otherID: String = ""

    func render(messages: [MessageContainer], in TemplateType: Template.Type) -> String {
        var output = ""

        let template = TemplateType.init(renderer: self)

        for messageContainer in messages {
            if let message = messageContainer.messageCreate {
                output.append(template.renderMessageToPartial(message: message))
            }

            if let reaction = messageContainer.reactionCreate {
                output.append(template.renderReactionToPartial(reaction: reaction))
            }

        }

        return template.renderFrame(around: output)
    }
}

class Template {
    var renderer: Renderer

    required init(renderer: Renderer) {
        self.renderer = renderer
    }

    func renderFrame(around messages: String) -> String {
        return "Direct Messages\n\n--------\n\(messages)--------\n"
    }

    func renderMessageToPartial(message: Message) -> String {
        return "\(username(for: message.senderId)): \(message.text)\n"
    }

    func renderReactionToPartial(reaction: Reaction) -> String {
        return "\(username(for: reaction.senderId)) \(reaction.reactionKey)'d this message\n"
    }

    func username(for id: String) -> String {
        return renderer.idLookupTable[id, default: id]
    }
}


class TextOnlyTemplate: Template {

}

class HTMLTemplate: Template {
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .long
        dateFormatter.locale = Locale.init(identifier: "de")
        return dateFormatter
    }()

    override func renderFrame(around messages: String) -> String {
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Direct Messages with \(username(for: renderer.otherID))</title>
            <style>
                body {
                    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Ubuntu, "Helvetica Neue", sans-serif;
                }

                .message {
                    display: block;
                    margin: 1em;
                    clear: both;
                }

                .message .text {
                    padding: 10px 15px;
                    background-color: lightblue;
                    border-radius: 18.75px;
                    font-size: 15px;
                    display: inline-block;
                }

                .sent .text {
                    background-color: rgb(29, 161, 242);
                    color: white;
                    border-bottom-right-radius: 0;
                    text-align: right;
                    float: right;
                }

                .received .text {
                    background-color: rgb(230, 236, 240);
                    border-bottom-left-radius: 0;
                }

                .createdAt {
                    color: rgb(101, 119, 134);
                    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Ubuntu, "Helvetica Neue", sans-serif;
                    font-size: 13px;
                    clear: both;
                    padding-top: 0.2em;
                }

                .sent .createdAt {
                    text-align: right;
                }

                .reaction {
                    color: rgb(101, 119, 134);
                    display: block;
                    margin: 1em;
                    max-width: 70%;
                    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Ubuntu, "Helvetica Neue", sans-serif;
                    font-size: 13px;
                    float: right;
                    clear: both;
                }
            </style>
        </head>
        <body>
            <h1>Direct Messages with \(username(for: renderer.otherID))</h1>
            \(messages)
        </body>
        </html>
        """
    }

    override func renderMessageToPartial(message: Message) -> String {
        // let usernameString = "<div class='sender'>\(username(for: message.senderId))</div>"
        let messageString = "<div class='text'>\(message.text)</div>"
        let dateString = "<div class='createdAt'>\(dateFormatter.string(from: message.createdAt))</div>"

        var messageClass = ""
        if renderer.myID == message.senderId {
            messageClass = "sent"
        } else if renderer.otherID == message.senderId {
            messageClass = "received"
        }

        return "<div class='message \(messageClass)'>\(messageString)\(dateString)</div>"
    }

    override func renderReactionToPartial(reaction: Reaction) -> String {

        var reactionEmoji: String? = nil
        switch reaction.reactionKey {
        case "like":
            reactionEmoji = "❤️"
        case "excited":
            reactionEmoji = "😍"
        case "agree":
            reactionEmoji = "👍"
        case "disagree":
            reactionEmoji = "👎"
        default:
            reactionEmoji = nil
        }

        return "<div class='reaction'>\(username(for: reaction.senderId)) reagierte mit <strong>\(reactionEmoji ?? reaction.reactionKey)</strong></div>"
    }
}
