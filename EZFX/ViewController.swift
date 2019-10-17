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

    override func viewDidLoad() {
        super.viewDidLoad()
        print ("here")
        let noise = AKOscillator(waveform: AKTable(.square), frequency: 500, amplitude: 1.0, detuningOffset: 0, detuningMultiplier: 0)
        let chorus = EZSpacer(noise)
        
        AudioKit.output = noise
        try! AudioKit.start()
        noise.start()
       // chorus.start()
    }


}

