/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation
import AVFoundation

// AVPlayer 클래스의 확장(Extension)을 정의합니다.
extension AVPlayer {
    // AVPlayer의 공유 인스턴스를 정의합니다.
    static let sharedDingPlayer: AVPlayer = {
        // "ding.wav" 파일의 URL을 찾습니다. 만약 파일을 찾을 수 없다면 오류를 발생시킵니다.
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else { fatalError("Failed to find sound file.") }
        // URL을 사용하여 AVPlayer 인스턴스를 생성하고 반환합니다.
        return AVPlayer(url: url)
    }()
}
