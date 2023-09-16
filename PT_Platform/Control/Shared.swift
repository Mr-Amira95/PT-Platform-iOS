//
//  Shared.swift
//  PT_Platform
//
//  Created by QTechnetworks on 23/01/2022.
//

import Foundation
import UIKit
import OneSignal
import MessageKit


final class Shared {
    static let shared = Shared()
    
    var platform = "ios"
    var timezone = "Asin/Amman"
    
    let device_player_id = OneSignal.getDeviceState().userId
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    
    var btnBack = ""
    var btnSubBack = ""
    var nameUser = ""
    var imgUser = ""
    var yourTrainerid = 2
    
    var nameSupplements = ""
    var imgSupplements = ""
    
    var usertype = ""
    //MARK:-Newsfeed
    var NewsImage = ""
    var NewsTitle = ""
    var NewsDescription = ""
    //    Recipes
    var RecipesName = ""
    var RecipesTime = ""
    var RecipesIngredients = ""
    var coach_id = 2
    var group_id = 0
    var video_id = 0
    var exercise_id = 0
    var exercise_img = ""
    var exercise_name = ""
    var exercise_description = ""
    var bannerIn = ""
    
    var challenge_id = 0
    var activity = 0.0
    
    var healthsWeight = 0
    var healthsMuscle = 0
    var healthsFat = 0
    var healthsWater = 0
    var healthsActiveCalories = 0
    var healthsSteps = 0
    
    var bodyMArray : NSArray = []
    var subscriptionMArray : NSArray = []
    var pTMArray : NSArray = []
    var coachMArray : NSArray = []
    
    var PersonalizedVideoMArray : NSArray = []
    var PersonalizedImageMArray : NSArray = []
    var PersonalizedPdfMMArray : NSArray = []
    
    var BreakfastFoodMArray : NSArray = []
    var DinnerFoodMArray : NSArray = []
    var LunchFoodMArray : NSArray = []
    var SnackFoodMArray : NSArray = []
    var SupplementsFoodMArray : NSArray = []
    var FoodListMArray : NSArray = []
    var FoodListId = 0
    
    var packageName = ""
    var packagePrice = ""
    var packageDuration = ""
    var packageDes = ""
    var packageId = ""
    var packageIsFree = false
    var packageFeatures = ""
    var packagePurchaseAppleId = ""
    
    var permissionBody = "no"
    
    
    var dayfrom = "From"
    var monthfrom = "To"
    var monthto = ""
    var datTo = ""
    var calendarType = 0
    var calendarTimeId = 0
    var calendarTimeValue = ""
    var calendarEnterScreen = ""
    
    var typeFood = ""
    
    var token = ""
    var selectUserInCoach = 0
    var selectUserInCoachName = ""
    var search = ""
    var listOfCoach = ""
    
    var nutritionCalories = ""
    var nutritionCarbs = ""
    var nutritionFat = ""
    var nutritionProtein = ""
    var enterListUser = ""
    
    var imgFav = ""
    var urlFav = ""
    var titleFav = ""
    var descriptionFav = ""
    var notificationType = ""
    var notificationId = ""
    var verifyEmailType = ""
    var Skip = 0
    var countOfProducts = 0
    
    
    //MARK:-UserInfo
    func SavetUserToken(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_token")
        def.synchronize()
    }
    func getUserToken()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_token" ) as? String
    }
    
    
    func SaveEmailToken(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "token")
        def.synchronize()
    }

    func getEmailToken()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "token" ) as? String
    }
    
    
    func saveid(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_id")
        def.synchronize()
    }
    func getid()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_id" ) as? String
    }
    
    func savefirst_name(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_first_name")
        def.synchronize()
    }
    func getfirst_name()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_first_name" ) as? String
    }
    
    func savelast_name(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_last_name")
        def.synchronize()
    }
    func getlast_name()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_last_name" ) as? String
    }
    
   
    func saveAvatar(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_avatar")
        def.synchronize()
    }
    func getAvatar()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_avatar" ) as? String
    }
    func savestatus(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_status")
        def.synchronize()
    }
    func getstatus()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_status" ) as? String
    }
   
    
    func saveEmail(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_email")
        def.synchronize()
    }
    func getEmail()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_email" ) as? String
    }
    
    
    func isLogin(auth:Bool){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "is_Login")
        def.synchronize()
    }
    func getisLogin()-> Bool?{
        let def = UserDefaults.standard
        return def.object(forKey: "is_Login")as? Bool
    }
    func setIntro(auth:Bool){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "is_Intro")
        def.synchronize()
    }
    func getIntro()-> Bool?{
        let def = UserDefaults.standard
        return def.object(forKey: "is_Intro")as? Bool
    }
    func isSendNotification(auth:Bool){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "is_Send_Notification")
        def.synchronize()
    }
    func getisSendNotification()-> Bool?{
        let def = UserDefaults.standard
        return def.object(forKey: "is_Send_Notification")as? Bool
    }
    func setusertype(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_type")
        def.synchronize()
    }
    func getusertype()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_type")as? String
    }
    
    
    func saveCoachName(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_coach_name")
        def.synchronize()
    }
    func getCoachName()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_coach_name" ) as? String
    }
    func saveCoachImage(auth:String){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_coach_image")
        def.synchronize()
    }
    func getCoachImage()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_coach_image") as? String
    }
    func saveCoachId(auth:Int){
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_coach_id")
        def.synchronize()
    }
    func getCoachId()-> Int?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_coach_id" ) as? Int
    }
    
    func saveStartDate(name:Date)
    {
        let def = UserDefaults.standard
        def.setValue(name, forKey: "start_date")
        def.synchronize()
    }
    func getStartDate()-> Date?{
        let def = UserDefaults.standard
        return def.object(forKey: "start_date") as? Date
    }
    func saveUserLanguage(active:String)
    {
        let def = UserDefaults.standard
        def.setValue(active, forKey: "user_Language")
        def.synchronize()
    }
    func getUserLanguage()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_Language") as? String
    }
    
    
    func getAvatarFor(sender: SenderType) -> Avatar {
      let firstName = sender.displayName.components(separatedBy: " ").first
      let lastName = sender.displayName.components(separatedBy: " ").first
      let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
      switch sender.senderId {
      case "000001":
        return Avatar(image: #imageLiteral(resourceName: "Nathan-Tannar"), initials: initials)
      case "000002":
        return Avatar(image: #imageLiteral(resourceName: "Steven-Deutsch"), initials: initials)
      case "000003":
        return Avatar(image: #imageLiteral(resourceName: "Wu-Zhong"), initials: initials)
      case "000000":
        return Avatar(image: nil, initials: "SS")
      default:
        return Avatar(image: nil, initials: initials)
      }
    }

}
