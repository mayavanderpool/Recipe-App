//
//  SignUpView.swift
//  Recipe App
//
/// Author: Maya Vanderpool
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct SignUpView: View {

    // TextField Cases
    enum FormFieldFocus: Hashable{
        case firstName, lastName, email, password
    }
    
    // Initialize @State variables
    @State private var user = User()
    @State private var passwordInput: String = ""
    @State private var isActive: Bool = false
    
    // FocusState variable allows the UI to focus on one TextField at a time
    @FocusState private var focus: FormFieldFocus?
    
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
                
                VStack(spacing: 20){
                    // TextFields for user input
                    TextField("First Name", text: $user.firstname)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            focus = .lastName
                        }
                        .focused($focus, equals: .firstName)
                    
                    TextField("Last Name", text: $user.lastname)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            focus = .email
                        }
                        .focused($focus, equals: .lastName)
                    
                    TextField("Email", text: $user.email)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            focus = .password
                        }
                        .focused($focus, equals: .email)
                        
                    // SecureField for password
                    // Password not entirely encapsulated
                    SecureField("Password", text: $passwordInput)
                        .textFieldStyle(.roundedBorder)
                        .focused($focus, equals: .password)
                    
                    // Sign Up button to submit input
                    Button("Sign Up") {
                        validate{ error in
                            if let error = error{
                                print(error)
                            }
                            else{
                                saveData()
                            }
                        }
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
                // Sign Up card styling
                .padding(30) // Space between elements and rectangle
                .background(Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .cornerRadius(15)
                    .shadow(radius: 15))
                .padding(.horizontal, 70) // Space between rectangle and edges
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
    
    // Validates input
    func validate(completion: @escaping (String?) -> Void){
        user.validateTextFields(password: passwordInput, completion: completion)
    }
    // Saves data to Firestore
    func saveData(){
        user.createUser(password: passwordInput){ saved in
            if saved{
                self.isActive = true
                self.passwordInput = ""
            }
            
        }
    }
    
    
}


#Preview {
    
    SignUpView()
    
}


