

import Foundation

class Message {
    let messageType: MessageSentType
    let message: String
    let sendDate: NSDate
    var url = ""
    
    init(messageType: MessageSentType, message: String, sendDate: NSDate){
        self.messageType = messageType
        self.message = message
        self.sendDate = sendDate
    }
}
