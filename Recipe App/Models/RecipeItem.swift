//
//  RecipeItem.swift
//  Recipe App
//
// Author: Maya Vanderpool
//

import Foundation

struct RecipeItem: Identifiable{
    
    var id:String
    var name:String
    var ingredients:[String]
    var instructions:[String]
    var rating:Double = -1.0
    var categoryId: String
}
