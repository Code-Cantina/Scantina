//
//  CantinaScanner.swift
//  Scantina
//
//  Created by Danny Copeland on 10/2/21.
//

import UIKit
import AVFoundation
import MLKitBarcodeScanning
import MLKitVision

protocol ScannerDelegate: AnyObject {
    func cameraView() -> UIView
    func delegateViewController() -> UIViewController
    func scanCompleted(withScannedValue value: String, withType type: BarcodeFormat)
}

class CantinaScanner: NSObject {
    public weak var delegate: ScannerDelegate?
    private var captureSession : AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var statusBarOrientation: UIInterfaceOrientation? {
        get {
            guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                return nil
            }
            return orientation
        }
    }
    
    init(withDelegate delegate: ScannerDelegate) {
        self.delegate = delegate
        super.init()
        self.scannerSetup()
    }
    
    var barcodeScanner: MLKitBarcodeScanning.BarcodeScanner?
    
    private func scannerSetup() {
        guard let captureSession = self.createCaptureSession() else {
            return
        }
        
        self.captureSession = captureSession
        
        guard let delegate = self.delegate else {
            return
        }
        
        let barcodeOptions = BarcodeScannerOptions(formats: [.EAN13, .code39, .code128, .UPCA, .UPCE, .qrCode])
        barcodeScanner = MLKitBarcodeScanning.BarcodeScanner.barcodeScanner(options: barcodeOptions)
        
        let cameraView = delegate.cameraView()
        setupPreviewLayer(withCaptureSession: captureSession, view: cameraView)
        cameraView.layer.addSublayer(previewLayer!)
    }
    
    private func createCaptureSession() -> AVCaptureSession? {
        do {
            let captureSession = AVCaptureSession()
            guard let captureDevice = AVCaptureDevice.default(for: .video) else {
                return nil
            }
            
            try! captureDevice.lockForConfiguration()
            captureDevice.focusMode = .continuousAutoFocus
            captureDevice.unlockForConfiguration()
            
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            let deviceOutput = AVCaptureVideoDataOutput()
            deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            
            // Add device input
            if captureSession.canAddInput(deviceInput) && captureSession.canAddOutput(deviceOutput) {
                captureSession.addInput(deviceInput)
                captureSession.addOutput(deviceOutput)
                captureSession.sessionPreset = .high
                
                guard let delegate = self.delegate,
                    let viewController = delegate.delegateViewController() as? AVCaptureVideoDataOutputSampleBufferDelegate else {
                        return nil
                }
               
                deviceOutput.setSampleBufferDelegate(viewController, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
                
                return captureSession
            }
        }
        catch {
            //  log error and return nil
            return nil
        }
        
        return nil
    }
    
    private func setupPreviewLayer(withCaptureSession captureSession: AVCaptureSession, view: UIView) {
        if let staOrien = self.statusBarOrientation {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.frame = view.layer.bounds
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.connection?.videoOrientation = interfaceOrientationToVideoOrientation(staOrien)
        }
    }
    
    func didChangeOrientation(view: UIView) {
        if let staOrien = self.statusBarOrientation {
            previewLayer?.connection?.videoOrientation = interfaceOrientationToVideoOrientation(staOrien)
            previewLayer?.frame = view.layer.bounds
            previewLayer?.videoGravity = .resizeAspectFill
        }
    }
    
    private func interfaceOrientationToVideoOrientation(_ orientation : UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch (orientation) {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            return .portraitUpsideDown
        }
    }
    
    var isProcessingScan: Bool = false
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let scanner = self.barcodeScanner {
            let image = VisionImage(buffer: sampleBuffer)
            
            scanner.process(image) { features, error in
                
                guard error == nil, let features = features, !features.isEmpty else {
                    return
                }
                
                self.requestCaptureSessionStopRunning()
                
                if !self.isProcessingScan {
                    self.isProcessingScan = true
                    let firstCapturedBarcode = features[0]
                    if let val = firstCapturedBarcode.rawValue {
                        if let del = self.delegate {
                            del.scanCompleted(withScannedValue: val, withType: firstCapturedBarcode.format)
                            self.isProcessingScan = false
                        }
                    }
                } else {
                    print("already processing scan, wait")
                }
            }
        }
    }
    
    public func requestCaptureSessionStartRunning() {
        self.toggleCaptureSessionRunningState()
    }
    
    public func requestCaptureSessionStopRunning() {
        self.toggleCaptureSessionRunningState()
    }
    
    private func toggleCaptureSessionRunningState() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
        else  {
            captureSession.stopRunning()
        }
    }
    
    public func hardStopScanner() {
        guard let captureSession = self.captureSession else {
            return
        }
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
}


