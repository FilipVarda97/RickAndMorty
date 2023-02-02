//
//  RMSplashSUIView.swift
//  RickAndMorty
//
//  Created by Filip Varda on 02.02.2023..
//

import SwiftUI

/// SplashView for app in SwiftUI
struct RMSplashSUIView: View {
    @State private var animateTitle = false
    @State private var animateCredits = false
    @State private var animatePortal = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing)
            VStack {
                Image("RMTitleImage")
                    .resizable()
                    .scaledToFit()
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    .scaleEffect(animateTitle ? 1 : 0)
                
                Spacer()
                
                Image("RMPortalImage")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                    .scaleEffect(animatePortal ? 1 : 0)
                    .onAppear() {
                        withAnimation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 0)
                            .delay(0.5)) {
                                animateTitle.toggle()
                        }
                        withAnimation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 0)
                            .delay(1)) {
                                animatePortal.toggle()
                            }
                        withAnimation(.easeInOut(duration: 0.5)
                            .delay(1.5)) {
                                animateCredits.toggle()
                            }
                        
                    }
                
                Spacer()
                
                Text("Created by\nJustin Roiland and Dan Harmon")
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0))
                    .multilineTextAlignment(.center)
                    .scaleEffect(animateCredits ? 1 : 0)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct RMSplashSUIView_Previews: PreviewProvider {
    static var previews: some View {
        RMSplashSUIView()
    }
}
