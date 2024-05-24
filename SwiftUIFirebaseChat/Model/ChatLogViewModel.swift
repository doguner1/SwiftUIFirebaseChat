//
//  ChatLogViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Doğu GNR on 20.05.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseConstans {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
}

struct ChatMessage: Identifiable {
    
    var id: String { documenId }
    
    let documenId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documenId = documentId
        self.fromId = data[FirebaseConstans.fromId] as? String ?? ""
        self.toId = data[FirebaseConstans.toId] as? String ?? ""
        self.text = data[FirebaseConstans.text] as? String ?? ""
    }
}

class ChatLogViewModel: ObservableObject {
    @Published var chatText = ""
    let chatUser: ChatUser?
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        FirebaseManager.shared.firestore
            .collection("message")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Fialed to listen for messages\(error)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    func handleSend(){
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("message")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [FirebaseConstans.fromId: fromId, FirebaseConstans.toId: toId, FirebaseConstans.text: self.chatText, "timestamp": Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print("Failed to save message into Firestore: \(error)")
                return
            }
            self.persistRecentMessage()
            self.chatText = ""
            self.count += 1
        }
        let recipientMessageDocument = FirebaseManager.shared.firestore
            .collection("message")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print("Failed to save message into Firestore: \(error)")
                return
            }
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage(){
        //Ana menü mesajları
        guard let chatUser = self.chatUser else { return }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": chatUser.profileImageUrl,
            "email": chatUser.email
            /*
            "timestamp": Timestamp(),
            FirebaseConstans.text: self.chatText,
            FirebaseConstans.fromId: uid,
            FirebaseConstans.toId: toId,
            FirebaseConstans.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstans.email: chatUser.email
             */
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error {
                print("Failed to save recent message: \(error)")
                return
            }
        }
    }
}

