//
//  ViewController.swift
//  QRScanerNative
//
//  Created by Andrei Bezlepkin on 12.03.22.
//

import UIKit

class QRCodeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground

    }
    
    @IBAction func returnToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}

