//
//  Constant.swift
//  PT_Platform
//
//  Created by mustafakhallad on 19/05/2022.
//

import Foundation
//let Connection = "https://qtechnetworks.co/pt-backend/public/api/v1/"
//let Connection = "https://pt.qtechnetworks.co/public/api/v1/"
let Connection = "https://ptplatform.app/public/api/v1/"
// AuthUser
let postlogin_url = Connection + "auth/login"
let postsignup_url = Connection + "auth/register-user"
// AuthCoach
let postVerifyEmail_url = Connection + "auth/verify-email"
let postCheckCode_url = Connection + "auth/verify-email/check-code"
let postVerifyEmailResetPassword_url = Connection + "auth/verify-email/forgot-password"
let postResetPassword_url = Connection + "auth/verify-email/update-password"
let postsignupCoach_url = Connection + "auth/register-coach"

let banners_url = Connection + "banners"
let newsfeed_url = Connection + "news-feed"
let sectionexercise_url = Connection + "section-exercise"
let sectionworkout_url = Connection + "section-workout"
let userscoaches_url = Connection + "users/coaches"


let logs_url = Connection + "video-logs"
let favourites_url = Connection + "video-favourites"
let workout_url = Connection + "video-workout"
let Exercises_history_url = Connection + "video-logs"
let supplements_url = Connection + "supplements"
let recipes_url = Connection + "recipes"
let target_url = Connection + "users/target"
let foods_url = Connection + "foods"
let deleteFoods_url = Connection + "foods/user"
let challenges_url = Connection + "challenges"
let training_workout_url = Connection + "users/training/workout"
let training_recipe_url = Connection + "users/training/recipe"
let training_personal_url = Connection + "users/training/personal"
let healths_url = Connection + "healths"
let body_measurements_url = Connection + "body-measurements"
let packages_url = Connection + "packages"
let questions_url = Connection + "coach-questions"
let coach_calendar_url = Connection + "coach-calendar"
let coach_calendar_reservation_url = coach_calendar_url + "/reservation"
let ticket_technical_support = Connection + "ticket/technical_support"
let ticket_feedback = Connection + "ticket/feedback"
let videoChat_user_url = Connection + "coach-calendar/user"
let cancel_reservation_url = Connection + "coach-calendar/delete-reservation"
let Nutrition_history_url = Connection + "foods/user"
let chat_url = Connection + "chats"
let promoـcode_url = Connection + "promo-code/check"
let update_name_url = Connection + "users/update/name"
let update_avatar_url = Connection + "users/update/avatar"
let update_notifications_url = Connection + "users/update/notifications"
let registerdevicesUrl = Connection + "users/device-token"
let logout_url = Connection + "users/logout"
let delete_account_url = Connection + "users/delete-account"


// Coach
let training_personal_coach_url = Connection + "coaches/personal-training"
let calender_coach_url = Connection + "coach-calendar/calendar"
let videoChat_coach_url = Connection + "coach-calendar/coach?skip=0"
