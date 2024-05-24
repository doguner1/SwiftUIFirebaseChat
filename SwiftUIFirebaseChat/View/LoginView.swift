    //
    //  LoginView.swift
    //  SwiftUIFirebaseChat
    //
    //  Created by Doğu GNR on 13.05.2024.
    //

    import SwiftUI
    import Firebase
    import FirebaseStorage
    import FirebaseFirestore


    struct LoginView: View {
        @AppStorage("index") var index : Int = 0
        @Namespace private var name
        @Environment(\.colorScheme) var sema
        
        
        var body: some View {
            
            ZStack {
                // Arka plan resmi
                Image(self.index == 0 ? "black" : "white")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(1) // Resmin opaklığı
                VStack{
                    
                    Image("logo").resizable().aspectRatio(contentMode: .fill).frame(width: 70,height: 70).opacity(0.75)
                    
                    HStack(spacing: 0){
                        
                        Button(action: {
                            
                            withAnimation(.spring()){
                                index = 0
                            }
                            
                        }, label: {
                            VStack{
                                Text("Giriş Yap").font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(index == 0 ? Color(.label) : .gray)
                                // index 0 ise black ol yoksa gri
                                
                                ZStack{
                                    Capsule().fill(Color.black.opacity(0.04))
                                        .frame(height: 5)
                                    
                                    if index == 0 {// Giriş alanı seçildiyse altındaki renkli çizgiyi oluştur
                                        Capsule().fill(Color("Renk1")).frame(height: 5)
                                            .matchedGeometryEffect(id: "Tab", in: name)
                                    }
                                }
                            }
                        })
                        
                        Button(action: {
                            
                            withAnimation(.spring()){
                                index = 1
                            }
                            
                        }, label: {
                            VStack{
                                Text("Kayıt Ol").font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(index == 0 ? .gray : Color(.label))
                                // index 1 ise black ol yoksa gri
                                
                                ZStack{
                                    Capsule().fill(Color.black.opacity(0.04))
                                        .frame(height: 5)
                                    
                                    if index == 1 {// Giriş alanı seçildiyse altındaki renkli çizgiyi oluştur
                                        Capsule().fill(Color("Renk1")).frame(height: 5)
                                            .matchedGeometryEffect(id: "Tab", in: name)
                                    }
                                }
                            }
                        })
                    }.padding(.top,30)
                    
                    if index == 0{
                        Login()
                    }else{
                        SignUp()
                    }
                    
                }
            }
            
        }
    }
        
        
        
        struct SignUp: View {
            @State var userName = ""
            @State var password = ""
            @State var shouldShowImagePicker = false
            @State var image: UIImage?
            @State private var showAlert = false
            @State private var alertMessage = ""
            @Environment(\.colorScheme) var sema
            var social = ["twitter","facebook","google"]
            
            var body: some View {
                VStack{
                    HStack{//Yan yana
                        Text("Hesap Oluştur").font(.title).fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.55))
                        Spacer()
                        Button(action: {
                            shouldShowImagePicker.toggle()
                        }, label: {
                            
                            VStack{
                                Group{
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80,height: 80)
                                            .cornerRadius(64)
                                            .overlay(RoundedRectangle(cornerRadius: 64)
                                                .stroke(Color.black,lineWidth: 3))
                                        
                                        
                                    }else {
                                        Image(systemName: "person.fill").font(.system(size: 30)).padding(.trailing,50)
                                            .foregroundColor(Color(.label))
                                        
                                    }
                                }
                                .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.clear, radius: 5, x: 5, y: 5)
                                .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.clear, radius: 5, x: 5, y: -5)
                                
                            }
                        })
                        .fullScreenCover(isPresented: $shouldShowImagePicker,onDismiss: nil){
                            ImagePicker(image: $image)
                        }
                        
                        
                    }.padding(.horizontal,25)
                    
                        .padding(.top,30)
                    
                    
                    VStack(alignment:.leading ,spacing: 15){
                        Text("Email Adresi").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                        TextField("Email Adresi", text: $userName)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(self.sema == .dark ? .black.opacity(0.75) : .white.opacity(0.55))
                            .cornerRadius(5)
                            .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
                            .autocapitalization(.none) // Otomatik ilk büyük harfi düzeltmeyi devre dışı bırakma
                        
                        
                        Text("Parola").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                        SecureField("Parolanız",text: $password).padding().background(self.sema == .dark ? .black.opacity(0.75) : .white.opacity(0.55)).cornerRadius(5)
                            .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
                        
                    }.padding(.horizontal,25)
                        .padding(.top,25)
                    
                    Button(action: {
                        createNewAccount()
                    }) {
                        Text("Kaydol").font(.system(size: 20))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50) //Button merkeze konulduğu için soldan ve sağdan 50 birim boşluk bırakıyor
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color("Renk1"), Color("Renk2")]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.55)
                            )
                            .cornerRadius(10)//Arka planı çift renk için
                    }.padding(.horizontal,25)
                        .padding(.top,25)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("⚠️"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("Tamam"))
                            )
                        }
                    
                    //Sosyal Butonları
                    
                    Button(action:{}) {
                        HStack(spacing: 35){
                            Image(systemName: "faceid").font(.system(size: 26)).foregroundColor(Color("Renk1"))
                            Text("Face ID ile kaydol").font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color("Renk1"))
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 20).stroke(Color("Renk1"),lineWidth: 1))
                    }//Button bitişi
                    .padding(.top,30)
                    .padding(.horizontal,25)
                    
                    HStack(spacing: 30){
                        ForEach(social,id: \.self){ name in
                            Button(action:{}){
                                Image(name).renderingMode(.original)//.template yaparsak renklerde oynama yapabiliriz.Default original olarak gelir. Original kalacaksa yazmaya gerek yok.Düz .template ise hepsi mavi renk oluyor
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(Color(name == "google" ? "Renk2" : "Renk1"))
                            }
                        }
                    }.padding(.top ,25)
                }
            }
            
            private func createNewAccount() {
                guard image != nil else {
                    alertMessage = "Person iconundan resim yükleyiniz"
                    showAlert = true
                    return
                }
                
                FirebaseManager.shared.auth.createUser(withEmail: userName, password: password) { result, err in
                    if let err = err {
                        alertMessage = "Kullanıcı oluşturulamadı: \(err.localizedDescription)"
                        showAlert = true
                        return
                    }
                    print("Successfully created user: \(result?.user.uid ?? "")")
                    
                    self.persistImageToStorage()
                }
            }
            private func persistImageToStorage() {
                guard let uid = FirebaseManager.shared.auth.currentUser?.uid
                else { return }
                let ref = FirebaseManager.shared.storage.reference(withPath: uid)
                guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
                ref.putData(imageData, metadata: nil) { metadata, err in
                    if let err = err {
                        print("Failed to push image to Storage: \(err)")
                        return
                    }
                    
                    ref.downloadURL { url, err in
                        if let err = err {
                            print(" Failed to retrieve downloadURL: \(err)")
                            return
                        }
                        print("Succesfully stored image with url: \(url?.absoluteString ?? "")")
                        print(url?.absoluteString)
                        
                        guard let url = url else { return }
                        self.storeUserInformation(imageProfileUrl: url)
                    }
                }
            }
            
            private func storeUserInformation(imageProfileUrl: URL) {
                
                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                
                let userData = ["email": self.userName, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
                //users adındaki dökümantasyonda email alanını userName den geliyor, uid alanı uid alanından yani FirebaseManagerdan auth dan çekiyor, profileImageUrl deki url ise storage alanından çekip firestore e yerleştiriliyor.
                
                FirebaseManager.shared.firestore.collection("users")
                    .document(uid).setData(userData) { err in
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        print("Succes")
                    }
            }
        }
        
        struct Login: View {
            @State var password = ""
            @ObservedObject private var vm = MainMessagesViewModel()
            @AppStorage("login") var login : Int = 0
            @AppStorage("loginCtrl") var loginCtrl : Int = 0
            @AppStorage("isUserCurrentlyLoggedIn") var isUserCurrentlyLoggedIn : Bool = false
            
            
            
            @AppStorage("name") var LoginName: String = ""
            @Environment(\.colorScheme) var sema
            var social = ["twitter","facebook","google"]
            
            var body: some View {
                VStack{
                    
                    if loginCtrl == 1 {
                        UserView
                            .padding(.horizontal,25)
                            .padding(.top,30)
                    }else{
                        LoginView
                            .padding(.horizontal,25)
                            .padding(.top,25)
                    }
                    
                    
                    VStack(alignment:.leading ,spacing: 15){
                        Text("Parola").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                        
                        SecureField("Parola",text: $password).padding()
                            .background(self.sema == .dark ? .black.opacity(0.75) : .white.opacity(0.55))
                            .cornerRadius(5)
                            .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
                        /*
                            .shadow(color: self.sema == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                         */
                        
                        Button(action: {}){
                            Text("Parolamı Unuttum").font(.system(size: 15))
                                .foregroundColor(Color("Renk1"))
                        }.padding(.top,10)
                    }
                    .padding(.horizontal,25)
                    .padding(.top,25)
                    
                    Button(action: {
                        
                        loginUser()
                        
                    }) {
                        Text("Oturum Aç").font(.system(size: 20))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color("Renk1"), Color("Renk2")]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.55)
                            ).cornerRadius(10)
                    }.padding(.horizontal,25)
                        .padding(.top,25)
                        .fullScreenCover(isPresented: $isUserCurrentlyLoggedIn, content: {
                            MainMessagesView()
                        })
                    
                    
                    
                    
                    //Sosyal Butonları
                    
                    Button(action:{}) {
                        HStack(spacing: 35){
                            Image(systemName: "faceid").font(.system(size: 26)).foregroundColor(Color("Renk1"))
                            Text("Face ID ile oturum aç").font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color("Renk1"))
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 20).stroke(Color("Renk1"),lineWidth: 1))
                    }
                    .padding(.top,30)
                    .padding(.horizontal,25)
                    
                    HStack(spacing: 30){
                        ForEach(social,id: \.self){ name in
                            Button(action:{}){
                                Image(name).renderingMode(.original)
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(Color(name == "google" ? "Renk2" : "Renk1"))
                            }
                        }
                    }.padding(.top ,25)
                }//Vstack
                
            }
            
            private func loginUser() {
                FirebaseManager.shared.auth.signIn(withEmail: LoginName, password: password) { result, err in
                    if let err = err {
                        print("Failed to login user:", err)
                        return
                    }
                    print("Successfully created user: \(result?.user.uid ?? "")")
                    isUserCurrentlyLoggedIn = true
                    login = 1
                    
                    // 2 saniye sonra LoginCntrl = 1 yap
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        loginCtrl = 1
                    }
                }
            }
            
        }
    #Preview {
        LoginView()
    }

    extension Login {
        
        private var UserView: some View{
            HStack{
                VStack(alignment: .leading){
                    
                    Text("Tekrar Merhaba").fontWeight(.bold).opacity(0.75)
                    Text(vm.emailNick).font(.title).fontWeight(.bold).opacity(0.75)

                    
                    Button(action: {
                            loginCtrl = 0
                            LoginName = ""
                       
                    }){
                            Text("Bu ben değilim")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Renk1"))
                            .padding(.top,4)
                    }
                }//Vstack
                Spacer(minLength: 0)
                
                vm.imagePP(width: 120, height: 120)
            }//Hstack
        }
    }

    extension Login {
        private var LoginView: some View{
            VStack(alignment:.leading ,spacing: 15){
                Text("Email").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                
                TextField("Email Adresi",text: $LoginName).padding()
                    .autocapitalization(.none)
                    .background(self.sema == .dark ? .black.opacity(0.75) : .white.opacity(0.55))
                    .cornerRadius(5)
                    .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .shadow(color: self.sema == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
            }//Vstack Paralo
        }
    }


