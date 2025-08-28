//
//  CategoryRecipesView.swift
//  Recipe App
//
/// Author: Maya Vanderpool
//

import SwiftUI
import FirebaseAuth

struct CategoryRecipesView: View {
    
    @ObservedObject var model: ViewModel
    let userID = Auth.auth().currentUser?.uid ?? ""
    
    var body: some View {
        
            VStack{
                List(model.recipeList, id: \.id) { recipe in
                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                        HStack {
                            Text(recipe.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .onAppear{
                model.getDocId(uid: userID)
            }
        }
    }


#Preview {
    CategoryRecipesView(model: ViewModel())
}
