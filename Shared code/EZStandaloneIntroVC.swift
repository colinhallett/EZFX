//
//  EZStandaloneTabBarVC.swift
//  EZFX
//
//  Created by Colin on 22/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class EZStandaloneIntroVC: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension UITextView {
    
    func updateTextFont() {
        if (self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero)) {
        return;
    }

    let textViewSize = self.frame.size;
    let fixedWidth = textViewSize.width;
    let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))

    var expectFont = self.font;
    if (expectSize.height > textViewSize.height) {
        while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
            expectFont = self.font!.withSize(self.font!.pointSize - 1)
            self.font = expectFont
        }
    }
    else {
        while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
            expectFont = self.font;
            self.font = self.font!.withSize(self.font!.pointSize + 1)
        }
        self.font = expectFont;
        }
    }
}


