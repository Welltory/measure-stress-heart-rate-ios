//
//  ResultViewController.swift
//  WelltoryDDSDemo
//
//  Created by Anton Rogachevskyi on 26/08/2019.
//  Copyright © 2019 Welltory LTD. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var stressLevelLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var productivityLabel: UILabel!
    @IBOutlet weak var rmssdLabel: UILabel!
    @IBOutlet weak var sdnnLabel: UILabel!
        
    var result: DDSResult?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .MeasurementDone, object: nil, queue: .main, using: { (notification) in
            guard let parameters = notification.userInfo else { return }
            self.updateMeasurementView(parameters: parameters)
        })

        updateData()
    }
    
    func updateData() {
        guard let result = result else { return }
        
        stressLevelLabel.text   = String(format: "%.0f%@", result.stress * 100, "%")
        energyLabel.text        = String(format: "%.0f%@", result.energy * 100, "%")
        productivityLabel.text  = String(format: "%.0f%@", result.productivity * 100, "%")
        rmssdLabel.text         = String(format: "%.0f%@", result.rmssd, " ms")
        sdnnLabel.text          = String(format: "%.0f%@", result.sdnn, " ms")
    }
    
    private func updateMeasurementView(parameters: [AnyHashable: Any]) {
        guard let stress    = Float(parameters["stress"] as? String ?? "")
            , let energy    = Float(parameters["energy"] as? String ?? "")
            , let prod      = Float(parameters["productivity"] as? String ?? "")
            , let rmssd     = Float(parameters["rmssd"] as? String ?? "")
            , let sdnn      = Float(parameters["sdnn"] as? String ?? "")
            , let power     = Float(parameters["power"] as? String ?? "")
            , let quality   = Float(parameters["measurement_quality"] as? String ?? "")
            else {
                return
        }
        
        result = DDSResult(stress: stress, energy: energy, productivity: prod, rmssd: rmssd, sdnn: sdnn, power: power, quality: quality)
        updateData()
    }
    
    ///MARK User actions
    @IBAction func actionRequestMeasurement(_ sender: Any) {
        guard let url = URL(string: String(format: "%@?source=%@&callback=%@",
                                           DDSCofig.measurementLink,
                                           DDSCofig.appName,
                                           DDSCofig.callbackUrl)) else { return }
        
        UIApplication.shared.open(url, options: [:])
    }

}

