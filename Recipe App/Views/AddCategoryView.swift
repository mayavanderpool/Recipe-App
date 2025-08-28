//
//  AddCategoryView.swift
//  Recipe App
//
// Author: Maya Vanderpool
//

import SwiftUI
import FirebaseAuth

struct AddCategoryView: View {
    
    @State private var category: String = ""
    @Binding var isPresented: Bool
    @ObservedObject var model: ViewModel
    let userID = Auth.auth().currentUser?.uid ?? ""
    
    var body: some View {
        VStack(spacing: 10){
            TextField("Category", text: $category)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button(action: {
                //call add category
                model.addCategory(user: userID, name: category)
                
                //clear data
                
                category = ""
            }, label: {
                Text("Add Category")
                
            })
            .buttonStyle(.borderedProminent)
            .cornerRadius(15)
            
            Button(action: {
                //done
                
                isPresented = false
                
               
            }, label: {
                Text("Done")
                
            })
            .buttonStyle(.borderedProminent)
            .cornerRadius(15)
        }.padding()
        
    }
}

#Preview {
    AddCategoryView(isPresented: .constant(true), model:ViewModel())
}
