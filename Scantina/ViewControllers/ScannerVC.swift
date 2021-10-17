//
//  ScannerVC.swift
//  Scantina
//
//  Created by Danny Copeland on 9/26/21.
//

import UIKit
import AVFoundation
import MLKitBarcodeScanning
import MLKitVision

class ScannerVC: UIViewController {
    
    //MARK: - Properties
    private var scanner: CantinaScanner?
    
    private let overlayImageHeight: CGFloat = 150
    private let overlayImageWidth:CGFloat = 300
    
    private lazy var cameraViewArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var barcodeOverlay: UIImageView = {
        let iv = UIImageView(image: ThemeImages.scannerOverlay)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.alpha = 0.3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var thumbOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var lightBulbOverlay: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "light.max")?.maskWithColor(color: UIColor.systemYellow))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var zoomInOverlay: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "plus.magnifyingglass")?.maskWithColor(color: UIColor.primaryColor!))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var zoomOutOverlay: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "minus.magnifyingglass")?.maskWithColor(color: UIColor.primaryColor!))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //get/check permission for camera
        var hasAccess = false
        var accessRequested = false
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            hasAccess = true
        case .notDetermined: // The user has not yet been asked for camera access.
            accessRequested = true
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    hasAccess = true
                    DispatchQueue.main.async {
                        self.startScanner()
                    }
                }
            }
        case .denied: // The user has previously denied access.
            hasAccess = false
        case .restricted: // The user can't grant access due to restrictions.
            hasAccess = false
        @unknown default:
            hasAccess = false
        }
        
        if hasAccess {
            self.startScanner()
        } else {
            if !accessRequested {
                // displayPermissionMessage(withMessage: PermissionsManager.PermissionMessages.cameraPermissionMessage)
            }
        }
        
    }
    
    //MARK: - UI
    private func setupUI() {
        view.backgroundColor = UIColor.primaryColor
        
        thumbOptionStackView.addArrangedSubview(zoomOutOverlay)
        thumbOptionStackView.addArrangedSubview(lightBulbOverlay)
        thumbOptionStackView.addArrangedSubview(zoomInOverlay)
        
        view.addSubview(cameraViewArea)
        view.addSubview(barcodeOverlay)
        view.addSubview(thumbOptionStackView)
        
        lightBulbOverlay.isUserInteractionEnabled = true
        let tappedLight = UITapGestureRecognizer.init(target: self, action: #selector(toggleLightSwitch(tapGesture:)))
        lightBulbOverlay.addGestureRecognizer(tappedLight)
        
        NSLayoutConstraint.activate([
            
            thumbOptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            thumbOptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            thumbOptionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            thumbOptionStackView.heightAnchor.constraint(equalToConstant: 20),
            
            cameraViewArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraViewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraViewArea.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            barcodeOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barcodeOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            barcodeOverlay.heightAnchor.constraint(equalToConstant: overlayImageHeight),
            barcodeOverlay.widthAnchor.constraint(equalToConstant: overlayImageWidth),
            
        ])
        
    }
    
    //MARK: - Helpers
    
    private func startScanner() {
        self.scanner = CantinaScanner(withDelegate: self)
        guard let scanner = self.scanner else {
            return
        }
        scanner.requestCaptureSessionStartRunning()
    }
    
    private func stopScanner() {
        guard let scanner = self.scanner else {
            return
        }
        scanner.requestCaptureSessionStopRunning()
    }

    // If device has torch, toggle it on/off
    @objc func toggleLightSwitch(tapGesture:UITapGestureRecognizer) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return } //check for torch
        
        do {
            try device.lockForConfiguration()
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

    
    func displayAlertRestartScanner(withMessage message: String, withTitle title: String) {
        let reScanAlert = ScanAlertVC(title: title, message: message, buttonTitle: "Close")
        reScanAlert.modalPresentationStyle = .overFullScreen
        reScanAlert.modalTransitionStyle = .crossDissolve
        reScanAlert.actionButton.addTarget(self, action: #selector(reStartScanner), for: .touchUpInside)
        self.present(reScanAlert, animated: true)
    }
    
    @objc func reStartScanner() {
        self.startScanner()
    }
   
}

//MARK: - AV Capture Delegate
extension ScannerVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let scanner = self.scanner else {
            return
        }
        scanner.captureOutput(output, didOutput: sampleBuffer, from: connection)
    }
}

//MARK: - Scanner Delegate
extension ScannerVC: ScannerDelegate {
    func cameraView() -> UIView {
        return cameraViewArea
    }
    
    func delegateViewController() -> UIViewController {
        return self
    }
    
    func scanCompleted(withScannedValue value: String, withType type: BarcodeFormat) {
     
        let cameraCaptureSystemSoundId: UInt32 = 1108
        AudioServicesPlaySystemSound(cameraCaptureSystemSoundId)
        //check the response...
        if value.isEmpty {
            displayAlertRestartScanner(withMessage: "No Value Found", withTitle: "Close")
            return
        }
        
        print("type: \(type)")
        
        displayAlertRestartScanner(withMessage: "Type: \(type)", withTitle: "Title: \(value)")
        
        switch type {
        case .code39:
            print("code39")
        case .code128:
            print("code128")
        case .UPCE:
            print("UPCE")
        case .qrCode:
            print("qrCode")
        case .UPCA:
            print("UPCA")
        case .EAN13:
            print("EAN13")
        default:
            print("default")
        }
    }
}
