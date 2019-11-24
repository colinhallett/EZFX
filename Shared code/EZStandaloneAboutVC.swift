//
//  EZStandaloneAboutVC.swift
//  EZFX
//
//  Created by Colin on 22/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class EZStandaloneAboutVC: UIViewController {
    @IBOutlet weak var textField: UITextView!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDisplayName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            textField.text =
            
            "\(appDisplayName)\n\nCheck out other EZFX and more: \n\nwww.kailin.co.uk \n\nwith thanks to AudioKit\n\n©2019 Colin Hallett"
        }

        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func rotated() {
        textField.updateTextFont()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.updateTextFont()
    }
       
}
