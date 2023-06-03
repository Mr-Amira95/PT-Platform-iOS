//
//  ChatViewController.swift
//  PT_Platform
//
//  Created by User on 03/06/2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    let currentUser = Sender(senderId: Shared.shared.getid() ?? "", displayName: "\(Shared.shared.getfirst_name() ?? "") \(Shared.shared.getlast_name() ?? "")")
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchChatMessages()
    }
    func fetchChatMessages() {
        RealtimeDBManager.shared.getAllMessagesForConversation { result in
            switch result {
            case .success(let data):
                self.messages = data
            case .failure(let failure):
                break
            }
        }
    }
}
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate {
    func currentSender() -> SenderType {
        return currentUser
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        RealtimeDBManager.shared.sendMessage(Message(sender: self.currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-66400), kind: .text(text)))
        self.messages.append(Message(sender: self.currentUser, messageId: currentUser.senderId + text, sentDate: Date().addingTimeInterval(-66400), kind: .text(text)))
        messageInputBar.inputTextView.text = nil
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem(animated: false)
    }
}

// MARK: MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) {
        let avatar = Shared.shared.getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
    }
    func textColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .white : .darkText
    }
    func detectorAttributes(for detector: DetectorType, and _: MessageType, at _: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
}
