//
//  ChatM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 25/10/2022.
//

import Foundation
import SwiftyJSON

class ChatM {
    var id : Any
    var chat_id : Any
    var sender_id : Any
    var message : Any
    var type : Any
    
    init(id:Any, chat_id:Any, sender_id:Any, message:Any, type:Any){
        self.id = id
        self.chat_id = chat_id
        self.sender_id = sender_id
        self.message = message
        self.type = type
    }
    
}
