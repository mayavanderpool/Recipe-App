//
//  SwiftUIView.swift
//  Recipe App
//
// Author: Maya Vanderpool
//

import SwiftUI

struct WelcomeView: View {

    var body: some View {
        NavigationStack{
            ZStack{
                Image(Utilities.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    Text("Welcome to Recipes App!")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 70)
                        .padding(.vertical, 20)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .background(Rectangle()
                            .foregroundColor(.pink)
                            .opacity(0.4)
                            .cornerRadius(15)
                            .shadow(radius: 15))
                     
                      
                    Spacer()
                    VStack(spacing:20){
                        NavigationLink(destination: LoginView()){
                            Text(" Login   ")
                                .padding() // Between button and background
                                .background(Rectangle()
                                    .foregroundColor(.pink)
                                    .opacity(0.4)
                                    .cornerRadius(15)
                                    .shadow(radius: 15))
                        }
                        
                        NavigationLink(destination: SignUpView()){
                            Text("Sign Up")
                                .padding() // Between button and background
                                .background(Rectangle()
                                    .foregroundColor(.pink)
                                    .opacity(0.4)
                                    .cornerRadius(15)
                                    .shadow(radius: 15))
                                
                        }
                            
                            
                    }
                    // Sign Up card styling
                    .padding(50) // Space between elements and rectangle
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .cornerRadius(15)
                        .shadow(radius: 15))
                    .padding(.horizontal, 70) // Space between rectangle and edges
                    Spacer()
                } .foregroundColor(.white)
                
            }
            
        }
    }
}
    #Preview {
        WelcomeView()
    }

