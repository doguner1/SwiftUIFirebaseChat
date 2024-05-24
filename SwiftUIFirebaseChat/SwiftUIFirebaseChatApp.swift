//
//  SwiftUIFirebaseChatApp.swift
//  SwiftUIFirebaseChat
//
//  Created by Doğu GNR on 13.05.2024.
//

import SwiftUI

@main
struct SwiftUIFirebaseChatApp: App {
    @AppStorage("login") var login : Int = 0
    var body: some Scene {
        WindowGroup {

            if login == 0 {
                LoginView()
            }else{
                MainMessagesView()
            }
                
        }
    }
}

/*
 Uygulama Login Sayfası Oluşturduk
 Firebase Paketini kurduk
  -> https://github.com/firebase/firebase-ios-sdk
  -> Firebase Auth ve Firebase Stroge alanlarını seçtik
 Firebase sayfasından proje alanı açıp info dosyasımızı proje içine attık
 */
