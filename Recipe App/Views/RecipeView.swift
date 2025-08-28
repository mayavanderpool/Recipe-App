//
//  RecipeView.swift
//  Recipe App
//
// Author: Maya Vanderpool
//

import SwiftUI

struct RecipeView: View {
    
    let recipe: RecipeItem
    
    var body: some View {
        
        VStack(spacing: 20){
            VStack{
                HStack{
                    Spacer()
                    Text(recipe.name)
                        .fontWeight(.bold)
                        .font(.system(size: 50))
                        .padding(10)
                    Spacer()
                    
                    Button{
                        //edit
                    } label:{
                        Image(systemName: "line.3.horizontal")
                    }
                    .font(.title)
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                                        
                    
                }
                .padding(.horizontal)
                
                Utilities.showStars(rating: Double(recipe.rating))
            }
            
            Divider()
            
            
            
            VStack{
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                
                ForEach(recipe.ingredients.indices, id: \.self){ index in
                    Text(recipe.ingredients[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Divider()
                }
                Divider()
                Text("Instructions")
                    .font(.title2)
                    .fontWeight(.semibold)
                ForEach(recipe.instructions.indices, id: \.self){ index in
                    Text("\(index + 1). \(recipe.instructions[index])")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Divider()
                }
                
            }
            Spacer()
        }
    }
}


#Preview {
    RecipeView( recipe: RecipeItem(
        id:"1",
        name:"cookies",
        ingredients:["1 egg","2 cups flour", "three sugars"],
        instructions:["mix", "pour", "bake"],
        rating: 2,
        categoryId: "dinner"
    ))
}


