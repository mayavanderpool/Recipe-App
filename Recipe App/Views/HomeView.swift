//
//  HomeView.swift
//  Recipe App
//
// Author: Maya Vanderpool
//

import Firebase
import FirebaseAuth
import SwiftUI

struct HomeView: View {

    // TextField Cases
    enum FormFieldFocus: Hashable {
        case recipe, ingredient, instruction, rating
    }

    @ObservedObject var model = ViewModel()
    @State private var search: String = ""

    @State private var addRecipe = false
    @State private var addCategory = false

    let userID = Auth.auth().currentUser?.uid ?? ""

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 10) {
                    Text("Home")
                        .padding()
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .shadow(radius: 40)

                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $search)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 20)
                        Button {
                            //filter
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                        Menu {
                            Button("Add recipe") {
                                //
                                addRecipe = true
                            }
                            Button("Add category") {
                                //
                                addCategory = true
                            }
                            Button("Cancel", role: .cancel) {}
                        } label: {
                            Image(systemName: "plus.circle")
                        }

                    }
                    .padding(.horizontal, 20)
                    Divider()

                    List(model.categoryList, id: \.id) { category in
                        NavigationLink(
                            destination: CategoryRecipesView(model: model)
                        ) {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }
                .onAppear {
                    model.getDocId(uid: userID)
                }
            }
        }
        .sheet(isPresented: $addRecipe) {
            AddRecipeView(isPresented: $addRecipe, model: model)
        }
        .sheet(isPresented: $addCategory) {
            AddCategoryView(isPresented: $addCategory, model: model)
        }
    }
}

#Preview {
    HomeView()
}
