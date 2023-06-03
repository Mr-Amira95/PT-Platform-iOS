//
//  RealtimeDBManager.swift
//  PT_Platform
//
//  Created by User on 03/06/2023.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseDatabase
import MessageKit

class RealtimeDBManager {
    static let shared = RealtimeDBManager()
    private let database = Database.database(url: "https://pt-platform-f1584-default-rtdb.firebaseio.com").reference()
    
    private init() {}
    
    func sendMessage(_ newMessage: Message) {
        guard let userID = Shared.shared.getid() else {
            return
        }
        guard let coachID = Shared.shared.getCoachId() else {
            return
        }
        var messageText = ""
        
        switch newMessage.kind {
        case .text(let content):
            messageText = content
        default:
            break
        }
        let message = [
            "senderId" : userID,
            "receiverId": coachID,
            "message" : messageText,
            "time" : Int(newMessage.sentDate.timeIntervalSince1970)
        ] as [String : Any]
        database.child("\(coachID)/\(userID)/messages").childByAutoId().setValue(message)
    }

    
    func getAllMessagesForConversation(completion: @escaping(Result<[Message], Error>)->Void) {
        var path = ""
        if Shared.shared.getusertype() == "Coach"{
            let coachID = Shared.shared.getCoachId() ?? 0
            path = "\(coachID)/\(Shared.shared.selectUserInCoach)/messages"
        } else {
            let coachID = Shared.shared.getCoachId() ?? 0
            let userID = Shared.shared.getid() ?? ""
            path = ("\(coachID)/\(userID)/messages")
        }
        database.child(path).observeSingleEvent(of: .childAdded, with: {snapshot in
            guard let value = snapshot.value as? [String: Any] else{
//                completion(.failure(Erro()))
                return
            }
            let messages: [Message] = [value].compactMap({ dictionary in
                print(dictionary)
                guard let message = dictionary["message"] as? String,
                      let receiverId = dictionary["receiverId"] as? Int,
                      let senderId = dictionary["senderId"] as? String,
                      let time = dictionary["time"] as? Double
                else {
                    print("Something with date formatter probably")
                    return Message(sender: Sender(senderId: "", displayName: ""), messageId: "", sentDate: Date(), kind: .text(""))
                }
                let date = Date(timeIntervalSince1970: time)
                //                    let dateFormatter = DateFormatter()
                //                    dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                //                    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                //                    dateFormatter.timeZone = .current
                //                    let localDate = dateFormatter.string(from: date)
                let sender = Sender(senderId: senderId,
                                    displayName: senderId)
                let finalMessage = Message(sender: sender,
                                           messageId: message+senderId+String(receiverId),
                                           sentDate: date,
                                           kind: .text(message))
                return finalMessage
            })
            completion(.success(messages))
        })
    }
}






struct Sender :SenderType {
    var senderId : String
    var displayName: String
}
struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        default:
            return ""
        }
    }
}
