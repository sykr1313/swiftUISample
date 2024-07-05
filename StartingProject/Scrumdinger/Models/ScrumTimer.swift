/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation
/// 주기적으로 회의 상태를 업데이트, 타이머는 발표자가 변경되고 속성을 통해 다른 중요한 상태 변경을 호출할 때 클로저를 호출한다
/// 일일 스크럼 회의를 위한 시간을 측정합니다. 전체 회의 시간, 각 발언자의 시간, 현재 발언자의 이름을 추적합니다.
@MainActor
final class ScrumTimer: ObservableObject {
    /// 회의 중 참석자를 추적하기 위한 구조체입니다.
    struct Speaker: Identifiable {
        /// 참석자 이름.
        let name: String
        /// 참석자가 발언을 완료했는지 여부.
        var isCompleted: Bool
        /// Identifiable 준수를 위한 Id.
        let id = UUID()
    }
    
    /// 발언 중인 회의 참석자의 이름.
    @Published var activeSpeaker = ""
    /// 회의 시작 이후 경과된 시간(초).
    @Published var secondsElapsed = 0
    /// 모든 참석자가 발언을 마칠 때까지 남은 시간(초).
    @Published var secondsRemaining = 0
    /// 모든 회의 참석자, 발언 순서대로 나열됨.
    private(set) var speakers: [Speaker] = []

    /// 스크럼 회의 시간.
    private(set) var lengthInMinutes: Int
    /// 새로운 참석자가 발언을 시작할 때 실행되는 클로저.
    var speakerChangedAction: (() -> Void)?

    private weak var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60 }
    private var secondsPerSpeaker: Int {
        (lengthInMinutes * 60) / speakers.count
    }
    private var secondsElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "발언자 \(speakerIndex + 1): " + speakers[speakerIndex].name
    }
    private var startDate: Date?
    
    /**
     새로운 타이머를 초기화합니다. 인수 없이 타이머를 초기화하면 참석자 없이 길이가 0인 ScrumTimer가 생성됩니다.
     타이머를 시작하려면 `startScrum()`을 사용하십시오.
     
     - 매개변수:
        - lengthInMinutes: 회의 시간.
        - attendees: 회의 참석자 목록.
     */
    init(lengthInMinutes: Int = 0, attendees: [DailyScrum.Attendee] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    /// 타이머를 시작합니다.
    func startScrum() {
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            self?.update()
        }
        timer?.tolerance = 0.1
        changeToSpeaker(at: 0)
    }
    
    /// 타이머를 중지합니다.
    func stopScrum() {
        timer?.invalidate()
        timerStopped = true
    }
    
    /// 타이머를 다음 발언자로 진행합니다.
    nonisolated func skipSpeaker() {
        Task { @MainActor in
            changeToSpeaker(at: speakerIndex + 1)
        }
    }

    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker = speakerText

        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        startDate = Date()
    }

    nonisolated private func update() {
        Task { @MainActor in
            guard let startDate,
                  !timerStopped else { return }
            let secondsElapsed = Int(Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
            secondsElapsedForSpeaker = secondsElapsed
            self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
            guard secondsElapsed <= secondsPerSpeaker else {
                return
            }
            secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)

            if secondsElapsedForSpeaker >= secondsPerSpeaker {
                changeToSpeaker(at: speakerIndex + 1)
                speakerChangedAction?()
            }
        }
    }
    
    /**
     새로운 회의 시간과 새로운 참석자로 타이머를 재설정합니다.
     
     - 매개변수:
         - lengthInMinutes: 회의 시간.
         - attendees: 각 참석자의 이름.
     */
    func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
}

extension Array<DailyScrum.Attendee> {
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            return [ScrumTimer.Speaker(name: "발언자 1", isCompleted: false)]
        } else {
            return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false) }
        }
    }
}
