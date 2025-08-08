//
//  AudioEffectsViewController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import UIKit
import AVFoundation
import MobileCoreServices

class AudioEffectsViewController: UIViewController, UIDocumentPickerDelegate {

    private let audioEffectsController = AudioEffectsController()

    private let selectAudioButton = UIButton(type: .system)
    private let playButton = UIButton(type: .system)
    private let pitchSlider = UISlider()
    private let reverbSlider = UISlider()
    private let statusLabel = UILabel()

    private var isPlaying = false
    private var audioURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Audio Effects"
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        selectAudioButton.setTitle("Select Audio File", for: .normal)
        selectAudioButton.addTarget(self, action: #selector(selectAudio), for: .touchUpInside)

        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        playButton.isEnabled = false

        pitchSlider.minimumValue = -1200
        pitchSlider.maximumValue = 1200
        pitchSlider.value = 0
        pitchSlider.addTarget(self, action: #selector(pitchChanged), for: .valueChanged)

        reverbSlider.minimumValue = 0
        reverbSlider.maximumValue = 100
        reverbSlider.value = 50
        reverbSlider.addTarget(self, action: #selector(reverbChanged), for: .valueChanged)

        statusLabel.text = "Select an audio file to apply effects"
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0

        
        let pitchLabel = UILabel()
        pitchLabel.text = "Pitch"

        let reverbLabel = UILabel()
        reverbLabel.text = "Reverb"

        let stack = UIStackView(arrangedSubviews: [
            selectAudioButton,
            playButton,
            pitchLabel,
            pitchSlider,
            reverbLabel,
            reverbSlider,
            statusLabel
        ])

        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)


        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func selectAudio() {
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
        picker.delegate = self
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true)
    }

    @objc private func togglePlayback() {
        guard audioURL != nil else { return }

        if isPlaying {
            audioEffectsController.stop()
            playButton.setTitle("Play", for: .normal)
        } else {
            do {
                try audioEffectsController.loadAudioFile(url: audioURL!)
                audioEffectsController.play()
                playButton.setTitle("Stop", for: .normal)
            } catch {
                statusLabel.text = "Failed to load audio."
                return
            }
        }
        isPlaying.toggle()
    }

    @objc private func pitchChanged() {
        audioEffectsController.setPitch(pitchSlider.value)
    }

    @objc private func reverbChanged() {
        audioEffectsController.setReverbMix(reverbSlider.value)
    }

    // MARK: - UIDocumentPickerDelegate

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedURL = urls.first else { return }
        audioURL = pickedURL
        statusLabel.text = "Audio selected: \(pickedURL.lastPathComponent)"
        playButton.isEnabled = true
    }
}
