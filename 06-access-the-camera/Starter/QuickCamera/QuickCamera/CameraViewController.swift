//
//  CameraViewController.swift
//  QuickCamera
//
//  Created by Johnny Peterson on 10/9/21.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        setupPreview()
        startSession()

    }
    override func viewWillDisappear(_ animated: Bool) {
        stopSession()
    }
    func setupSession() {
        captureSession.beginConfiguration()
        guard let camera = AVCaptureDevice.default(for: .video),
              let mic = AVCaptureDevice.default(for: .audio) else {
                  return
              }
        do {
            let videoInput = try AVCaptureDeviceInput(device: camera)
            let audioInput = try AVCaptureDeviceInput(device: mic)
            for input in [videoInput, audioInput] {
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            }
        } catch {
            print("Error for setting input Device: \(error)")
            return
        }
    }
    func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
    }
}
