import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift

class MainMessagesViewModel: ObservableObject {

    @Published var message = ""
    @Published var chatUser: ChatUser?
    @State var chatUser2: ChatUser?
    @AppStorage("isUserCurrentlyLoggedIn") var isUserCurrentlyLoggedIn : Bool = false
    @AppStorage("login") var login : Int = 0
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    
    init() {
        
//        DispatchQueue.main.async {
//            self.isUserCurrentlyLoggedIn = FirebaseManager.shared.auth.currentUser?.uid == nil
//        }
        
        fetchCurrenUser()
        fetchRecentMessages()

    }
    
    private func fetchRecentMessages() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        /*
        firestoreListener?.remove()
        self.recentMessages.removeAll()
            */
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Failed to listen for recent messages: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
//                        self.recentMessages.append(.init(documentId: docId, data: change.document.data()))
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }){
                        self.recentMessages.remove(at: index)
                    }
                    
                    if let rm = try? change.document.data(as: RecentMessage.self) {
                        self.recentMessages.insert(rm, at: 0)
                    }

                })
            }
    }

    private func fetchCurrenUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
       
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: ", error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            self.chatUser = .init(data: data)
        }
    }
    
    func handleSignOut() {
        print("Handle Sign out")
        self.isUserCurrentlyLoggedIn = false
        login = 0
        self.fetchRecentMessages()
//        try? FirebaseManager.shared.auth.signOut()
    }
    
    var emailNick: String {
        guard let email = chatUser?.email else { return "" }
        let cleanedEmail = email.replacingOccurrences(of: "@gmail.com", with: "")
        if let firstCharacter = cleanedEmail.first {
            return firstCharacter.uppercased() + cleanedEmail.dropFirst()
        } else {
            return cleanedEmail
        }
    }
    
    
    func imagePP(width: CGFloat, height: CGFloat) -> some View {
        WebImage(url: URL(string: chatUser?.profileImageUrl ?? ""))
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
            .cornerRadius(min(width, height) / 2)
            .overlay(RoundedRectangle(cornerRadius: min(width, height) / 2).stroke(Color(.label), lineWidth: 2))
            .shadow(radius: 5)
    }
}
