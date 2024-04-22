//
//  MovieData.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import Foundation



struct Welcome: Codable {
    let boxOfficeResult: BoxOfficeResult
}


struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let BoxOfficeList: [BoxOfficeList]
}


struct BoxOfficeList: Codable {
    let rnum, movieRank: String
    let rankOldAndNew: RankOldAndNew
    let movieCD, movieName, openDate: String
    let todayAudiCount, totalAudiCount : String

    enum CodingKeys: String, CodingKey {
        case rnum
        case movieRank = "rank", rankOldAndNew
        case movieCD = "movieCd"
        case movieName = "movieNm"
        case openDate = "openDt"
        case todayAudiCount = "audiCnt" //오늘 관객 수
        case totalAudiCount = "audiAcc" //누적 관객 수
    }
}

enum RankOldAndNew: String, Codable {
    case old = "OLD"
}
