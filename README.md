# twitterdmjsonparser
Take your twitter archive and extract all DMs with one person

1. Go to Twitter Profile Settings and Request, then download your archive
2. Open the Zip and go to `direct-messages.js`
3. Remove `window.YTD.direct_messages.part0 = ` from the first line. The line should start with a `[`
4. Find one message in the JSON that is from the DM conversation you want to extract. If it's a message from you, copy it's `senderId` into `main.swift` as `yourId`, then copy it's `recipientId` into `main.swift` as `otherPersonID`.
5. Change `main.swift` to your liking, add ID's to the idLookuptable
6. Run the thing
7. A html file is now in your download folder
