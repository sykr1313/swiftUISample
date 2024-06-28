//
//  CardView.swift
//  ScrumdingerTest
//
//  Created by ksy on 6/28/24.
//

import SwiftUI

struct CardView: View {
    let scrum: DailyScrum
    var body: some View {
        //가져온 샘플데이터의 회의제목, 인원, 시간을 넣고 배치한 후 라이트모드, 다크모드에도 동일하게 반환값으로 글자색 검은색으로 지정하기
        VStack(alignment: .leading) {
            Text(scrum.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader) //정보 아키텍처 전달
            Spacer()
            HStack {
                Label("\(scrum.attendees.count)", systemImage: "person.3")
                    .accessibilityLabel("\(scrum.attendees.count) attendess") //라벨을 설명하는 레이블 추가
                Spacer()
                Label("\(scrum.lengthInMinutes)", systemImage: "clock")
                    .accessibilityLabel("\(scrum.lengthInMinutes) minute meeting")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        //accentColor 코드대로 현재 샘플데이터의 색이 노랑색이기에 검은색이 반환된다
        .foregroundStyle(scrum.theme.accentColor)
    }
}
//0번째 샘플데이터를 가져와 배경색과 프레임 사이즈를 지정함
struct CardView_Previews: PreviewProvider {
    static var scrum = DailyScrum.sampleData[0]
    static var previews: some View {
        CardView(scrum: scrum)
            .background(scrum.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

//#Preview {
//    CardView()
//}
