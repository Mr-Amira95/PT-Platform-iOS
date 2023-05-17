//
//  ChatVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 01/02/2022.
//

import UIKit
import SocketIO
import MessageKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import LanguageManager_iOS
import Alamofire
import SwiftyJSON

struct Sender :SenderType{
    var senderId : String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatVC: MessagesViewController {

    
    private(set) lazy var refreshControl: UIRefreshControl = {
      let control = UIRefreshControl()
      control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
      return control
    }()
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    
    var manager:SocketManager?
    var socket: SocketIOClient!
    var dataList : [ChatM] = []
    var chat : [ChatM] = []
    var countOfProducts = 0
    
    var chatId = ""
    let userId = Shared.shared.getid() ?? ""
    let currentUser = Sender(senderId: Shared.shared.getid() ?? "", displayName: "\(Shared.shared.getfirst_name() ?? "") \(Shared.shared.getlast_name() ?? "")")
    let otherUser = Sender(senderId: "\(Shared.shared.selectUserInCoach)", displayName: Shared.shared.selectUserInCoachName)
    var otherCoach = Sender(senderId: "\(Shared.shared.getCoachId() ?? 0)", displayName: Shared.shared.getCoachName() ?? "")
    var  messages = [MessageType]()
    let primaryColor = UIColor(red: 69 / 255, green: 193 / 255, blue: 89 / 255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        checkChat()
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
      messagesCollectionView.refreshControl = refreshControl
    }

    func configureMessageInputBar() {
      messageInputBar.delegate = self
      messageInputBar.inputTextView.tintColor = primaryColor
      messageInputBar.sendButton.setTitleColor(primaryColor, for: .normal)
      messageInputBar.sendButton.setTitleColor(primaryColor.withAlphaComponent(0.3),for: .highlighted)
    }
    @objc
    func loadMoreMessages() {
      DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
          if Shared.shared.Skip == 1{
              DispatchQueue.main.async {
                  self.refreshControl.endRefreshing()
                  self.moreData()
              }
          }else if Shared.shared.Skip == 0{
              Shared.shared.Skip = 1
          }else if Shared.shared.Skip == 2{

          }
      }
    }

    
    func checkChat(){
        var parameter = ["":""]
        if Shared.shared.getusertype() == "Coach"{
             parameter = ["received_id":"\(Shared.shared.selectUserInCoach)"]
        }else{
             parameter = ["received_id":"\(Shared.shared.getCoachId() ?? 0)"]
        }
        
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.chatPostApi(param: parameter) { chat_id, bool, bool2 in
            Spinner.instance.removeSpinner()
            if bool{
                if bool2{
                    self.chatId = chat_id
                    self.socketOpen(chat_id: chat_id)
                    self.moreData()
                }
            }else{
                Shared.shared.btnBack = "Authorized"
                let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "NoAuthorizedVC") as! NoAuthorizedVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    func socketOpen(chat_id : String){
         manager = SocketManager(socketURL: URL(string: "https://ptplatform.app:3001")!, config: [.compress, .forceWebsockets(true)])
         socket = manager!.defaultSocket
         socket.on(clientEvent: .connect) {data, ack in
            let obj = ["chat_id" : chat_id]
            self.socket.emit("join_room", obj)
            self.socket.on("receive_message") {data, ack in
                let dataChat = data as! [[String:Any]]
                for i in dataChat{
                    let sender_id = i["sender_id"] as! String
                    let message = i["message"] as! String
                    if Shared.shared.getusertype() != "Coach"{
                        self.messages.append(Message(sender: self.otherUser, messageId: "10", sentDate: Date().addingTimeInterval(-66400), kind: .text(message)))
                    }else{
                        self.messages.append(Message(sender: self.otherCoach, messageId: "10", sentDate: Date().addingTimeInterval(-66400), kind: .text(message)))
                    }
                    break
                }
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
        }
      }
        socket.connect()
    }
    func moreData(){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(chat_url)/\(self.chatId)/messages?skip=\(countOfProducts)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        let data1 = dic["data"] as! [[String:Any]]
                        if data1.count == 0{
                            Shared.shared.Skip = 2
                        }else{
                            for data in data1{
                            let id = data["id"] as? Int ?? 0
                            let chat_id = data["chat_id"] as? Int ?? 0
                            let sender_id = data["sender_id"] as? Int ?? 0
                            let message = data["message"] as? String ?? "message"
                            let type = data["type"] as? String ?? "type"
                            let obj = ChatM(id: id, chat_id: chat_id, sender_id: sender_id, message: message, type: type)
                                self.dataList.append(obj)
                                Shared.shared.Skip = 1
                                self.countOfProducts = +self.dataList.count
                            }
                            for i in self.dataList.reversed(){
                                if "\(i.sender_id as? Int ?? 0)" != self.userId{
                                    if Shared.shared.getusertype() != "Coach"{
                                        self.messages.append(Message(sender: self.otherUser, messageId: "\(i.id as? Int ?? 0)", sentDate: Date().addingTimeInterval(-66400), kind: .text(i.message as? String ?? "")))
                                    }else{
                                        self.otherCoach = Sender(senderId: "\(i.sender_id)", displayName: Shared.shared.getCoachName() ?? "")
                                        self.messages.append(Message(sender: self.otherCoach, messageId: "\(i.id as? Int ?? 0)", sentDate: Date().addingTimeInterval(-66400), kind: .text(i.message as? String ?? "")))
                                    }
                                }else{
                                    self.messages.append(Message(sender: self.currentUser, messageId: "\(i.id as? Int ?? 0)", sentDate: Date().addingTimeInterval(-66400), kind: .text(i.message as? String ?? "")))
                                }
                            }
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToLastItem(animated: false)
                        }
                    }else{
                       let errors = dic["errors"] as! NSDictionary
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
            }
         }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}


extension ChatVC: MessagesDataSource, MessagesLayoutDelegate {
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


extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let obj = ["chat_id" : chatId,
                   "sender_id" : userId,
                   "message": text] as [String : Any]
        self.socket.emit("send_message", obj)
        self.messages.append(Message(sender: self.currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-66400), kind: .text(text)))
        messageInputBar.inputTextView.text = nil
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem(animated: false)
    }
}


// MARK: MessagesDisplayDelegate

extension ChatVC: MessagesDisplayDelegate {
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
