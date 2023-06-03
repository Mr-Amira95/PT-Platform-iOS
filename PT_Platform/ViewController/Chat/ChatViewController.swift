//
//  ChatViewController.swift
//  PT_Platform
//
//  Created by User on 03/06/2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import LanguageManager_iOS

class ChatViewController: MessagesViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    let primaryColor = UIColor(red: 69 / 255, green: 193 / 255, blue: 89 / 255, alpha: 1)
    let currentUser = Sender(senderId: Shared.shared.getid() ?? "", displayName: "\(Shared.shared.getfirst_name() ?? "") \(Shared.shared.getlast_name() ?? "")")
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchChatMessages()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Live Chat"
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enable = false
        lblTitle.text = Shared.shared.btnBack

        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.inputTextView.resignFirstResponder()
        configureMessageCollectionView()
        configureMessageInputBar()
        setNavigationBar()
    }
    func setNavigationBar() {
        let imgBackArrow = UIImage(named: "iconPrevious")
        let customBackButton = UIBarButtonItem(title: "Back" , style: .plain, target: self, action: #selector(backToMain))
        customBackButton.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = customBackButton
    }
    @objc func backToMain() {
        self.dismiss(animated: true)
    }
    func configureMessageCollectionView() {
      messagesCollectionView.messagesDataSource = self
      scrollsToLastItemOnKeyboardBeginsEditing = true // default false
      showMessageTimestampOnSwipeLeft = true // default false
//      messagesCollectionView.refreshControl = refreshControl
    }

    func configureMessageInputBar() {
      messageInputBar.delegate = self
      messageInputBar.inputTextView.tintColor = primaryColor
      messageInputBar.sendButton.setTitleColor(primaryColor, for: .normal)
      messageInputBar.sendButton.setTitleColor(primaryColor.withAlphaComponent(0.3),for: .highlighted)
    }
    func fetchChatMessages() {
        RealtimeDBManager.shared.getAllMessagesForConversation { result in
            switch result {
            case .success(let data):
                self.messages = data
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
            case .failure(let failure):
                break
            }
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
