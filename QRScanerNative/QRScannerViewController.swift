//
//  QRScannerViewController.swift
//  QRScanerNative
//
//  Created by Andrei Bezlepkin on 12.03.22.
//
import AVFoundation
import UIKit

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var qrCodeFrame: UIView?
    
    private let supportCodeTypes = [AVMetadataObject.ObjectType.upce,
                                    AVMetadataObject.ObjectType.code39,
                                    AVMetadataObject.ObjectType.code39Mod43,
                                    AVMetadataObject.ObjectType.code93,
                                    AVMetadataObject.ObjectType.code128,
                                    AVMetadataObject.ObjectType.ean8,
                                    AVMetadataObject.ObjectType.ean13,
                                    AVMetadataObject.ObjectType.aztec,
                                    AVMetadataObject.ObjectType.pdf417,
                                    AVMetadataObject.ObjectType.itf14,
                                    AVMetadataObject.ObjectType.dataMatrix,
                                    AVMetadataObject.ObjectType.interleaved2of5,
                                    AVMetadataObject.ObjectType.qr]
    
    
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var uRLAdressLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Scanning()
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportCodeTypes
        } catch {
            print(error)
            return
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer)
        captureSession.startRunning()
        view.bringSubviewToFront(uRLAdressLabel)
        view.bringSubviewToFront(topBar)
        
        qrCodeFrame = UIView()
        if let qrCodeFrame = qrCodeFrame {
            qrCodeFrame.layer.borderColor = UIColor.green.cgColor
            qrCodeFrame.layer.borderWidth = 2
            view.addSubview(qrCodeFrame)
            view.bringSubviewToFront(qrCodeFrame)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrame?.frame = .zero
            uRLAdressLabel.text = ""
            return
        }
        
        let metaDataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metaDataObj.type == AVMetadataObject.ObjectType.qr {
            
            let barCodeObj = videoPreviewLayer.transformedMetadataObject(for: metaDataObj)
            qrCodeFrame?.frame = barCodeObj!.bounds
            
            if metaDataObj.stringValue != nil {
                uRLAdressLabel.text = metaDataObj.stringValue
            }
        }
    }
    
    
    
    
    private func Scanning() {
        topBar.backgroundColor = .clear
        uRLAdressLabel.textColor = .white
        
    }
    
    
    
}
