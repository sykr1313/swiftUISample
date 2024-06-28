//
//  Theme.swift
//  ScrumdingerTest
//
//  Created by ksy on 6/28/24.
//

import SwiftUI

// enum(구조체)를 이용하여 테마 만들기
enum Theme: String {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case popple
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    //위의 테마(String 타입)에 해당하는 이름을 반환하는 컬러를 각각 흰색, 검은색으로 지정함
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .popple, .seafoam, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }
    //색상 초기화
    var mainColor: Color {
        Color(rawValue)
    }
}


