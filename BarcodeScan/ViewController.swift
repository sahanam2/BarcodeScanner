//
//  ViewController.swift
//  BarcodeScan
//
//  Created by Manjesh.Sahana on 2023/09/06.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scanBarButton: UIButton!
    @IBOutlet weak var scanTextField: UITextField!
    let scannerViewController = ScannerViewController()
  
  override func viewDidLoad() {
        super.viewDidLoad()
      scannerViewController.delegate = self

    }
  
        
    @IBAction func onTap(_ sender: UIButton) {
        self.navigationController?.pushViewController(scannerViewController, animated: true)
    }
}


extension ViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        scanTextField.text = text
    }
}
