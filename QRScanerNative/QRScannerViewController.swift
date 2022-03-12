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
    
    private let supportCadeTypes = [CodeTypes.self]
    
    
    
    @IBOutlet weak var uRLAdressLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    private func Scanning() {
        
        
        
        
        
        
        
    }
    


}
