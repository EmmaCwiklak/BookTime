import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack{
            Color("Color")
                    .edgesIgnoringSafeArea(.all)
                
            Image("SplashScreenLogo")
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
        }
        
    }
}

#Preview {
    SplashScreenView()
}
