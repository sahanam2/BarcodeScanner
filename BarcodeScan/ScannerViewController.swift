//
//  ScanViewController.swift
//  BarcodeScan
//
//  Created by Manjesh.Sahana on 2023/09/06.
//


import AVFoundation
/*
import UIKit

@objc protocol ScannerViewDelegate: AnyObject {
     @objc func didFindScannedText(text: String)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    weak var delegate: ScannerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
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
        //Initialize an AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
 
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [ .code128]
            //.ean8, .code39, .qr
 
        } else {
            failed()
            return
        }
        //captureSession.canSetSessionPreset(AVCaptureSession.Preset.low)
 
        //Initialize the video preview layer and add it as a sublayer.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        //Start video capture
        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

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

    func found(code: String) {
            print(code)
            //Assigning the delegate of the found code to the text and popping to our main viewController
            delegate?.didFindScannedText(text: code)
            self.navigationController?.popViewController(animated: true)
        }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
*/


import UIKit
import ZXingObjC

@objc protocol ScannerViewDelegate: AnyObject {
     @objc func didFindScannedText(text: String)
}
    
class ScannerViewController: UIViewController, ZXCaptureDelegate {
    var capture: ZXCapture?
    
    weak var delegate: ScannerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.capture = ZXCapture()
        self.capture?.delegate = self
        //self.capture?.camera = back()

        
        if let capture = self.capture {
            capture.camera = capture.back()
            let captureLayer = capture.layer as! AVCaptureVideoPreviewLayer
            captureLayer.frame = self.view.bounds
            self.view.layer.addSublayer(captureLayer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start capturing when the view appears
        self.capture?.start()
    }
    
    // Implement the ZXCaptureDelegate methods
    
    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        if let result = result {
            let barcodeText = result.text
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

            print("Scanned barcode: \(barcodeText)")
            delegate?.didFindScannedText(text: barcodeText ?? "-")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
