//
//  ScanViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 8/11/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import AVFoundation
import UIKit

class ScanViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
}

// MARK: - LifeCicle
extension ScanViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scanView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scanView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            loadingView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = loadingView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            loadingView.insertSubview(blurEffectView, belowSubview: indicator)
            indicator.hidesWhenStopped = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
            //view.layoutSubviews()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    } 
}

// MARK: - Fileprivate methods
fileprivate extension ScanViewController {
    func found(code: String) {
        loadingView.isHidden = false
        indicator.startAnimating()
        
        let alertAction: EmptyCallback = {
            self.loadingView.isHidden = true
            self.captureSession.startRunning()
        }
        
        let successfulCallback: Callback1 = { count in
            let count = count as! Int
            self.indicator.stopAnimating()
            
            Presenter.shared.presentAlert("Success", "You are credited with " + String(count) + " minutes", self, callback: alertAction)
        }
        
        let failureCallback: Callback1 = { error in
            self.indicator.stopAnimating()
            let error = error as? Error
            if error == nil {
                Presenter.shared.presentAlert("Sorry", "This code is invalid", self, callback: alertAction)
            } else {
                Presenter.shared.presentAlert("Error", error?.localizedDescription as! String, self, callback: alertAction)
            }
        }
        
        FirebaseManager.shared.checkSubsciption(code, successfulCallback, failureCallback)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
