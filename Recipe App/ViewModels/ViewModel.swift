//
//  ViewModel.swift
//  Recipe App
//
//  Author Maya Vanderpool
//

import Firebase
import Foundation

class ViewModel: ObservableObject {

    @Published var recipeList = [RecipeItem]()
    @Published var categoryList = [CategoryItem]()
    private var userDoc: String?

    func getDocId(uid: String) {
        let db = Firestore.firestore()
        db.collection("Users").whereField("uid", isEqualTo: uid).getDocuments {
            snapshot,
            error in
                //check err
            if error == nil {
                if let docId = snapshot?.documents.first?.documentID {
                    self.userDoc = docId
                    self.createMisc()
                    self.getRecipes()
                } else {
                    db.collection("Users").addDocument(data: ["uid": uid]) { error in
                        if error == nil {
                            self.getDocId(uid: uid)
                        }
                    }
                }
            } else {
                //err
                print("Error finding user document")
            }
        }
    }

    func createMisc() {
        //get ref
        guard let userDoc = userDoc else {
            print("error: docs is nil")
            return
        }
        let db = Firestore.firestore()
        db.collection("Users").document(userDoc).collection(
            "Categories"
        ).whereField("name", isEqualTo: "Miscellaneous").getDocuments {
            snapshot,
            error in
            if error == nil {
                if let snapshot = snapshot, snapshot.documents.isEmpty {
                    db.collection("Users").document(userDoc).collection(
                        "Categories"
                    ).addDocument(data: ["name": "Miscellaneous"]) { error in
                        if error == nil {
                            self.getCategories()
                        } else {
                            print("error created misc category")
                        }
                    }

                } else {
                    self.getCategories()
                }
            } else {
                print("error getting documents")
            }
        }

    }

    func deleteCategory(categoryToDelete: CategoryItem) {
        guard let userDoc = userDoc else {
            print("error: docs is nil")
            return
        }
        //get ref
        let db = Firestore.firestore()

        //specify doc to delete
        db.collection("Users").document(userDoc).collection("Categories")
            .document(categoryToDelete.id).delete { error in
                //check error
                if error == nil {

                    DispatchQueue.main.async {
                        self.recipeList.removeAll { recipe in
                            return recipe.id == categoryToDelete.id
                        }
                    }
                } else {
                    //handle
                }
            }
    }

    func addCategory(
        user: String,
        name: String,
    ) {
        //get a ref
        let db = Firestore.firestore()
        //add doc
        db.collection("Users").whereField("uid", isEqualTo: user).getDocuments {
            snapshot,
            error in

            if error == nil {

                guard let docId = snapshot?.documents.first?.documentID else {
                    print("no doc found")
                    return
                }

                db.collection("Users").document(docId).collection("Categories")
                    .addDocument(data: [
                        "name": name
                    ]) { error in
                        //check error
                        if error == nil {
                            //no error
                            self.getCategories()
                        } else {
                            //handle
                        }

                    }
            }
        }
    }

    func getCategories() {

        guard let userDoc = userDoc else {
            print("error: docs is nil")
            return
        }
        //ref
        let db = Firestore.firestore()

        db.collection("Users").document(userDoc).collection("Categories")
            .getDocuments { snapshot, error in

                //check error
                if error == nil {
                    if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            //get all categories
                            self.categoryList = snapshot.documents.map {
                                category in
                                return CategoryItem(
                                    id: category.documentID,
                                    name: category["name"] as? String ?? ""
                                )

                            }
                        }
                    }
                }
            }
    }

    func deleteRecipe(recipeToDelete: RecipeItem) {
        guard let userDoc = userDoc else {
            print("error: docs is nil")
            return
        }
        //get ref
        let db = Firestore.firestore()

        //specify doc to delete
        db.collection("Users").document(userDoc).collection("Categories")
            .document(recipeToDelete.categoryId).collection("Recipes")
            .document(recipeToDelete.id).delete { error in

                //check error
                if error == nil {

                    DispatchQueue.main.async {
                        self.recipeList.removeAll { recipe in
                            return recipe.id == recipeToDelete.id
                        }
                    }
                } else {
                    //handle
                }
            }
    }

    func addRecipe(
        user: String,
        name: String,
        ingredients: [String],
        instructions: [String],
        rating: Double,
        categoryId: String
    ) {
        //ref
        let db = Firestore.firestore()
        db.collection("Users").whereField("uid", isEqualTo: user).getDocuments {
            snapshot,
            error in

            if error == nil {

                guard let docId = snapshot?.documents.first?.documentID else {
                    print("no doc found")
                    return
                }

                if categoryId.isEmpty {
                    db.collection("Users").document(docId).collection(
                        "Categories"
                    )
                    .whereField("name", isEqualTo: "Miscellaneous")
                    .getDocuments { categorySnapshot, categoryError in
                        if let miscDoc = categorySnapshot?.documents.first {
                            let actualMiscId = miscDoc.documentID
                            db.collection("Users").document(docId).collection(
                                "Categories"
                            )
                            .document(actualMiscId).collection("Recipes")
                            .addDocument(data: [
                                "name": name, "ingredients": ingredients,
                                "instructions": instructions, "rating": rating,
                                "categoryId": actualMiscId,
                            ]) { error in
                                //check err
                                if error == nil {
                                    self.getRecipes()
                                }
                            }
                        }
                    }
                } else {
                    db.collection("Users").document(docId).collection(
                        "Categories"
                    )
                    .document(categoryId).collection("Recipes")
                    .addDocument(data: [
                        "name": name, "ingredients": ingredients,
                        "instructions": instructions, "rating": rating,
                        "categoryId": categoryId,
                    ]) { error in
                        //check err
                        if error == nil {
                            self.getRecipes()
                        }
                    }
                }
            }
        }
    }

    func getRecipes() {
        guard let userDoc = userDoc else {
            print("error: docs is nil")
            return
        }

        //ref database
        let db = Firestore.firestore()

        db.collection("Users").document(userDoc).collection("Categories")
            .getDocuments { snapshot, error in
                //check error}
                if error == nil {
                    //no err
                    if let snapshot = snapshot {
                        var userRecipes: [RecipeItem] = []

                        //get recipes from all categories
                        for categoryDoc in snapshot.documents {
                            let categoryId = categoryDoc.documentID

                            db.collection("Users").document(userDoc)
                                .collection("Categories").document(categoryId)
                                .collection("Recipes").getDocuments {
                                    recipeSnap,
                                    error in
                                    if error == nil {
                                        if let recipeSnap = recipeSnap {
                                            let catRecipes = recipeSnap
                                                .documents.map { recipe in
                                                    return RecipeItem(
                                                        id: recipe.documentID,
                                                        name: recipe["name"]
                                                            as? String
                                                            ?? "",
                                                        ingredients: recipe[
                                                            "ingredients"
                                                        ]
                                                            as? [String]
                                                            ?? [],
                                                        instructions: recipe[
                                                            "instructions"
                                                        ]
                                                            as? [String]
                                                            ?? [],
                                                        rating: recipe["rating"]
                                                            as? Double
                                                            ?? -1.0,
                                                        categoryId: categoryId
                                                    )
                                                }
                                            userRecipes.append(
                                                contentsOf: catRecipes
                                            )
                                            DispatchQueue.main.async {
                                                self.recipeList = userRecipes
                                            }
                                        }
                                    } else {
                                        print("error getting recipes")
                                    }
                                }
                        }
                    }
                } else {
                    print("error getting categories")
                }
            }

    }
}
