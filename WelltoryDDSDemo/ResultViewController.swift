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
    @IBOutlet weak var stressHolderView: UIView!
    
    var result: DDSResult?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Config arrow anchor
        arrowImageView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        
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
        stressHolderView.backgroundColor = result.stressColor.toUIColor()
        rotateArrow(result.stress)
    }
    
    private func updateMeasurementView(parameters: [AnyHashable: Any]) {
        result = DDSResult(parameters: parameters)                
        updateData()
    }
    
    //MARK: User actions
    @IBAction func actionRequestMeasurement(_ sender: Any) {
        guard let url = URL(string: String(format: "%@?source=%@&callback=%@",
                                           DDSConfig.measurementLink,
                                           DDSConfig.appName,
                                           DDSConfig.callbackUrl)) else { return }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    @IBAction func actionShare(_ sender: Any) {
        guard let result = result
            , let token = result.token
            , let url = URL(string: String(format: "https://app.welltory.com/share-measurement?token=%@", token))
        else { return }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    private func rotateArrow(_ stress: Float) {
        UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseInOut, animations: {
            self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(stress * Float.pi))
        }, completion: nil)
    }

}

