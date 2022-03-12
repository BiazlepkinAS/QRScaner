//
//  ViewController.swift
//  QRScanerNative
//
//  Created by Andrei Bezlepkin on 12.03.22.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SCANNING..."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.shadowColor = .systemGray3
        label.backgroundColor = .yellow
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
configUI()
    }
    
    private func configUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        

    }
    
    @IBAction func returnToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}

