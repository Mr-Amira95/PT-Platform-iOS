//
//  ControllerService.swift
//  PT_Platform
//
//  Created by mustafakhallad on 19/05/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import LanguageManager_iOS

class ControllerService{
    
static let instance = ControllerService()

let headers: HTTPHeaders = ["Accept":"application/json"]

func Login(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
            Alamofire.request(postlogin_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                let statusCode = response.response?.statusCode
                if statusCode == 200 || statusCode == 422 {
                    switch response.result {
                    case .success(let value):
                        let dic = value as! NSDictionary
                        let success = dic["success"] as? NSNumber
                        if success == 1{
                            let data = dic["data"] as! NSDictionary
                            let token = data["token"] as Any
                            Shared.shared.SavetUserToken(auth: token as? String ?? "")
                            let user = data["user"] as! NSDictionary
                            let id = user["id"] as? Int ?? 0
                            Shared.shared.saveid(auth: "\(id)")
                            Shared.shared.setusertype(auth: (user["role"] as? String ?? "").capitalized)
                            if Shared.shared.getusertype() == "Coach"{
                                Shared.shared.saveCoachId(auth: id)
                            }
                            let first_name = user["first_name"] as Any
                            Shared.shared.savefirst_name(auth: first_name as? String ?? "")
                            let last_name = user["last_name"] as Any
                            Shared.shared.savelast_name(auth: last_name as? String ?? "")
                            let email = user["email"] as Any
                            Shared.shared.saveEmail(auth: email as? String ?? "")
                            let status = user["status"] as Any
                            Shared.shared.savestatus(auth: status as? String ?? "")
                            let avatar = user["avatar"] as Any
                            Shared.shared.saveAvatar(auth: avatar as? String ?? "")
                            let is_send_notification = user["is_send_notification"] as Any
                            Shared.shared.isSendNotification(auth: is_send_notification as? Bool ?? false)
                            if Shared.shared.getusertype() == "Coach"{
                                if status as? String ?? "" == "reject"{
                                    if LanguageManager.shared.currentLanguage == .en{
                                        complition("your account is rejected, please contact admin", false)
                                    }else{
                                        complition("تم رفض طلبك يرجى التواصل مع الدعم", false)
                                    }
                                }else if status as? String ?? "" == "requested"{
                                    if LanguageManager.shared.currentLanguage == .en{
                                        complition("Please wait until admin approval", false)
                                    }else{
                                        complition("يرجى الانتظار حتى موافقة المسؤول", false)
                                    }
                                }else{
                                    complition("", true)
                                }
                            }else{
                                complition("", true)
                            }
                        }else{
                            var message = ""
                            let errors = dic["errors"] as! NSDictionary
                            let email = errors["email"] != nil
                            if email{
                                let email = errors["email"] as? String ?? ""
                                message = email
                            }
                            let password = errors["password"] != nil
                            if password{
                                let password = errors["password"] as? String ?? ""
                                message = password
                            }
                            complition(message, false)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }else{
                    complition("Something wrong!" as String, false)
                }
                  }
         }
    func Signup(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
                Alamofire.request(postsignup_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 || statusCode == 422 {
                        switch response.result {
                        case .success(let value):
                            let dic = value as! NSDictionary
                            let error = dic["error"] as? NSString
                            let success = dic["success"] as? NSNumber
                            if success == 1{
                                let data = dic["data"] as! NSDictionary
                                let token = data["token"] as Any
                                Shared.shared.SavetUserToken(auth: token as? String ?? "")
                                let user = data["user"] as! NSDictionary
                                let id = user["id"] as Any
                                Shared.shared.saveid(auth: id as? String ?? "")
                                let first_name = user["first_name"] as Any
                                Shared.shared.savefirst_name(auth: first_name as? String ?? "")
                                let last_name = user["last_name"] as Any
                                Shared.shared.savelast_name(auth: last_name as? String ?? "")
                                let email = user["email"] as Any
                                Shared.shared.saveEmail(auth: email as? String ?? "")
                                let status = user["status"] as Any
                                Shared.shared.savestatus(auth: status as? String ?? "")
                                let avatar = user["avatar"] as Any
                                Shared.shared.saveAvatar(auth: avatar as? String ?? "")
                                let is_send_notification = user["is_send_notification"] as Any
                                Shared.shared.isSendNotification(auth: is_send_notification as? Bool ?? false)
                                complition("", true)
                            }else{
                                var message = ""
                                let errors = dic["errors"] as! NSDictionary
                                let email = errors["email"] != nil
                                if email{
                                    let email = errors["email"] as? String ?? ""
                                    message = email
                                }
                                let password = errors["password"] != nil
                                if password{
                                    let password = errors["password"] as? String ?? ""
                                    message = password
                                }
                                complition(message, false)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }else{
                        complition("Something wrong!" as String, false)
                    }
                      }
             }
    func SetDataDevice(param: [String:Any],complition: @escaping(_ value:String,_ value:Bool)-> ()){
        let headers1: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(10)
        manager.request(registerdevicesUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = response.value as! NSDictionary
                    let success = dic["success"] as? NSNumber
                    if success == 1{
                        complition("",true)
                    }else{
                        complition("Something wronge",false)
                    }
                    break
                case .failure(let error):
                    print(error._code)
                    if error._code == NSURLErrorTimedOut {
                        complition("Request timeout!",true)
                        print("Request timeout!")
                    }
                }
            }
        }
    }
    func logoutApi(param: [String:Any],complition: @escaping(_ value:String,_ value:Bool)-> ()){
        let headers1: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(10)
        manager.request(logout_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    complition("",true)
                    break
                case .failure(let error):
                    print(error._code)
                    if error._code == NSURLErrorTimedOut {
                        complition("Request timeout!",true)
                        print("Request timeout!")
                    }
                }
            }
        }
    }
    func deleteMyAccountApi(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers1: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(delete_account_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        complition("", true)
                    } else if let message = dic["data"] as? NSString {
                       complition(message as String, false)
                    } else if let errors = dic["errors"] as? [String : String], let msg = errors["password"] {
                        complition(msg, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func editImageProfile(avatar:UIImage,complition: @escaping (_ message: String,_ value:Bool)->Void){
        let headers1: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
            Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(avatar.jpegData(compressionQuality: 0.75)!,withName: "avatar",fileName: "file.jpg", mimeType: "image/jpg")
            }, to: update_avatar_url,method: .post,headers:headers1 , encodingCompletion: { result in
              switch result {
                case .success(request: let request, streamingFromDisk: false, streamFileURL: nil):
                        request.responseJSON(completionHandler: { (response) in
                            let statusCode = response.response?.statusCode
                            if statusCode == 200 || statusCode == 422 {
                                let dic = response.value as! NSDictionary
                                let success = dic["success"] as? NSNumber
                                if success == 1{
                                    let data = dic["data"] as! NSDictionary
                                    let avatar = data["avatar"] as? String ?? ""
                                    Shared.shared.saveAvatar(auth: avatar)
                                    complition("",true)
                                }else{
//                                    let errors = data["errors"] as Any
                                }
                            }else{
                            complition("Something wronge",false)
                            }
                    })
                    break
                case .failure:
                    complition("Un-Expected error",false)
                    break
                case .success(let request, true, _):
                    break
                case .success(let request, _, _):
                    break
                }
            })
        }
    func editNameProfile(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let HeadersAuth1 = ["Accept" : "application/json",
                           "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                            "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(update_name_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
                let dic = response.value as! NSDictionary
                let success = dic["success"] as? NSNumber
                if success == 1{
                    let data = dic["data"] as! NSDictionary
                    let first_name = data["first_name"] as Any
                    Shared.shared.savefirst_name(auth: first_name as? String ?? "")
                    let last_name = data["last_name"] as Any
                    Shared.shared.savelast_name(auth: last_name as? String ?? "")
                    complition("",true)
                }else{
                }
            }else{
            complition("Something wronge",false)
            }
         }
     }
    func Banner(complition: @escaping(_ value: [BannersM],_ value:Bool)-> Void){
        let headers1: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
           var Datalist : [BannersM] = []
        var url = ""
        let userId = Shared.shared.getCoachId() ?? 0
        if Shared.shared.bannerIn == "first"{
            url = "\(banners_url)"
        }else{
            url = "\(banners_url)?user_id=\(userId)"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers1).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as? Int ?? 0
                               let text = data2["text"] as? String ?? ""
                               let image = data2["image"] as? String ?? ""
                               let url = data2["url"] as? String ?? ""
                               let obj = BannersM(id: id, image: image, text: text, url: url)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func Newsfeed(complition: @escaping(_ value: [NewsfeedM],_ value:Bool)-> Void){
           var Datalist : [NewsfeedM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
           Alamofire.request(newsfeed_url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as? String ?? ""
                               let description = data2["description"] as? String ?? ""
                               let image = data2["image"] as? String ?? ""
                               let obj = NewsfeedM(id: id, image: image, title: title, description: description)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func NewsfeedForNotification(complition: @escaping(_ id:Int,_ title:String,_ description:String,_ image:String,_ value:Bool)-> Void){
           var Datalist : [NewsfeedM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(newsfeed_url)/\(Shared.shared.notificationId)/show", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                               let id = data["id"] as? Int ?? 0
                               let title = data["title"] as? String ?? ""
                               let description = data["description"] as? String ?? ""
                               let image = data["image"] as? String ?? ""
                           complition( id, title, description, image, true)
                       }else{
                           complition( 0, "", "", "", false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func ExerciseHomePage(complition: @escaping(_ value: [HomeexerciseDataM],_ value:Bool,_ value:Bool)-> Void){
        var Datalist : [HomeexerciseDataM] = []
        var Datalist1 : [CategoryM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionexercise_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as? Int ?? 0
                               let title = data2["title"] as? String ?? ""
                               let obj = HomeexerciseDataM(id: id, title: title)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true, true)
                       }else{
                           complition(Datalist, false, true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist, false, false)
               }
            }
        }
    func ExerciseSearchApi(complition: @escaping(_ value: [ChallengesM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [ChallengesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionexercise_url)/exercises\(Shared.shared.search)&coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as! String
                               let description = data2["description"] as! String
                               let icon = data2["icon"] as! String
                               let idIn = data2["id"] as! Int
                               let obj = ChallengesM(id: id, idIn: idIn, title: title, description: description, icon: icon)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,"", false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func WorkoutsSearchApi(complition: @escaping(_ value: [ChallengesM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [ChallengesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionworkout_url)/exercises\(Shared.shared.search)&coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as! String
                               let description = data2["description"] as! String
                               let icon = data2["icon"] as! String
                               let idIn = data2["id"] as! Int
                               let obj = ChallengesM(id: id, idIn: idIn, title: title, description: description, icon: icon)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,"", false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func categoryExercise(complition: @escaping(_ value: [CategoryM],_ value:String,_ value:Bool,_ value:Bool)-> Void){
        var Datalist1 : [CategoryM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionexercise_url)/categories?group_id=\(Shared.shared.group_id)&coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           let json = JSON(value)
                           if data.count == 0{
                               complition(Datalist1,"Empty Data", false, true)
                           }else{
                               if let results = json["data"].array {
                                   for item in results{
                                       if let data = item.dictionary, let categoryData = CategoryM.init(dict: data)
                                       {
                                           Datalist1.append(categoryData)
                                       }
                                   }
                               }
                               complition(Datalist1,"", true, true)
                           }
                       }else{
                           complition(Datalist1,"", false, true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist1,"" ,false, false)
               }
            }
        }
    
    func ExerciseVideoPage(complition: @escaping(_ value: [VideoM],_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionexercise_url)/videos?exercise_id=\(Shared.shared.exercise_id)&coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as? String ?? "title"
                               let description = data2["description"] as? String ?? "description"
                               let image = data2["image"] as? String ?? ""
                               let video = data2["video"] as? String ?? ""
                               let is_favourite = data2["is_favourite"] as! Int
                               let is_today_log = data2["is_today_log"] as! Int
                               let is_workout = data2["is_workout"] as! Int
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func WorkoutHomePage(complition: @escaping(_ value: [HomeexerciseDataM],_ value:Bool,_ value:Bool)-> Void){
        var Datalist : [HomeexerciseDataM] = []
        var Datalist1 : [CategoryM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionworkout_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as? String ?? ""
                               let obj = HomeexerciseDataM(id: id, title: title)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true, true)
                       }else{
                           complition(Datalist, false, true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist, false, false)
               }
            }
        }
    func categoryWorkout(complition: @escaping(_ value: [CategoryM],_ value:String,_ value:Bool)-> Void){
        var Datalist1 : [CategoryM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionworkout_url)/categories?group_id=\(Shared.shared.group_id)&coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           let json = JSON(value)
                           if data.count == 0{
                               complition(Datalist1,"Empty Data", false)
                           }else{
                               if let results = json["data"].array {
                                   for item in results{
                                       if let data = item.dictionary, let categoryData = CategoryM.init(dict: data)
                                       {
                                           Datalist1.append(categoryData)
                                       }
                                   }
                               }
                               complition(Datalist1,"", true)
                           }
                       }else{
                           complition(Datalist1,"", false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func WorkoutVideoPage(complition: @escaping(_ value: [VideoM],_ message:String,_ value:Bool,_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(sectionworkout_url)/videos?coach_id=\(Shared.shared.getCoachId() ?? 0)&exercise_id=\(Shared.shared.exercise_id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as? String ?? "title"
                               let description = data2["description"] as? String ?? "description"
                               let image = data2["image"] as? String ?? ""
                               let video = data2["video"] as? String ?? ""
                               let is_favourite = data2["is_favourite"] as! Int
                               let is_today_log = data2["is_today_log"] as! Int
                               let is_workout = data2["is_workout"] as! Int
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, "", true, true)
                       }else{
                           complition(Datalist, "", false, true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist,"app.please_add_new_package", false, false)
               }
            }
        }
    func SetWorkoutVideoPage(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let HeadersAuth1 = ["Accept" : "application/json",
                           "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                            "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(workout_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        let data = dic["data"] as! NSString
                        complition(data as String, true)
                    }else{
                       let message = dic["message"] as! NSString
                        complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else if statusCode == 422{
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        complition("", true)
                    }else{
                       let errors = dic["errors"] as! NSDictionary
                        let error = errors["weight_unit"] as! NSString
                        complition(error as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func WorkoutTodayVideoPage(complition: @escaping(_ value: [VideoM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(workout_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)&date=\(Shared.shared.monthto)-\(Shared.shared.datTo)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as? Int ?? 0
                               let title = data2["title"] as? String ?? ""
                               let description = data2["description"] as? String ?? ""
                               let image = data2["image"] as? String ?? ""
                               let video = data2["video"] as? String ?? ""
                               let is_favourite = data2["is_favourite"] as? Int ?? 0
                               let is_today_log = data2["is_today_log"] as? Int ?? 0
                               let is_workout = data2["is_workout"] as? Int ?? 0
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, "", true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let date = errors["date"] != nil
                           if date{
                               let date = errors["date"] as? String ?? ""
                               complition(Datalist, date, false)
                           }
                           complition(Datalist, "",false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func ChallengeVideoPage(complition: @escaping(_ value: [VideoM],_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(challenges_url)/videos?challenge_id=\(Shared.shared.challenge_id)&coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let is_complete = data2["is_complete"] as! Bool
                               let videos = data2["video"] as? NSDictionary
                               let title = videos?["title"] as? String ?? ""
                               let description = videos?["description"] as? String ?? ""
                               let image = videos?["image"] as! String
                               let video = videos?["video"] as! String
                               let idIn = videos?["id"] as! Int
                               let is_favourite = videos?["is_favourite"] as! Int
                               let is_today_log = videos?["is_today_log"] as! Int
                               let is_workout = videos?["is_workout"] as! Int
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func LogsVideoPage(complition: @escaping(_ value: [VideoM],_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(logs_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)&date=2022-05-26", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as! String
                               let description = data2["description"] as! String
                               let image = data2["image"] as! String
                               let video = data2["video"] as! String
                               let is_favourite = data2["is_favourite"] as! Int
                               let is_today_log = data2["is_today_log"] as! Int
                               let is_workout = data2["is_workout"] as! Int
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func SetLogsVideoPage(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let HeadersAuth1 = ["Accept" : "application/json",
                           "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                            "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(logs_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        complition("", true)
                    }else{
                       let message = dic["message"] as! NSString
                        complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else if statusCode == 422{
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        complition("", true)
                    }else{
                       let errors = dic["errors"] as! NSDictionary
                        let error = errors["weight_unit"] as! NSString
                        complition(error as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func SetFavouritesVideoPage(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let HeadersAuth1 = ["Accept" : "application/json",
                           "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                            "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(favourites_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        let data = dic["data"] as! NSString
                        complition(data as String, true)
                    }else{
                       let message = dic["message"] as! NSString
                        complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else if statusCode == 422{
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        complition("", true)
                    }else{
                       let errors = dic["errors"] as! NSDictionary
                        let error = errors["weight_unit"] as! NSString
                        complition(error as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func FavouritesVideoPage(complition: @escaping(_ value: [VideoM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(favourites_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           if data.count == 0{
                               complition(Datalist,"Empty data", false)
                           }else{
                               for data2 in data{
                                   let id = data2["id"] as! Int
                                   let title = data2["title"] as? String ?? "title"
                                   let description = data2["description"] as? String ?? "description"
                                   let image = data2["image"] as! String
                                   let video = data2["video"] as! String
                                   let is_favourite = data2["is_favourite"] as! Int
                                   let is_today_log = data2["is_today_log"] as! Int
                                   let is_workout = data2["is_workout"] as! Int
                                   let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                                   Datalist.append(obj)
                               }
                               complition(Datalist,"", true)
                           }
                       }else{
                           complition(Datalist,"", false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func userscoaches(complition: @escaping(_ value: [UserscoachesM],_ value:Bool)-> Void){
           var Datalist : [UserscoachesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(userscoaches_url)\(Shared.shared.search)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let first_name = data2["first_name"] as? String ?? ""
                               let last_name = data2["last_name"] as? String ?? ""
                               let avatar = data2["avatar"] as? String ?? ""
                               let logo = data2["logo"] as? String ?? ""
                               let is_subscription = data2["is_subscription"] as? Bool ?? false
                               let obj = UserscoachesM(id: id, first_name: first_name, last_name: last_name, avatar: avatar, logo: logo, is_subscription: is_subscription)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func userscoachesSorNotification(complition: @escaping(_ id:Int,_ first_name:String,_ last_name:String,_ avatar:String,_ logo:String,_ value:Bool)-> Void){
           var Datalist : [UserscoachesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(userscoaches_url)/\(Shared.shared.notificationId)/show", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                               let id = data["id"] as? Int ?? 0
                               let first_name = data["first_name"] as? String ?? ""
                               let last_name = data["last_name"] as? String ?? ""
                               let avatar = data["avatar"] as? String ?? ""
                               let logo = data["logo"] as? String ?? ""
                           complition( id, first_name, last_name, avatar, logo, true)
                       }else{
                           complition( 0, "", "", "", "", false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func coachesusers(complition: @escaping(_ value: [UserscoachesM],_ value:Bool)-> Void){
           var Datalist : [UserscoachesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        
        Alamofire.request(training_personal_coach_url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let first_name = data2["name"] as! String
                               let avatar = data2["avatar"] as Any
                               let logo = data2["logo"] as? String ?? ""
                               let is_subscription = data2["is_subscription"] as? Bool ?? false
                               let obj = UserscoachesM(id: id, first_name: first_name, last_name: "", avatar: avatar as? String ?? "", logo: logo, is_subscription: is_subscription)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func assignedcoaches(param: [String: Any],complition: @escaping(_ value: [UserscoachesM],_ value:String,_ value:Bool,_ value:Bool)-> Void){
        var Datalist : [UserscoachesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(userscoaches_url)?skip=0&filter=assigned_coaches", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           if data.count != 0{
                               for data2 in data{
                                   let id = data2["id"] as! Int
                                   let first_name = data2["first_name"] as! String
                                   let last_name = data2["last_name"] as! String
                                   let avatar = data2["avatar"] as Any
                                   let logo = data2["logo"] as? String ?? ""
                                   let is_subscription = data2["is_subscription"] as? Bool ?? false
                                   let obj = UserscoachesM(id: id, first_name: first_name, last_name: last_name, avatar: avatar as? String ?? "", logo: logo, is_subscription: is_subscription)
                                   Datalist.append(obj)
                               }
                               complition(Datalist, "", true, true)
                           }else{
                               complition(Datalist, "No assigned coaches to show", true,  false)
                           }
                       }else{
                           complition(Datalist, errors as? String ?? "errors", false,  false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func supplementsApi(complition: @escaping(_ value: [NewsfeedM],_ value:Bool)-> Void){
           var Datalist : [NewsfeedM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
           Alamofire.request("\(supplements_url)\(Shared.shared.search)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as? Int ?? 0
                               let title = data2["title"] as? String ?? "title"
                               let description = data2["description"] as? String ?? "description"
                               let image = data2["image"] as? String ?? ""
                               let obj = NewsfeedM(id: id, image: image, title: title, description: description)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func recipesApi(complition: @escaping(_ value: [RecipesM],_ value:Bool)-> Void){
           var Datalist : [RecipesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
           Alamofire.request("\(recipes_url)\(Shared.shared.search)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as? String ?? "title"
                               let description = data2["description"] as? String ?? "description"
                               let image = data2["image"] as? String ?? ""
                               let name = data2["name"] as? String ?? "name"
                               let time = data2["time"] as? Int ?? 0
                               let ingredients = data2["ingredients"] as! [String]
                               var ingredient = ""
                               for i in ingredients{
                                   ingredient = "\(ingredient)\n \(i)\n"
                               }
                               
                               let obj = RecipesM(id: id, image: image, title: title, description: description, name: name, time: time, ingredient: ingredient)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func targetApi(complition: @escaping(_ calorie:Int,_ carb:Int,_ fat:Int,_ protein:Int,_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(target_url)?date=\(Shared.shared.monthto)-\(Shared.shared.datTo)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                               let calorie = data["target_calorie"] as! Int
                               let carb = data["target_carb"] as! Int
                               let fat = data["target_fat"] as! Int
                               let protein = data["target_protein"] as! Int
                           complition(calorie,carb,fat,protein,"", true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           var mes = ""
                           let message = errors["message"] != nil
                           if message{
                               let message = errors["message"] as! String
                               mes = message
                           }
                           complition(0,0,0,0,mes, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func SetTargetApi(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let HeadersAuth1 = ["Accept" : "application/json",
                           "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                            "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(target_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth1).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        complition("", true)
                    }else{
                       let message = dic["message"] as! NSString
                        complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else if statusCode == 422{
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        complition("", true)
                    }else{
                       let errors = dic["errors"] as! NSDictionary
                        let error = errors["weight_unit"] as! NSString
                        complition(error as String, false)
                    }
                case .failure(let error):
                    print(error)
                    complition("", false)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func FoodsApi(complition: @escaping(_ value: [FoodsM],_ value:Bool)-> Void){
           var Datalist : [FoodsM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(foods_url)\(Shared.shared.search)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as? Int ?? 0
                               let sku = data2["sku"] as? String ?? ""
                               let calorie = Double(data2["calorie"] as? String ?? "0.0") ?? 0.0
                               let carb = Double(data2["carb"] as? String ?? "0.0") ?? 0.0
                               let fat = Double(data2["fat"] as? String ?? "0.0") ?? 0.0
                               let protein = Double(data2["protein"] as? String ?? "0.0") ?? 0.0
                               let name = data2["name"] as? String ?? ""
                               let title = data2["title"] as? String ?? ""
                               let obj = FoodsM(id: id, sku: sku, calorie: calorie, carb: carb, fat: fat, protein: protein, name: name, title: title)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func FoodsUserApi(complition: @escaping(_ value: [BreakfastFoodM], _ value: [DinnerFoodM], _ value: [LunchFoodM], _ value: [SnackFoodM], _ value: [SupplementsFoodM],_ message: String,_ value: Int,_ value: Int,_ value: Int,_ value:Bool)-> Void){
            var datalistBreakfast : [BreakfastFoodM] = []
            var datalistDinner : [DinnerFoodM] = []
            var datalistLunch : [LunchFoodM] = []
            var datalistSnack : [SnackFoodM] = []
            var datalistSupplements : [SupplementsFoodM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(foods_url)/user?date=\(Shared.shared.monthto)-\(Shared.shared.datTo)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                            let exercise_target = data["exercise_target"] as? Int
                            let food_target = data["food_target"] as? Int
                            let user_target = data["user_target"] as? Int
                            let food = data["food"] as! NSDictionary
                                let breakfast = food["breakfast"] as! [[String:Any]]
                                let dinner = food["dinner"] as! [[String:Any]]
                                let lunch = food["lunch"] as! [[String:Any]]
                                let snack = food["snack"] as! [[String:Any]]
                                let supplements = food["supplements"] as! [[String:Any]]
                           for data2 in breakfast{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let user_food_id = data2["user_food_id"] as! Int
                               let obj = BreakfastFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: user_food_id)
                               datalistBreakfast.append(obj)
                           }
                           for data2 in dinner{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let user_food_id = data2["user_food_id"] as! Int
                               let obj = DinnerFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: user_food_id)
                               datalistDinner.append(obj)
                           }
                           for data2 in lunch{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let user_food_id = data2["user_food_id"] as! Int
                               let obj = LunchFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: user_food_id)
                               datalistLunch.append(obj)
                           }
                           for data2 in snack{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let user_food_id = data2["user_food_id"] as! Int
                               let obj = SnackFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: user_food_id)
                               datalistSnack.append(obj)
                           }
                           for data2 in supplements{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let user_food_id = data2["user_food_id"] as! Int
                               let obj = SupplementsFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: user_food_id)
                               datalistSupplements.append(obj)
                           }
                           complition(datalistBreakfast, datalistDinner, datalistLunch, datalistSnack, datalistSupplements,"", user_target ?? 0, food_target ?? 0, exercise_target ?? 0, true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let message = errors["message"] as! String
                           complition(datalistBreakfast, datalistDinner, datalistLunch, datalistSnack, datalistSupplements,message, 0, 0, 0, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func nutritionNumbersApi(complition: @escaping(_ message: String,_ carb: Int,_ fat: Int,_ protein: Int,_ calories: Int,_ target_carb: Int,_ target_fat: Int,_ target_protein: Int,_ target_calorie: Int,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(foods_url)/user?date=\(Shared.shared.monthto)-\(Shared.shared.datTo)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let carb = data["carb"] as? Int ?? 0
                           let fat = data["fat"] as? Int ?? 0
                           let protein = data["protein"] as? Int ?? 0
                           let calories = data["food_target"] as? Int ?? 0
                           let user = data["user"] as! NSDictionary
                           let target_carb = Int(user["target_carb"] as? String ?? "") ?? 0
                           let target_fat = Int(user["target_fat"] as? String ?? "") ?? 0
                           let target_protein = Int(user["target_protein"] as? String ?? "") ?? 0
                           let target_calorie = Int(user["target_calorie"] as? String ?? "") ?? 0
                           complition("",carb, fat, protein, calories, target_carb, target_fat, target_protein, target_calorie, true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let message = errors["message"] as! String
                           complition(message,0, 0, 0, 0, 0, 0, 0, 0, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func foodPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(foods_url)/user", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           complition("",true)
                       }else{
                           complition(errors as! String,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func deleteFoodPost(foodId:Int,complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(deleteFoods_url)/\(foodId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let message = data["message"] as? String ?? ""
                           complition(message,true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           
                           complition(errors as! String,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func ChallengesApi(complition: @escaping(_ value: [ChallengesM],_ value:String,_ value:Bool,_ value:Bool)-> Void){
           var Datalist : [ChallengesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(challenges_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as? String ?? "title"
                               let description = data2["description"] as? String ?? "description"
                               let icon = data2["icon"] as! String
                               let idIn = data2["id"] as! Int
                               let obj = ChallengesM(id: id, idIn: idIn, title: title, description: description, icon: icon)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true, true)
                       }else{
                           complition(Datalist,"", true, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist,"app.please_add_new_package", false, false)
               }
            }
        }
    func ChallengesVideoApi(complition: @escaping(_ value: [ChallengesVideoM],_ value:String,_ value:Bool,_ value:Bool)-> Void){
           var Datalist : [ChallengesVideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(challenges_url)/videos?challenge_id=\(Shared.shared.challenge_id)&coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let is_complete = data2["is_complete"] as! Bool
                               let videoDic = data2["video"] as! NSDictionary
                               let image = videoDic["image"] as? String ?? ""
                               let title = videoDic["title"] as? String ?? ""
                               let video = videoDic["video"] as? String ?? ""
                               let obj = ChallengesVideoM(id: id, idIn: 0, is_complete: is_complete, title: title, description: "description", image: image, video: video, is_favourite: true, is_today_log: true, is_workout: true)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true, true)
                       }else{
                           complition(Datalist,"", false, true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist,"", false, false)
               }
            }
        }
    func postComplete(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool,_ value:Bool) -> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(challenges_url)/complete", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON{ (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", true, false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let success = dic["success"] as! NSNumber
                if success == 1{
                    let data = dic["data"] as! String
                    completion(data, true, true)
                }else{
                    let errors = dic["errors"] as! NSString
                    completion(errors as String, true, false)
                 }
            }
          }else if statusCode == 403{
              completion("", false, false)
          }
        }
    }
    func trainingWorkoutApi(complition: @escaping(_ value: [NewsfeedM],_ value:Bool,_ value:Bool)-> Void){
           var Datalist : [NewsfeedM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
           Alamofire.request("\(training_workout_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as? String ?? "title"
                               let description = data2["description"] as? String ?? "description"
                               let icon = data2["icon"] as? String ?? ""
                               let obj = NewsfeedM(id: id, image: icon, title: title, description: description)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true, true)
                       }else{
                           complition(Datalist, false, true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist, false, false)
               }
            }
        }
    func trainingWorkoutVideoPage(complition: @escaping(_ value: [VideoM],_ value:String,_ value:Bool,_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(training_workout_url)/\(Shared.shared.exercise_id)/show?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as! String
                               let description = data2["description"] as! String
                               let image = data2["image"] as! String
                               let video = data2["video"] as! String
                               let is_favourite = data2["is_favourite"] as! Int
                               let is_today_log = data2["is_today_log"] as! Int
                               let is_workout = data2["is_workout"] as! Int
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, "", true, true)
                       }else{
                           let data2 = dic["errors"] as! NSDictionary
                           let message = data2["message"] as! String
                           complition(Datalist, message, false, true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition(Datalist, "", false, false)
               }
            }
        }
    func trainingRecipeApi(complition: @escaping(_ value: [RecipesM],_ value:Bool)-> Void){
           var Datalist : [RecipesM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
           Alamofire.request("\(training_recipe_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as! String
                               let description = data2["description"]as! String
                               let image = data2["image"]as! String
                               let name = data2["name"]as! String
                               let time = data2["time"] as? Int ?? 0
                               let ingredients = data2["ingredients"] as! [String]
                               var ingredient = ""
                               for i in ingredients{
                                   ingredient = "\(ingredient)\n \(i)\n"
                               }
                               let obj = RecipesM(id: id, image: image, title: title, description: description, name: name, time: time, ingredient: ingredient)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func trainingPersonalApi(complition: @escaping(_ value: [PersonalizedVideoM],_ value: [PersonalizedImageM],_ value: [PersonalizedPdfM],_ value:Bool)-> Void){
            var DatalistVideo : [PersonalizedVideoM] = []
            var DatalistImage : [PersonalizedImageM] = []
            var DatalistPdf : [PersonalizedPdfM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
           Alamofire.request("\(training_personal_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           if data.count != 0{
                               let video = data["video"] as! [[String:Any]]
                               for i in video{
                               let id = i["id"] as! Int
                               let value = i["value"] as! String
                               let obj = PersonalizedVideoM(id: id, value: value)
                               DatalistVideo.append(obj)
                           }
                               let image = data["image"] as! [[String:Any]]
                               for i in image{
                               let id = i["id"] as! Int
                               let value = i["value"] as! String
                               let obj = PersonalizedImageM(id: id, value: value)
                               DatalistImage.append(obj)
                           }
                               let pdf = data["pdf"] as! [[String:Any]]
                               for i in pdf{
                               let id = i["id"] as! Int
                               let value = i["value"] as! String
                               let obj = PersonalizedPdfM(id: id, value: value)
                               DatalistPdf.append(obj)
                           }
                            complition(DatalistVideo,DatalistImage,DatalistPdf, true)
                           }
                       }else{
                           complition(DatalistVideo,DatalistImage,DatalistPdf, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func healthsApi(complition: @escaping(_ value:[HealthsM],_ value:Bool)-> Void){
            var Datalist : [HealthsM] = []
            var key = ""
            var valueKey = 0
            let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                         "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.getusertype() == "Coach"{
            url = "\(healths_url)?user_id=\(Shared.shared.selectUserInCoach)"
        }else{
            url = healths_url
        }
           Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let weight = data2["weight"] != nil
                               if weight{
                                   let weight = Int((data2["weight"] as? String) ?? "") ?? 0
                                   valueKey = weight
                                   key = "weight"
                                   Shared.shared.healthsWeight = weight
                               }
                               let muscle = data2["muscle"] != nil
                               if muscle{
                                   let muscle = Int(data2["muscle"] as? String ?? "0") ?? 0
                                   valueKey = muscle
                                   key = "muscle"
                                   Shared.shared.healthsMuscle = muscle
                               }
                               let fat = data2["fat"] != nil
                               if fat{
                                   let fat = Int(data2["fat"] as? String ?? "0") ?? 0
                                   valueKey = fat
                                   key = "fat"
                                   Shared.shared.healthsFat = fat
                               }
                               let water = data2["water"] != nil
                               if water{
                                   let water = Int(data2["water"] as? String ?? "0") ?? 0
                                   valueKey = water
                                   key = "water"
                                   Shared.shared.healthsWater = water
                               }
                               let active_calories = data2["active_calories"] != nil
                               if active_calories{
                                   let active_calories = Int(data2["active_calories"] as? String ?? "0") ?? 0
                                   valueKey = active_calories
                                   key = "active_calories"
                                   Shared.shared.healthsActiveCalories = active_calories
                               }
                               let steps = data2["steps"] != nil
                               if steps{
                                   let steps = Int(data2["steps"] as? String ?? "0") ?? 0
                                   valueKey = steps
                                   key = "steps"
                                   Shared.shared.healthsSteps = steps
                               }
                               let percentage = data2["percentage"] as! NSDictionary
                               let value = percentage["value"] as! NSNumber
                               let type = percentage["type"] as! String
                               let obj = HealthsM(key: key, valueKey: valueKey, value: Double(value), type: type)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func BodyMPage(complition: @escaping(_ value:[BodyMeasurementsM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [BodyMeasurementsM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.getusertype() == "Coach"{
            url = "\(body_measurements_url)?user_id=\(Shared.shared.selectUserInCoach)"
        }else{
            url = body_measurements_url
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let date = data2["date"] as! String
                               var splitDate = date.split(separator: "T")
                               let neck = Double((data2["neck"] as? String) ?? "0.0") ?? 0.0
                               let chest = Double((data2["chest"] as? String) ?? "0.0") ?? 0.0
                               let left_arm = Double((data2["left_arm"] as? String) ?? "0.0") ?? 0.0
                               let right_arm = Double((data2["right_arm"] as? String) ?? "0.0") ?? 0.0
                               let waist = Double((data2["waist"] as? String) ?? "0.0") ?? 0.0
                               let belly = Double((data2["belly"] as? String) ?? "0.0") ?? 0.0
                               let lower_belly = Double((data2["lower_belly"] as? String) ?? "0.0") ?? 0.0
                               let upper_belly = Double((data2["upper_belly"] as? String) ?? "0.0") ?? 0.0
                               let hips = Double((data2["hips"] as? String) ?? "0.0") ?? 0.0
                               let left_thigh = Double((data2["left_thigh"] as? String) ?? "0.0") ?? 0.0
                               let right_thigh = Double((data2["right_thigh"] as? String) ?? "0.0") ?? 0.0
                               let lift_calf = Double((data2["lift_calf"] as? String) ?? "0.0") ?? 0.0
                               let right_calf = Double((data2["right_calf"] as? String) ?? "0.0") ?? 0.0
                               let obj = BodyMeasurementsM(date: String(splitDate[0]), neck: neck, chest: chest, left_arm: left_arm, right_arm: right_arm, waist: waist, belly: belly, lower_belly: lower_belly, upper_belly: upper_belly, hips: hips, left_thigh: left_thigh, right_thigh: right_thigh, lift_calf: lift_calf, right_calf: right_calf)
                               Datalist.append(obj)
                           }
                           Shared.shared.permissionBody = "yes"
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,"", false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   Shared.shared.permissionBody = "no"
                   complition(Datalist,"No permission", false)
               }
            }
        }
    func BodyMPost(param:[String:Any],complition: @escaping(_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(body_measurements_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           complition(true)
                       }else{
                           complition(false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func healthsPost(param:[String:Any],complition: @escaping(_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(healths_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           complition(true)
                       }else{
                           complition(false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func PackagesApi(complition: @escaping(_ value:[PackegeSubscriptionM],_ value:[PackegePTM],_ value:Bool)-> Void){
        var Datalist : [PackegeSubscriptionM] = []
        var Datalist2 : [PackegePTM] = []
        var permissionsCallVideo = 0
        var permissionsWorkoutSchedule = false
        var permissionsFoodPlan = false
        var is_shop = false
        var can_shop = true
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(packages_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let subscription = data["subscription"] as! [[String:Any]]
                           for data2 in subscription{
                               let id = data2["id"] as! Int
                               let name = data2["name"] as? String ?? ""
                               let description = data2["description"] as? String ?? ""
                               let price_object = data2["price_object"] as! NSDictionary
                               let amount = price_object["amount"] as? String ?? ""
                               let currency = price_object["currency"] as? String ?? ""
                               let price = "\(String(format: "%.0f", ceil(Double(amount) ?? 0.0))) \(currency)"
                               let style = data2["style"] as? String ?? ""
                               let purchase_apple_id = data2["purchase_apple_id"] as? String ?? ""
                               let date = data2["date"] as? Double ?? 0.0
                               let is_free = data2["is_free"] as? Bool ?? false
                               let permissions = data2["permissions"] as? NSDictionary
                               if permissions != nil{
                                    permissionsCallVideo = permissions?["call_video"] as? Int ?? 0
                                    permissionsWorkoutSchedule = permissions?["workout_schedule"] as! Bool
                                    permissionsFoodPlan = permissions!["food_plan"] as! Bool
                               }
                               var startAndEndDate = ""
                               if data2["user_package"] is [String:Any] {
                                   is_shop = true
                                   can_shop = false
                                   let date5 = data2["user_package"] as? NSDictionary
                                   let end_date = date5?["end_date"] as? String ?? "End date"
                                   let start_date = date5?["start_date"] as? String ?? "Start date"
                                   startAndEndDate = "Start date: \(start_date)  End date: \(end_date)"
                               }else{
                                   is_shop = false
                                   can_shop = true
                               }
                               let obj = PackegeSubscriptionM(id: id, name: name, description: description, price: price, style: style, date: date, is_free: is_free, is_shop: is_shop, can_shop: can_shop, permissionsCallVideo: permissionsCallVideo, permissionsWorkoutSchedule: permissionsWorkoutSchedule, permissionsFoodPlan: permissionsFoodPlan, purchase_apple_id: purchase_apple_id, startAndEndDate: startAndEndDate)
                               Datalist.append(obj)
                           }
                           let personal_training = data["personal_training"] as! [[String:Any]]
                           for data2 in personal_training{
                               let id = data2["id"] as! Int
                               let name = data2["name"] as! String
                               let description = data2["description"] as! String
                               let price_object = data2["price_object"] as! NSDictionary
                               let amount = price_object["amount"] as? String ?? ""
                               let currency = price_object["currency"] as? String ?? ""
                               let price = "\(String(format: "%.0f", ceil(Double(amount) ?? 0.0))) \(currency)"
                               let style = data2["style"] as! String
                               let purchase_apple_id = data2["purchase_apple_id"] as? String ?? ""
                               let date = Double(data2["date"] as! Int) ?? 0.0
                               let is_free = data2["is_free"] as! Bool
                               let permissions = data2["permissions"] as? NSDictionary
                               if permissions != nil{
                                   permissionsCallVideo = permissions?["call_video"] as? Int ?? 0
                                   permissionsWorkoutSchedule = permissions?["workout_schedule"] as! Bool
                                   permissionsFoodPlan = permissions?["food_plan"] as! Bool
                               }
                               var startAndEndDate = ""
                               if data2["user_package"] is [String:Any] {
                                   is_shop = true
                                   can_shop = false
                                   let date5 = data2["user_package"] as? NSDictionary
                                   let end_date = date5?["end_date"] as? String ?? "End date"
                                   let start_date = date5?["start_date"] as? String ?? "Start date"
                                   startAndEndDate = "Start date: \(start_date)  End date: \(end_date)"
                               }else{
                                   is_shop = false
                                   can_shop = true
                               }
                               let obj = PackegePTM(id: id, name: name, description: description, price: price, style: style, date: date, is_free: is_free, is_shop: is_shop, can_shop: can_shop, permissionsCallVideo: permissionsCallVideo, permissionsWorkoutSchedule: permissionsWorkoutSchedule, permissionsFoodPlan: permissionsFoodPlan, purchase_apple_id: purchase_apple_id, startAndEndDate: startAndEndDate)
                               Datalist2.append(obj)
                           }

                           complition(Datalist,Datalist2, true)
                       }else{
                           complition(Datalist,Datalist2, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func packagePost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(packages_url)", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let url = data["url"] as? String ?? ""
                           complition(url,true)
                       }else{
                           let errors = dic["errors"] as? String ?? ""
//                           let message = errors["payment_method"] as! String
                           complition(errors,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func promoCodePost(param:[String:Any],complition: @escaping(_ discount:String,_ old_price:String,_ price:Double,_ message:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(promoـcode_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let discount = data["discount"] as! String
                           let old_price = data["old_price"] as! String
                           let price = data["price"] as! Double
                           complition(discount, old_price, price, "",true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           
                           let message = errors["message"] as! String
                           complition("", "", 0.0,message,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func questionsPage(complition: @escaping(_ value:[QuestionsM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [QuestionsM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(questions_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let question = data2["question"] as! String
                               let answer = data2["answer"] as? String ?? ""
                               let obj = QuestionsM(id: id, question: question, answer: answer)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,errors as! String, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func questionsCoachPage(complition: @escaping(_ value:[QuestionsM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [QuestionsM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(questions_url)/\(Shared.shared.selectUserInCoach)/by-user", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 || statusCode == 404 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let question = data2["question"] as! String
                               let answer = data2["answer"] as? String ?? ""
                               let obj = QuestionsM(id: id, question: question, answer: answer)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,errors as! String, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func questionsPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(questions_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as? String ?? ""
                           complition(data,true)
                       }else{
                           complition("",false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func coachCalendarPage(complition: @escaping(_ value:[AvailableM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [AvailableM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(coach_calendar_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)&date=\(Shared.shared.monthto)-\(Shared.shared.datTo)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let time = data2["time"] as! String
                               let is_auto_accept = data2["is_auto_accept"] as! Bool
                               let is_available = data2["is_available"] as! Bool
                               let obj = AvailableM(id: id, time: time, is_auto_accept: is_auto_accept, is_available: is_available)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,errors as! String, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func reservationPost(param:[String:Any],complition: @escaping(_ created_at:String,_ duration1:String,_ join_url:String,_ value:String,_ value:Bool,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(coach_calendar_reservation_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let zoom = data["zoom"] as! NSDictionary
                           let data2 = zoom["data"] as! NSDictionary
                           let created_at = data2["created_at"] as? String ?? ""
                           let duration = data2["duration"] as? String ?? ""
                           let join_url = data2["join_url"] as? String ?? ""
                           let status = dic["status"] as Any
                           complition(created_at, duration, join_url, "status : \(status as? String ?? "")",true,true)
                       }else{
                           complition("","","",errors as! String,false,true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition("", "", "", "", false, false)
               }
            }
        }
    func feedbackPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(ticket_feedback, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           complition("",true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let message = errors["message"] as? String ?? ""
                           complition(message,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func technicalSupportPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(ticket_technical_support, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           complition("",true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let message = errors["message"] as? String ?? ""
                           complition(message,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func videoChatUserPage(complition: @escaping(_ value:[VideoChatCoachM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [VideoChatCoachM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var startLink = ""
        Alamofire.request("\(videoChat_user_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let userId = data2["user_id"] as! Int
                               let timeLink = data2["time"] as? String ?? "time"
                               let dateLink = data2["date"] as? String ?? "time"
                               let coach_time_reservation = data2["coach_time_reservation"] as! NSDictionary
                               let zoom = coach_time_reservation["zoom"] as! NSDictionary
                               let success = zoom["success"] as! Bool
                               if success == true{
                                   let data = zoom["data"] as! NSDictionary
                                   startLink = data["join_url"] as? String ?? "join_url"
                               }
                               let statusUser = coach_time_reservation["status"] as? String ?? "status"
                               let obj = VideoChatCoachM(id: id, userId: userId, nameUser: "nameUser", startLink: startLink, timeLink: timeLink, dateLink: dateLink, statusUser: statusUser)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,errors as! String, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func cancelReservationPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(cancel_reservation_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           complition("",true)
                       }else{
                           complition(errors as! String,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func workoutHistoryApi(complition: @escaping(_ value: [VideoM],_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.getusertype() == "Coach"{
            url = "\(workout_url)?user_id=\(Shared.shared.selectUserInCoach)&date=\(Shared.shared.monthto)-\(Shared.shared.datTo)"
        }else{
            url = "\(workout_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)&date=\(Shared.shared.monthto)-\(Shared.shared.datTo)"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as! String
                               let description = data2["description"] as! String
                               let image = data2["image"] as! String
                               let video = data2["video"] as! String
                               let is_favourite = data2["is_favourite"] as! Int
                               let is_today_log = data2["is_today_log"] as! Int
                               let is_workout = data2["is_workout"] as! Int
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else{
                   complition(Datalist, false)
               }
            }
        }
    func exercisesHistoryApi(complition: @escaping(_ value: [VideoM],_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.getusertype() == "Coach"{
            url = "\(Exercises_history_url)?user_id=\(Shared.shared.selectUserInCoach)"
        }else{
            url = "\(Exercises_history_url)?coach_id=\(Shared.shared.getCoachId() ?? 0)"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as? Int ?? 0
                               let title = data2["title"] as? String ?? ""
                               let description = data2["description"] as? String ?? ""
                               let image = data2["image"] as? String ?? ""
                               let video = data2["video"] as? String ?? ""
                               let is_favourite = data2["is_favourite"] as? Int ?? 0
                               let is_today_log = data2["is_today_log"] as? Int ?? 0
                               let is_workout = data2["is_workout"] as? Int ?? 0
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else{
                   complition(Datalist, false)
               }
            }
        }
    func exercisesHistoryDetailsApi(id:String,complition: @escaping(_ value: [exercisesHistoryDetailsM],_ value:Bool)-> Void){
           var Datalist : [exercisesHistoryDetailsM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.getusertype() == "Coach"{
            url = "\(Exercises_history_url)/\(id)/show?user_id=\(Shared.shared.selectUserInCoach)"
        }else{
            url = "\(Exercises_history_url)/\(id)/show"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let created_at = data2["created_at"] as? String ?? ""
                               let weight_unit = data2["weight_unit"] as? String ?? ""
                               let note = data2["note"] as? String ?? ""
                               let number = data2["number"] as? Int ?? 0
                               let weight = Double(data2["weight"] as? String ?? "0") ?? 0
                               let repetition = Int(data2["repetition"] as? String ?? "0") ?? 0
                               let obj = exercisesHistoryDetailsM(id: id, created_at: created_at, weight_unit: weight_unit, number: number, weight: weight, repetition: repetition, note: note)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else{
                   complition(Datalist, false)
               }
            }
        }
    func nutritionHistoryApi2(complition: @escaping(_ carb: Int,_ fat: Int,_ protein: Int,_ calories: Int,_ value: [BreakfastFoodM], _ value: [DinnerFoodM], _ value: [LunchFoodM], _ value: [SnackFoodM], _ value: [SupplementsFoodM],_ value: Int,_ value: Int,_ value: Int,_ value: Int,_ value:Bool)-> Void){
            var datalistBreakfast : [BreakfastFoodM] = []
            var datalistDinner : [DinnerFoodM] = []
            var datalistLunch : [LunchFoodM] = []
            var datalistSnack : [SnackFoodM] = []
            var datalistSupplements : [SupplementsFoodM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.getusertype() == "Coach"{
            url = "\(Nutrition_history_url)?user_id=\(Shared.shared.selectUserInCoach)&date=\(Shared.shared.monthto)-\(Shared.shared.datTo)"
        }else{
            url = "\(Nutrition_history_url)?date=\(Shared.shared.monthto)-\(Shared.shared.datTo)"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                            let exercise_target = data["exercise_target"] as? Int
                            let food_target = data["food_target"] as? Int
                            let user_target = data["user_target"] as? Int
                           let carb = data["carb"] as? Int ?? 0
                           let fat = data["fat"] as? Int ?? 0
                           let protein = data["protein"] as? Int ?? 0
                           let calories = data["food_target"] as? Int ?? 0
                            let food = data["food"] as! NSDictionary
                                let breakfast = food["breakfast"] as! [[String:Any]]
                                let dinner = food["dinner"] as! [[String:Any]]
                                let lunch = food["lunch"] as! [[String:Any]]
                                let snack = food["snack"] as! [[String:Any]]
                                let supplements = food["supplements"] as! [[String:Any]]
                           for data2 in breakfast{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let obj = BreakfastFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: 0)
                               datalistBreakfast.append(obj)
                           }
                           for data2 in dinner{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let obj = DinnerFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: 0)
                               datalistDinner.append(obj)
                           }
                           for data2 in lunch{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let obj = LunchFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: 0)
                               datalistLunch.append(obj)
                           }
                           for data2 in snack{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let obj = SnackFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: 0)
                               datalistSnack.append(obj)
                           }
                           for data2 in supplements{
                               let id = data2["id"] as! Int
                               let sku = data2["sku"] as! String
                               let calorie = data2["calorie"] as! Double
                               let carb = data2["carb"] as! Double
                               let fat = data2["fat"] as! Double
                               let protein = data2["protein"] as! Double
                               let name = data2["name"] as! String
                               let title = data2["title"] as! String
                               let obj = SupplementsFoodM(id: id, sku: sku, name: name, title: title, calorie: calorie, carb: carb, fat: fat, protein: protein, user_food_id: 0)
                               datalistSupplements.append(obj)
                           }
                           let user = data["user"] as! NSDictionary
                           let target_carb = user["target_carb"] as? Int
                           let target_fat = user["target_fat"] as? Int
                           let target_protein = user["target_protein"] as? Int
                           let target_calorie = user["target_calorie"] as? Int
                           complition(carb, fat, protein, calories, datalistBreakfast, datalistDinner, datalistLunch, datalistSnack, datalistSupplements, target_carb ?? 0, target_fat ?? 0, target_protein ?? 0, target_calorie ?? 0, true)
                       }else{
                           complition(0, 0, 0, 0, datalistBreakfast, datalistDinner, datalistLunch, datalistSnack, datalistSupplements, 0, 0, 0, 0, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func nutritionHistoryApi(complition: @escaping(_ value: [VideoM],_ value:Bool)-> Void){
           var Datalist : [VideoM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(Nutrition_history_url)?date=\(Shared.shared.monthto)-\(Shared.shared.datTo)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let title = data2["title"] as! String
                               let description = data2["description"] as! String
                               let image = data2["image"] as! String
                               let video = data2["video"] as! String
                               let is_favourite = data2["is_favourite"] as! Int
                               let is_today_log = data2["is_today_log"] as! Int
                               let is_workout = data2["is_workout"] as! Int
                               let obj = VideoM(id: id, title: title, description: description, image: image, video: video, is_favourite: is_favourite, is_today_log: is_today_log, is_workout: is_workout)
                               Datalist.append(obj)
                           }
                           complition(Datalist, true)
                       }else{
                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func chatPostApi(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(chat_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let chat_id = data["chat_id"] as? NSNumber ?? 0
                           complition("\(chat_id)",true,true)
                       }else{
                           complition(errors as! String,false,true)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }else if statusCode == 403{
                   complition("",false,false)
               }
            }
        }
    func getChatApi(chat_id:String,complition: @escaping(_ chat: [ChatM],_ message:String,_ bool:Bool)-> Void){
        var dataList : [ChatM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(chat_url)/\(chat_id)/messages?skip=0", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let success = dic["success"] as! NSNumber
                    if success == 1{
                        let data1 = dic["data"] as! [[String:Any]]
                        for data in data1{
                        let id = data["id"] as? Int ?? 0
                        let chat_id = data["chat_id"] as? Int ?? 0
                        let sender_id = data["sender_id"] as? Int ?? 0
                        let message = data["message"] as? String ?? "message"
                        let type = data["type"] as? String ?? "type"
                        let obj = ChatM(id: id, chat_id: chat_id, sender_id: sender_id, message: message, type: type)
                        dataList.append(obj)
                        }
                        complition(dataList,"", true)
                    }else{
                       let errors = dic["errors"] as! NSDictionary

                       complition(dataList,"phone_number as String", false)
                    }
                case .failure(let error):
                    print(error)
                    complition(dataList,"", false)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func updateNotificationsApi(complition: @escaping(_ value:String,_ value:Bool)-> Void){
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request(update_notifications_url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let is_send_notification = data["is_send_notification"] as Any
                           Shared.shared.isSendNotification(auth: is_send_notification as? Bool ?? false)
                           complition("Successful",true)
                       }else{
                           complition(errors as? String ?? "",false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
// Coach
    func SignupCoach(param: [String: Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
                Alamofire.request(postsignupCoach_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 || statusCode == 422 {
                        switch response.result {
                        case .success(let value):
                            let dic = value as! NSDictionary
                            let success = dic["success"] as? NSNumber
                            if success == 1{
                                let data = dic["data"] as? String ?? ""
                                complition(data, true)
                            }else{
                                var message = ""
                                let errors = dic["errors"] as! NSDictionary
                                let full_name = errors["full_name"] != nil
                                if full_name{
                                    let full_name = errors["full_name"] as? String ?? ""
                                    message = full_name
                                }
                                complition(message, false)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }else{
                        complition("Something wrong!" as String, false)
                    }
                      }
             }
    func verifyEmailPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        Alamofire.request(postVerifyEmail_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let token = data["token"] as? String ?? ""
                           Shared.shared.token = token
                           complition("",true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let email = errors["email"] as? String ?? ""
                           complition(email,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func verifyEmailResetPasswordPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        Alamofire.request(postVerifyEmailResetPassword_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! NSDictionary
                           let token = data["token"] as? String ?? ""
                           Shared.shared.token = token
                           complition("",true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let email = errors["email"] as? String ?? ""
                           complition(email,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func checkCodePost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        Alamofire.request(postCheckCode_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! String
                           complition(data,true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let message = errors["message"] as? String ?? ""
                           complition(message ,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func resetPasswordPost(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        Alamofire.request(postResetPassword_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! String
                           complition(data,true)
                       }else{
                           let errors = dic["errors"] as! NSDictionary
                           let message = errors["password"] as? String ?? ""
                           complition(message ,false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func personalTraningCoachPage(complition: @escaping(_ value:[TrainingPersonalCoachM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [TrainingPersonalCoachM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.search == ""{
            url = "\(training_personal_coach_url)\(Shared.shared.search)?\(Shared.shared.listOfCoach)"
        }else{
            url = "\(training_personal_coach_url)\(Shared.shared.search)&\(Shared.shared.listOfCoach)"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let avatar = data2["avatar"] as? String ?? "avatar"
                               let name = data2["name"] as? String ?? "name"
                               let start_date = data2["start_date"] as? String ?? "start_date"
                               let end_date = data2["end_date"] as? String ?? "end_date"
                               let package_name = data2["package_name"] as? String ?? "package_name"
                               let type = data2["type"] as? String ?? "type"
                               let obj = TrainingPersonalCoachM(id: id, avatar: avatar, name: name, start_date: start_date, end_date: end_date, package_name: package_name, type: type)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,errors as! String, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func calendarCoachPage(complition: @escaping(_ value:[CalenderCoachM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [CalenderCoachM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        Alamofire.request("\(calender_coach_url)?skip=\(Shared.shared.countOfProducts)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           if data.count == 0{
                               Shared.shared.Skip = 2
                           }else{
                               if LanguageManager.shared.currentLanguage == .en{
                                   let obj1 = CalenderCoachM(id: 0, date: "Date", time: "Time", status: "Status", user_name: "Name", is_auto_accept: false)
                                   Datalist.append(obj1)
                               }else{
                                   let obj1 = CalenderCoachM(id: 0, date: "التاريخ", time: "الوقت", status: "الحالة", user_name: "الإسم", is_auto_accept: false)
                                   Datalist.append(obj1)
                               }
                               for data2 in data{
                                   let id = data2["id"] as! Int
                                   let date = data2["date"] as? String ?? "date"
                                   let time = data2["time"] as? String ?? "time"
                                   let status = data2["status"] as? String ?? "status"
                                   let user_name = data2["user_name"] as? String ?? "user"
                                   let is_auto_accept = data2["is_auto_accept"] as? Bool ?? false
                                   let obj = CalenderCoachM(id: id, date: date, time: time, status: status, user_name: user_name, is_auto_accept: is_auto_accept)
                                   Datalist.append(obj)
                                   Shared.shared.Skip = 1
                                   Shared.shared.countOfProducts = +Datalist.count
                               }
                           }

                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,errors as! String, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    func videoChatCoachPage(complition: @escaping(_ value:[VideoChatCoachM],_ value:String,_ value:Bool)-> Void){
           var Datalist : [VideoChatCoachM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                     "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var startLink = ""
        Alamofire.request(videoChat_coach_url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           for data2 in data{
                               let id = data2["id"] as! Int
                               let userId = data2["user_id"] as! Int
                               let timeLink = data2["time"] as? String ?? "time"
                               let dateLink = data2["date"] as? String ?? "date"
                               let coach_time_reservation_accept = data2["coach_time_reservation_accept"] as! NSDictionary
                               let zoom = coach_time_reservation_accept["zoom"] as! NSDictionary
                               let success = zoom["success"] as! Bool
                               if success == true{
                                   let data = zoom["data"] as! NSDictionary
                                   startLink = data["start_url"] as? String ?? "start_url"
                               }
                               let user = coach_time_reservation_accept["user"] as! NSDictionary
                               let fNameUser = user["first_name"] as? String ?? "first_name"
                               let lNameUser = user["last_name"] as? String ?? "last_name"
                               let nameUser = "\(fNameUser) \(lNameUser)"
                               let statusUser = user["status"] as? String ?? "status"
                               let obj = VideoChatCoachM(id: id, userId: userId, nameUser: nameUser, startLink: startLink, timeLink: timeLink, dateLink: dateLink, statusUser: statusUser)
                               Datalist.append(obj)
                           }
                           complition(Datalist,"", true)
                       }else{
                           complition(Datalist,errors as! String, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
}
