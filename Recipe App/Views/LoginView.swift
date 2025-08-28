//
//  LoginView.swift
//  Recipe App
//
/// Author: Maya Vanderpool
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct LoginView: View {
    
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @FocusState private var focus: FormFieldFocus?
    
    @State private var isActive: Bool = false
    
    // Helper functions to get the trimmed versions of the user input
    private var trimmedEmail: String {
        emailInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var trimmedPwd: String {
        passwordInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body: some View {
        ZStack{
            // Background image
            Image(Utilities.backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Recipes")
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .shadow(radius: 40)
                    .padding()
                Spacer()
                VStack{
                    TextField("Email", text: $emailInput)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            focus = .lastName
                        }
                        .focused($focus, equals: .firstName)
                    
                    SecureField("Password", text: $passwordInput)
                        .textFieldStyle(.roundedBorder)
                        .focused($focus, equals: .lastName)
                    
                    Button("Log In") {
                        // Log in user to account
                        login()
                    }
                    // Button Styling
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(10.0)
                    .background(Rectangle()
                        .foregroundColor(.pink)
                        .opacity(0.4)
                        .cornerRadius(15)
                        .shadow(radius: 15))
                }
                // Log in card styling
                .padding(30) // Space between elements and rectangle
                .background(Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .cornerRadius(15)
                    .shadow(radius: 15))
                .padding(.horizontal, 70)
                .onAppear(){
                    focus = .firstName
                }
        
                Spacer()
            }
            
        }
        
        NavigationLink(destination: HomeView(), isActive: $isActive){
            EmptyView()
    }
        
        }
    enum FormFieldFocus: Hashable{
        case firstName, lastName
    }
    
    func login(){
        Auth.auth().signIn(withEmail: trimmedEmail, password: trimmedPwd){
            (result, error) in
            if error != nil{
                print("Couldn't sign in")
            }
            else{
                isActive = true
            }
            
        }
    }
    
    
}

#Preview {
    LoginView()
}
