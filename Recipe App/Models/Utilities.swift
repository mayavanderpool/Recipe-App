//
//  PlatformStyle.swift
//  Recipe App
//
/// Author: Maya Vanderpool
//
import Foundation
import SwiftUI

struct Utilities{
    // Sets background image based on platform
    static var backgroundImage:String {
    #if os(iOS)
        return "iosBackground"
    #else
        return "macBackground"
    #endif
    }
    
    static var textSize:Int {
    #if os(iOS)
        return 50
    #else
        return 200
    #endif
    }
    
    @ViewBuilder
    static func showStars(rating: Double)-> some View{
        if rating == -1{
            EmptyView()
        }
        else{
            let stars = stars(rating: rating)
            HStack(spacing:2){
                ForEach(stars, id:\.self){ star in
                    Image(systemName: star)
                        .foregroundColor(.orange)
                    
                }
            }
        }
    }
    
    
    private static func stars(rating: Double)-> [String]{
        let value = min(max(0,rating),5)
        var icons: [String] = []
        
        for i in 0..<5{
            let curr = value - Double(i)
            if curr >= 1{
                icons.append("star.filled")
            }
            else if curr < 1.0 && curr >= 0.5{
                icons.append("star.leadinghalf.filled")
            }
            else{
                icons.append("star")
            }
        }
        return icons
        
    }
}

    
    

