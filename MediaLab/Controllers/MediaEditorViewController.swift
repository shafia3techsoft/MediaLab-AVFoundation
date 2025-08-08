//
//  MediaEditorViewController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import UIKit
import AVFoundation
import MobileCoreServices


class MediaEditorViewController: UIViewController, UIDocumentPickerDelegate {

    private enum PickerType {
        case video
        case audio
    }

    private var currentPickerType: PickerType?

    
    private let mediaEditor = MediaEditor()
    private let playerView = PlayerView()

    private var videoURL: URL?
    private var audioURL: URL?

    private let selectVideoButton = UIButton(type: .system)
    private let selectAudioButton = UIButton(type: .system)
    private let mergeButton = UIButton(type: .system)
    private let trimButton = UIButton(type: .system)
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Media Editor"
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        // Buttons
        selectVideoButton.setTitle("Select Video", for: .normal)
        selectVideoButton.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)

        selectAudioButton.setTitle("Select Audio", for: .normal)
        selectAudioButton.addTarget(self, action: #selector(selectAudio), for: .touchUpInside)

        mergeButton.setTitle("Merge Video & Audio", for: .normal)
        mergeButton.addTarget(self, action: #selector(mergeMedia), for: .touchUpInside)
        mergeButton.isEnabled = false

        trimButton.setTitle("Trim Video (first 5 sec)", for: .normal)
        trimButton.addTarget(self, action: #selector(trimVideo), for: .touchUpInside)
        trimButton.isEnabled = false

        statusLabel.text = "Select video and audio files"
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [selectVideoButton, selectAudioButton, mergeButton, trimButton, statusLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            playerView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

//    @objc private func selectVideo() {
//        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String], in: .import)
//        picker.delegate = self
//        picker.allowsMultipleSelection = false
//        picker.modalPresentationStyle = .formSheet
//        picker.accessibilityLabel = "Select a video file"
//        present(picker, animated: true)
//    }
//
//    @objc private func selectAudio() {
//        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
//        picker.delegate = self
//        picker.allowsMultipleSelection = false
//        picker.modalPresentationStyle = .formSheet
//        picker.accessibilityLabel = "Select an audio file"
//        present(picker, animated: true)
//    }
    
    @objc private func selectVideo() {
        currentPickerType = .video
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String], in: .import)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true)
    }

    @objc private func selectAudio() {
        currentPickerType = .audio
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true)
    }


    @objc private func mergeMedia() async {
        guard let videoURL, let audioURL else {
            statusLabel.text = "Please select both video and audio files."
            return
        }

        statusLabel.text = "Merging..."
        await mediaEditor.merge(videoURL: videoURL, audioURL: audioURL) { [weak self] mergedURL in
            DispatchQueue.main.async {
                if let mergedURL = mergedURL {
                    self?.statusLabel.text = "Merge successful!"
                    self?.playerView.playMedia(from: mergedURL)
                } else {
                    self?.statusLabel.text = "Merge failed."
                }
            }
        }
    }

    @objc private func trimVideo() async {
        guard let videoURL else {
            statusLabel.text = "Please select a video file first."
            return
        }

        statusLabel.text = "Trimming video..."
        let startTime = CMTime(seconds: 0, preferredTimescale: 600)
        let endTime = CMTime(seconds: 5, preferredTimescale: 600) // first 5 seconds

        await mediaEditor.trim(videoURL: videoURL, startTime: startTime, endTime: endTime) { [weak self] trimmedURL in
            DispatchQueue.main.async {
                if let trimmedURL = trimmedURL {
                    self?.statusLabel.text = "Trim successful!"
                    self?.playerView.playMedia(from: trimmedURL)
                } else {
                    self?.statusLabel.text = "Trim failed."
                }
            }
        }
    }

    // MARK: - UIDocumentPickerDelegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedURL = urls.first else { return }

        switch currentPickerType {
        case .video:
            videoURL = pickedURL
            statusLabel.text = "Video selected: \(pickedURL.lastPathComponent)"
            trimButton.isEnabled = true
        case .audio:
            audioURL = pickedURL
            statusLabel.text = "Audio selected: \(pickedURL.lastPathComponent)"
        case .none:
            break
        }

        mergeButton.isEnabled = (videoURL != nil && audioURL != nil)
    }

}
