***
# SwiftUI Firebase Chat Uygulaması

Bu Swift UI Firebase Chat uygulaması, kullanıcıların birbirleriyle metin mesajlarını gönderebildiği basit bir anlık mesajlaşma uygulamasıdır.

## Mimarisi

Uygulama aşağıdaki bileşenleri içerir:

### Firebase Backend

Firebase, kullanıcı kimlik doğrulaması, veritabanı depolaması ve depolanan resimler için hizmet sağlar. `FirebaseManager.swift` dosyası Firebase uygulamasını yapılandırmak ve Firebase servislerine erişmek için kullanılır.

### Kullanıcı Yönetimi

`ChatUser` veri modeli, kullanıcıların profil resmi URL'lerini, e-posta adreslerini ve benzersiz kullanıcı kimliklerini tutar.

### Giriş ve Kayıt Ekranları

Kullanıcıların uygulamaya giriş yapması veya yeni bir hesap oluşturması için `LoginView.swift` ve `SignUp.swift` ekranları bulunmaktadır. Bu ekranlar, Firebase kimlik doğrulamasını kullanarak kullanıcı girişi ve hesap oluşturma işlemlerini yönetir.

### Yeni Mesaj Oluşturma Ekranı

`NewMessageView.swift` ekranı, kullanıcının yeni bir sohbet başlatması için mevcut kullanıcı listesini gösterir. Kullanıcılar arasında yeni bir sohbet başlatmak için bir kullanıcı seçilebilir.

### Sohbet Ekranı

`ChatLogView.swift` ekranı, seçilen bir kullanıcı ile olan mevcut sohbeti gösterir. Mesajlar, Firebase Firestore'dan alınır ve görüntülenir. Ayrıca, kullanıcılar metin mesajları gönderebilir ve resimler ekleyebilirler.

### Yardımcı Dosyalar

Uygulama için yardımcı sınıflar ve yapılar bulunmaktadır. Bunlar arasında resim seçme işlevselliğini sağlayan `ImagePicker.swift` ve mesaj oluşturma ve alımını yöneten `CreateNewMessageViewModel.swift` bulunmaktadır.

## Nasıl Kullanılır?

Uygulamayı çalıştırmak ve kendi Firebase projenizle bağlamak için aşağıdaki adımları izleyin:

1. Firebase Console'da yeni bir proje oluşturun.
2. Firebase projenize iOS uygulaması ekleyin ve gerekli ayarları yapın.
3. Firebase projenize Firestore ve Storage hizmetlerini etkinleştirin.
4. Firebase proje ayarlarını `FirebaseManager.swift` dosyasında yapılandırın.
5. Uygulamayı çalıştırın ve keyfini çıkarın!

## Ekran Görüntüleri

[Tüm ekran görüntülerini buradan görebilirsiniz.]

## Katkılar ve Geri Bildirim

Katkılarınız ve geri bildirimleriniz her zaman hoş karşılanır. Herhangi bir hata bulursanız veya uygulamaya yeni özellikler eklemek isterseniz, lütfen bir GitHub issues oluşturun veya bir pull request gönderin!

*** 
