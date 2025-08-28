//
//  AddRecipeView.swift
//  Recipe App
//
// Author: Maya Vanderpool
//

import SwiftUI
import FirebaseAuth

struct AddRecipeView: View {
    
    // TextField Cases
        enum FormFieldFocus: Hashable{
            case recipe, ingredient, instruction
        }
    @Binding var isPresented: Bool
    @ObservedObject var model: ViewModel
        @State private var recipe: String = ""
        @State private var ingredients: Array<String> = []
        @State private var ingredient: String = ""
        @State private var instructions: Array<String> = []
        @State private var instruction: String = ""
        @State private var ratingInput: String = ""
        @State private var category: String = ""
    
    let userID = Auth.auth().currentUser?.uid ?? ""
        
        // FocusState variable allows the UI to focus on one TextField at a time
        @FocusState private var focus: FormFieldFocus?

        
    var body: some View {
       
                        VStack(spacing: 10){
                            TextField("Recipe Name", text: $recipe)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    focus = .ingredient
                                }
                                .focused($focus, equals: .recipe)
                            
                            TextField("Ingredient", text: $ingredient)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    focus = .instruction
                                }
                                .focused($focus, equals: .ingredient)
                            
                            TextField("Instruction \(instructions.count + 1)", text: $instruction)
                                .textFieldStyle(.roundedBorder)
                                .focused($focus, equals: .instruction)
                            
                            TextField("Rating 1-5 Optional", text: $ratingInput)
                                .textFieldStyle(.roundedBorder)
                            
                            
                            Picker("Category",selection: $category){
                                ForEach(model.categoryList){cat in
                                    Text(cat.name).tag(cat.id)}
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            
                            Button("Add Ingredient"){
                                ingredients.append(ingredient)
                                ingredient = ""
                            }
                            .buttonStyle(.borderedProminent)
                            .cornerRadius(15)
                            
                            Button("Add Instruction"){
                                instructions.append(instruction)
                                instruction = ""
                            }
                            .buttonStyle(.borderedProminent)
                            .cornerRadius(15)
                            
                            
                            Button(action: {
                                //call add recipe
                                model.addRecipe(user: userID, name: recipe, ingredients: ingredients, instructions: instructions, rating: Double(ratingInput) ?? -1.0, categoryId: category)
                                
                                //clear data
                                recipe = ""
                                ingredients = []
                                instructions = []
                                ratingInput = ""
                                category = ""
                            }, label: {
                                Text("Add Recipe")
                                
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
                Spacer()
                }
            }

#Preview {
    AddRecipeView(isPresented: .constant(true), model:ViewModel())
}
