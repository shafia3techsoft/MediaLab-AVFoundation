//
//  AudioViewController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    private let audioRecorderController = AudioRecorderController()
    private let playerView = PlayerView()

    private let recordButton = UIButton(type: .system)
    private let playButton = UIButton(type: .system)

    private var isRecording = false
    private var isPlaying = false
    private var recordedAudioURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Audio Recorder"
        view.backgroundColor = .white

        setupUI()
    }

    private func setupUI() {
        // Record Button
        recordButton.setTitle("Start Recording", for: .normal)
        recordButton.tintColor = .systemRed
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)

        // Play Button
        playButton.setTitle("Play Recording", for: .normal)
        playButton.tintColor = .systemBlue
        playButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.isEnabled = false
        view.addSubview(playButton)

        // PlayerView (optional for visualization)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)

        // Layout Constraints
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            playButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            playerView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 40),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func toggleRecording() {
        if isRecording {
            audioRecorderController.stopRecording()
            recordedAudioURL = audioRecorderController.recordedAudioURL
            playButton.isEnabled = (recordedAudioURL != nil)
            recordButton.setTitle("Start Recording", for: .normal)
        } else {
            audioRecorderController.startRecording()
            playButton.isEnabled = false
            recordButton.setTitle("Stop Recording", for: .normal)
        }
        isRecording.toggle()
    }

    @objc private func togglePlayback() {
        guard let url = recordedAudioURL else { return }

        if isPlaying {
            playerView.player?.pause()
            playButton.setTitle("Play Recording", for: .normal)
        } else {
            playerView.playMedia(from: url)
            playButton.setTitle("Pause", for: .normal)
        }
        isPlaying.toggle()
    }
}
