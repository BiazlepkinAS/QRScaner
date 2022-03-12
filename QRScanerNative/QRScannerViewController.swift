//
//  QRScannerViewController.swift
//  QRScanerNative
//
//  Created by Andrei Bezlepkin on 12.03.22.
//
import AVFoundation
import UIKit

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    private var qrCodeFrame: UIView?
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
                                    AVMetadataObject.ObjectType.qr
    ]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var baclURLAdressView: UIView!
    @IBOutlet weak var uRLAdressLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func menuShow(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Scanning()
        showMenu()
        gestureLeft()
        
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
        view.bringSubviewToFront(moreButton)
        
        qrCodeFrame = UIView()
        if let qrCodeFrame = qrCodeFrame {
            qrCodeFrame.layer.borderColor = UIColor.green.cgColor
            qrCodeFrame.layer.borderWidth = 2
            baclURLAdressView.backgroundColor = .clear
            view.bringSubviewToFront(baclURLAdressView)
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
            titleLabel.isHidden = true
            moreButton.isHidden = false
            return
        }
        
        let metaDataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metaDataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObj = videoPreviewLayer.transformedMetadataObject(for: metaDataObj)
            qrCodeFrame?.frame = barCodeObj!.bounds
            if metaDataObj.stringValue != nil {
                uRLAdressLabel.text = metaDataObj.stringValue
                uRLChangePosition()
            }
        }
    }
    
    private func uRLChangePosition() {
        baclURLAdressView.translatesAutoresizingMaskIntoConstraints = false
        uRLAdressLabel.topAnchor.constraint(equalTo: qrCodeFrame!.bottomAnchor, constant: 10).isActive = true
        uRLAdressLabel.backgroundColor = .yellow
        moreButton.isHidden = false
    }
    
    private func Scanning() {
        moreButton.isHidden = true
        moreButton.layer.cornerRadius = 15
        moreButton.backgroundColor = .yellow
        
        uRLAdressLabel.textColor = .black
        uRLAdressLabel.backgroundColor = .clear
        topBar.backgroundColor = .clear
    }
    
    private func showMenu() {
        let shared = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
            print("shared action was tapped")
        }
        
        let copyLink = UIAction(title: "copy Links", image: UIImage(systemName: "doc.on.doc.fill")) { (action) in
            print("Add User action was tapped")
        }
        
        let addToReadList = UIAction(title: "add to readList", image: UIImage(systemName: "eyeglasses")) { (action) in
            print("Remove User action was tapped")
        }
        
        let openToApp = UIAction(title: "open in App", image: UIImage(systemName:"safari")) { (action) in
            print("Add to App action tapped")
        }
        
        let menu = UIMenu(title: "Menu", options: .displayInline, children: [shared , copyLink, addToReadList, openToApp])

        moreButton.menu = menu
        moreButton.showsMenuAsPrimaryAction = true
    }
    private func gestureLeft() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
    }
    @objc func swipeFunc(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            performSegue(withIdentifier: "Left", sender: self)
        } else {
            print("hello")
        }
    }
}
