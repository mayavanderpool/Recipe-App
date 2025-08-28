//
//  User.swift
//  Recipe App
//
// Author: Maya Vanderpool
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

struct User{

    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    
    // Private helper functions to remove whitespace from input strings
    private var trimmedFirst: String {
        firstname.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var trimmedLast: String {
        lastname.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    // Validates the password input as a secure password. One capital letter, one special character, one digit, and 8 characters long.
    static func validatePassword(_ password : String) -> Bool{
        let test = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$")
        return test.evaluate(with: password)
    }
    
    // Validates that another account does not exist with input email and that the email has a
    // "@" symbol with characters before and after
    func validateEmail(_ email : String, completion: @escaping (Bool) -> Void){
        // Check format
        let test = NSPredicate(format: "SELF MATCHES[c] %@", "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$")
        if !test.evaluate(with: email){
            print("Poor email format. Email must be consist of at least one char before and after the '@' symbol followed by one or more characters, a '.' then followed by a domain.")
            completion(false)
            return
        }
        // Check the email is not already being used
        let db = Firestore.firestore()
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments{(snapshot, error) in
            if error != nil {
                print("error with query")
                completion(false)
            }
            else if snapshot!.documents.isEmpty{
                completion(true)
            }
            else{
                print("error email exists")
                completion(false)
            }
        }
    }
    
    // Checks for valid input in TextFields
    func validateTextFields(password: String, completion: @escaping (String?) -> Void){
        let trimmedPwd =  password.trimmingCharacters(in: .whitespacesAndNewlines)
        // Fields cannot be empty
        if trimmedFirst == "" || trimmedLast == "" || trimmedEmail == "" || trimmedPwd == ""{
            completion( "All fields must be filled in.")
            return
        }
        if User.validatePassword(trimmedPwd) == false{
            completion("Password must be eight characters long, and contain one uppercase character, one special character, and one digit.")
            return
        }
        validateEmail(trimmedEmail){ valid in
            if !valid{
                completion("A valid email consists of chars before and after the '@' symbol. If your email fits this pattern then it must already be in use")
                return
            }
            completion(nil)
        }
        
        
    }
    
    // Creates user and saves their information to database
    func createUser(password: String, completion: @escaping (Bool) -> Void) {
        let trimmedPwd =  password.trimmingCharacters(in: .whitespacesAndNewlines)
        // Fields cannot be empty
        Auth.auth().createUser(withEmail: trimmedEmail, password: trimmedPwd) { (res, err) in
            // Checks for errors creating user
            if let err = err{
                // error message
                print("error creating user: \(err.localizedDescription)")
                completion(false)
            }
            else{
                print("user created")
                let db = Firestore.firestore()
                db.collection("Users").addDocument(data: ["firstname": trimmedFirst, "lastname": trimmedLast, "email": trimmedEmail, "uid": res!.user.uid]){(err) in
                    // Checks for error saving user information
                    if err != nil{
                        //error message
                        print("error saving user data")
                        completion(false)
                        
                    }
                    else{
                        print("data saved sucessfully")
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    
}






