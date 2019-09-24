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
        result = DDSResult(parameters: parameters)
        performSegue(withIdentifier: "ShowResult", sender: self)
    }

    ///MARK User actions
    @IBAction func actionRequestMeasurement(_ sender: Any) {
        guard let url = URL(string: String(format: "%@?source=%@&callback=%@",
                                           DDSConfig.measurementLink,
                                           DDSConfig.appName,
                                           DDSConfig.callbackUrl)) else { return }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultViewController = segue.destination as? ResultViewController else { return }
        resultViewController.result = result
    }
    
}
