    import SwiftUI
    import SDWebImageSwiftUI

    struct ChatLogView: View {
        
        let chatUser: ChatUser?
        @State var shouldShowImagePicker = false
        @State var image: UIImage?
        
        init(chatUser: ChatUser?){
            self.chatUser = chatUser
            self.vm = .init(chatUser: chatUser)
        }
        
        @ObservedObject var vm: ChatLogViewModel
        @Environment(\.colorScheme) var sema
        
        var body: some View {
            VStack{
                ZStack {
                    if sema == .dark {
                        Color.black.edgesIgnoringSafeArea(.all) // ScrollView alanının arka planını siyah yapar
                    }
                    ScrollView {
                        ScrollViewReader { scrollViewProxy in
                            
                                ForEach(vm.chatMessages) { message in
                                    VStack{
                                        if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                                            HStack{
                                                Spacer()
                                                HStack{
                                                    Text(message.text)
                                                        .foregroundColor(self.sema == .light ? .black : .white)
                                                        .padding(.vertical, 8)
                                                        .padding(.horizontal, 12)
                                                }
                                                //.padding()
                                                .background(.green.opacity(0.3))
                                                .cornerRadius(11)
                                            }
                                        }else {
                                            //Gelen
                                            HStack{
                                                HStack{
                                                    Text(message.text)
                                                        .foregroundColor(self.sema == .light ? .black : .white)
                                                        .padding(.vertical, 8)
                                                        .padding(.horizontal, 12)
                                                }
                                                .background( Color(self.sema == .dark ? .gray : .white).opacity(0.3))
                                                .cornerRadius(11)
                                                Spacer()
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.top,11)

                                }
                                
                                HStack { Spacer() }
                                    .id("Empty")
                                    .onReceive(vm.$count) { _ in
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                                        }
                                        
                            }

                                
                        }
                        
                    }
                    .background(Color.clear)
                    .navigationBarBackButtonHidden()
                    .navigationBarItems(leading: CustomNavigationBar(chatUser: chatUser))
                    
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Button(action: {
                            shouldShowImagePicker.toggle()
                        }, label: {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(.label))
                            
                        })
                        
                        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                            ImagePicker(image: $image)
                        }
                        
                        TextField(" ", text: $vm.chatText)
                            .background(.gray).opacity(0.8)
                            .cornerRadius(40)
                        Button(action: {
                            vm.handleSend()
                            vm.count += 1
                        }, label: {
                            Image(systemName: vm.chatText != "" ? "chevron.right.2" : "mic")
                                .font(.system(size: 24))
                                .foregroundColor(Color(.label))
                        })
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Image(systemName: "scribble")
                                    .foregroundColor(Color(.label))
                                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 5, y: -5)
                                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: -5, y: -5)
                            })
                            Text("Çiz")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Image(systemName: "doc.fill")
                                    .foregroundColor(Color(.label))
                            })
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 5, y: -5)
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: -5, y: -5)
                            
                            Text("Dosyalar")
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }
                    .padding(.horizontal, 100)
                    .font(.system(size: 22))
                }
            }
        }

        struct CustomNavigationBar: View {
            @Environment(\.presentationMode) var presentationMode
            @State var alertMessage = ""
            @State private var showAlert1 = false
            @State private var showAlert2 = false
            @State private var showAlert3 = false
            let chatUser: ChatUser?
            @Environment(\.colorScheme) var sema
            
            var emailNick: String {
                guard let email = chatUser?.email else { return "" }
                let cleanedEmail = email.replacingOccurrences(of: "@gmail.com", with: "")
                if let firstCharacter = cleanedEmail.first {
                    return firstCharacter.uppercased() + cleanedEmail.dropFirst()
                } else {
                    return cleanedEmail
                }
            }

            var body: some View {
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(self.sema == .dark ? .white : .black)
                            .foregroundColor(.blue)
                            .frame(minWidth: 40, alignment: .leading)
                    }
                    
                    WebImage(url: URL(string: chatUser?.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(min(50, 50) / 2)
                        .offset(x: UIScreen.main.bounds.height * -0.03)
                    
                    Text(emailNick)
                        .frame(minWidth: 80, alignment: .leading)
                    //.fontWeight(.semibold)
                        .offset(x: UIScreen.main.bounds.height * -0.03)
                    
                    Spacer() // Bu Spacer, Text ile butonlar arasında boşluk oluşturur.
                    Group{
                        Button(action: {
                            self.alertMessage = "Video Araması Başlatıldı"
                            showAlert1.toggle()
                        }, label: {
                            Image(systemName: "video")
                                .font(.system(size: 20))
                        })
                        .alert(isPresented: $showAlert1) {
                            Alert(
                                title: Text("📹"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("Tamam"))
                            )
                        }
                        
                        Button(action: {
                            self.alertMessage = "Telefon Araması Başlatıldı"
                            showAlert2.toggle()
                        }, label: {
                            Image(systemName: "phone")
                                .font(.system(size: 20))
                        })
                        .alert(isPresented: $showAlert2) {
                            Alert(
                                title: Text("📞"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("Tamam"))
                            )
                        }
                        
                        Button(action: {
                            self.alertMessage = "Kişi Bilgisi: \(chatUser?.email ?? "")"
                            showAlert3.toggle()
                        }, label: {
                            Image(systemName: "person.text.rectangle")
                                .font(.system(size: 20))
                        })
                        
                        .alert(isPresented: $showAlert3) {
                            Alert(
                                title: Text("🧾"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("Tamam"))
                            )
                        }
                        
                    }
                    .foregroundColor(self.sema == .dark ? .white : .black)
                }
                .padding(.horizontal)
            }
        }
    }

    #Preview {
        NavigationView{
            ChatLogView(chatUser: .init(data: ["uid": "4lUiUdObvgb1BFCPwWwVndlVmTq1","profileImageUrl": "https://firebasestorage.googleapis.com:443/v0/b/swiftui-firebase-chatapp-4a5c4.appspot.com/o/4lUiUdObvgb1BFCPwWwVndlVmTq1?alt=media&token=148e629b-70bd-48cc-b79a-751d518e4e22","email": "test@gmail.com" ]))
        }
    }

