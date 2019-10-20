//
//  ViewController.swift
//  EZFX
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    @IBOutlet weak var xyPadView: XYPadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        xyPadView.setupPadArea()
        print ("layout")
    }


}

