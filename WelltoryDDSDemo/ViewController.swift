//
//  ViewController.swift
//  WelltoryDDSDemo
//
//  Created by Anton Rogachevskyi on 26/08/2019.
//  Copyright © 2019 Welltory LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var result: DDSResult?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .MeasurementDone, object: nil, queue: .main, using: { (notification) in
            guard let parameters = notification.userInfo else { return }
            self.updateMeasurementView(parameters: parameters)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        performSegue(withIdentifier: "ShowResult", sender: self)
    }

    ///MARK User actions
    @IBAction func actionRequestMeasurement(_ sender: Any) {
        guard let url = URL(string: String(format: "%@?source=%@&callback=%@",
                                           DDSCofig.measurementLink,
                                           DDSCofig.appName,
                                           DDSCofig.callbackUrl)) else { return }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    
    
    ///MARK Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultViewController = segue.destination as? ResultViewController else { return }
        resultViewController.result = result
    }
    
}


extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
