//
//  ReservationManager.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/24.
//

import Foundation

class ReservationManager {
    static let shared = ReservationManager() // Singleton 인스턴스
    private init() {}
    
    var reservations: [ReservationData] = []
    
    func addReservation(_ reservation: ReservationData) {
        reservations.append(reservation)
    }
}
