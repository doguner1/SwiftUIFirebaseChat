//
//  MainMessagesView.swift
//  SwiftUIFirebaseChat
//
//  Created by Doğu GNR on 14.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct MainMessagesView: View {
    
    @State var shouldNavigateToChatLogView = false
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MainMessagesViewModel()
    @State var shouldShowNewMessageScreen = false
    @Environment(\.colorScheme) var sema
    @AppStorage("index") var index : Int = 0
    //Cihazın tema durumunu ele alıyor. Koyu açık
    @State var chatUser: ChatUser?//ilk başta user seçilmemiş varsayılır
    
    
//    @State private var refreshToggle = false

    
    
    var body: some View {
        
        NavigationView{
            VStack{
                //custom nav bar
                HStack(spacing: 16){
                    vm.imagePP(width: 50, height: 50)
                    VStack(alignment: .leading,spacing: 4) {
                        Text(vm.emailNick)
                            .font(.system(size: 19,weight: .bold))
                        HStack{
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 14,height: 14)
                            
                            Text("online")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.lightGray))
                        }
                    }
                    Spacer()
                    Group{
                        Button(action: {
                            shouldShowLogOutOptions.toggle()
                        }, label: {
                            Image(systemName: "gear")
                            
                        })
                        Button(action: {
                            shouldShowNewMessageScreen.toggle()
                        }, label: {
                            Image(systemName: "plus.message")
                            
                        })
                        Button(action: {
                            UIApplication.shared.windows.first?.rootViewController?.overrideUserInterfaceStyle = self.sema == .dark ? .light : .dark
                        }, label: {
                            Image(systemName: self.sema == .dark ? "sun.max.fill" : "moon.fill")
                                .font(.system(size: 22))
                        })
                        
                    }
                    .foregroundColor(.brown)
                    .font(.system(size: 25,weight: .bold))
                    .fullScreenCover(isPresented: $shouldShowNewMessageScreen){
                        NewMessageView(didSelectNewUser: { user in
                            print(user.email)
                            self.shouldNavigateToChatLogView.toggle()
                            self.chatUser = user
                        })
                    }
                }
                .padding()
                .actionSheet(isPresented: $shouldShowLogOutOptions) {
                    .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                        .destructive(Text("Sign Out"), action: {
                            
                            vm.handleSignOut()
                        }),
                        //.default(Text("Default Button")),
                        .cancel()
                    ])
                }
                ScrollView{
                    ForEach(vm.recentMessages) { recentMessage in
                        VStack{
                            
//                            NavigationLink{ //Tıklanacak alan başlangıç
//                                Text("Deneme")
//                            } label: {
                                HStack(spacing: 16){
                                    WebImage(url: URL(string: recentMessage.profileImageUrl))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64,height: 64)
                                        .clipped()
                                        .cornerRadius(64)
                                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black,lineWidth: 1))
                                    VStack(alignment: .leading){
                                        Text(recentMessage.username)
                                            .font(.system(size: 16,weight: .bold))
                                            .foregroundColor(Color(.label))
                                        Text(recentMessage.text)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                            .multilineTextAlignment(.leading)
                                            
                                    }
                                    Spacer()
                                    
                                    Text(recentMessage.timeAgo)
                                        .font(.system(size: 14,weight: .semibold))
                                        .foregroundColor(Color(.label))
                                }
//                            }//Tıklanacak alan sonu
                            
                            Divider()
                                .padding(.vertical,8)
                        }.padding(.horizontal)
                    }
                    
                }
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
                
            }.navigationBarHidden(true)    
        }
        
    }
    struct BackButton: View {
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                    Text("Back")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}


#Preview {
    MainMessagesView()
}
