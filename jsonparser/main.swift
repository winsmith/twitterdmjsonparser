//
//  main.swift
//  jsonparser
//
//  Created by Daniel Jilg on 06.05.20.
//  Copyright © 2020 Daniel Jilg. All rights reserved.
//

import Foundation

let filename = "/Users/yourusername/Downloads/twitter-2020-04-27/data/direct-messages.js"

let outputFileName = "/Users/yourusername/Downloads/twitter.html"

let yourID = "123123123"
let otherPersonID = "123123123"

let idLookupTable: IDLookupTable = [
    "10394352": "breakthesystem",
    yourID: "@yourtwitterusername",
    otherPersonID: "@otherpersontwitterusername"
]

let parser = DirectMessagesParser(filename: filename)
let messages = parser.findMessages(with: otherPersonID)

let renderer = Renderer()
renderer.idLookupTable = idLookupTable
renderer.myID = yourID
renderer.otherID = otherPersonID

let renderedOutput = renderer.render(messages: messages, in: HTMLTemplate.self)
try! renderedOutput.write(toFile: outputFileName, atomically: true, encoding: .utf8)
