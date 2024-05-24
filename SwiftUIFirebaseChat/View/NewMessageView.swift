//
//  NewMessageView.swift
//  SwiftUIFirebaseChat
//
//  Created by Doğu GNR on 16.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewMessageView: View {
    let didSelectNewUser: (ChatUser) -> ()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    //Cihazın tema durumunu ele alıyor. Koyu açık
    
    var body: some View {
        
        NavigationView{
            VStack(alignment:.leading){
                Group{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text("Cancel")
                    })
                    
                    Text("New Message")
                        .font(.system(size: 32,weight: .bold))
                        .padding(.bottom)
                }.padding([.horizontal])
            
            ScrollView{

                ForEach(vm.users) { user in
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                        print(user.uid)
                    }, label: {
                        VStack{
                            HStack(spacing: 16){
                                
                                WebImage(url: URL(string: user.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipped()
                                    .cornerRadius(min(70, 70) / 2)
                                    .overlay(RoundedRectangle(cornerRadius: min(70, 70) / 2).stroke(Color(.label), lineWidth: 2))
                                    .shadow(radius: 5)
                                
                                VStack(alignment: .leading){
 
                                    Text(vm.cleanEmail(user.email))
                                        .font(.system(size: 20,weight: .semibold))
                                        .foregroundColor(Color(.label))
                                }
                                
                                Spacer()
                            }
                            Divider()
                                .padding(.vertical,8)
                        }.padding(.horizontal)
                    })

                    }
                }
                
            }
        }

    }
}

 #Preview {
 MainMessagesView()
 //NewMessageView()
 }

