//
//  CustomVideoPlayerView.swift
//  Rooba
//
//  Created by Sajjad Hajavi on 7/13/25.
//

import SwiftUI
import AVKit

@MainActor class PlayerViewModel: ObservableObject {
    let player: AVPlayer
    private var url = ""
    init(url: String) {
        self.url = url
        player = AVPlayer(url: url.asUrl)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            try audioSession.setCategory(.ambient, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to switch back to playback mode:", error.localizedDescription)
        }
    }
}
public struct SHVideoPlayerView: View {
    @Binding var isPortrait: Bool
    @State private var isPlaying: Bool = false
    @StateObject private var playerVM: PlayerViewModel
    public init(url: String, isPortrait: Binding<Bool>) {
        _playerVM = StateObject(wrappedValue: PlayerViewModel(url: url))
        self._isPortrait = isPortrait
    }

    public var body: some View {
        VideoPlayer(player: playerVM.player)
            .aspectRatio(isPortrait ? 9/16 : 16/9, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                if !isPlaying {
                    Button {
                        playerVM.player.play()
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                    }
                }
            }
    }
}

#Preview {
    SHVideoPlayerView(url: "", isPortrait: .constant(true))
}
