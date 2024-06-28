//
//  TrailingIconLabelStyle.swift
//  ScrumdingerTest
//
//  Created by ksy on 6/28/24.
//

import SwiftUI

//여러뷰에 동일한 라벨 스타일을 지정하여 앱 전체에 일관적인 디자인 적용하기
struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

//.이라는 이름의 정적 속성을 생성하는 확장기능을 추가합니다(선행 점구문 호출)
extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}

