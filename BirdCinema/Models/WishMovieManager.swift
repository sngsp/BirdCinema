//
//  WishMovieManager.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/26.
//

import Foundation

class WishMovieManager {
    static let shared = WishMovieManager() // Singleton 인스턴스
    private init() {}
    
    var wishlist: [WishMovieData] = []
    
    func addMovieToWishlist(_ movieData: WishMovieData) {
        wishlist.append(movieData)
    }
}
