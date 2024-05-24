//
//  CreateNewMessageViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Doğu GNR on 16.05.2024.
//

import Foundation

class CreateNewMessageViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    init(){
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection("users").getDocuments{ documentsSnapshot ,err in
            if let err = err {
                print("Failed to fetch users: \(err)")
                return
            }
            
            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                let user = ChatUser(data: data)
                if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(.init(data: data))
                }
                
            })
        }
    }
    
    func cleanEmail(_ email: String) -> String {
        let cleanedEmail = email.replacingOccurrences(of: "@gmail.com", with: "")
        let firstChar = cleanedEmail.prefix(1).capitalized
        let remainingChars = cleanedEmail.dropFirst()
        let finalCleanedEmail = firstChar + remainingChars
        return String(finalCleanedEmail)
    }

}
