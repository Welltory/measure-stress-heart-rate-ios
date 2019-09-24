//
//  File.swift
//  WelltoryDDSDemo
//
//  Created by Anton Rogachevskyi on 18/09/2019.
//  Copyright © 2019 Welltory LTD. All rights reserved.
//

import UIKit

struct DDSResult {
    
    enum Color: String {
        case green = "green"
        case yellow = "yellow"
        case red = "red"
        case unknown = "unknown"
        
        func toUIColor() -> UIColor {
            switch self {
            case .green:
                return UIColor(red: 0.01, green: 0.8, blue: 0.2, alpha: 1)
            case .yellow:
                return .yellow
            case .red:
                return .red
            default:
                return .gray
            }
        }
        
    }
    
    var stress: Float
    var energy: Float
    var productivity: Float
    var rmssd: Float
    var sdnn: Float
    var power: Float
    var token: String?
    var stressColor: Color
    var energyColor: Color
    var productivityColor: Color
    
    init(parameters: [AnyHashable: Any]) {
        self.stress = Float(parameters["stress"] as? String ?? "") ?? 0
        self.energy = Float(parameters["energy"] as? String ?? "") ?? 0
        self.rmssd  = Float(parameters["rmssd"] as? String ?? "") ?? 0
        self.sdnn   = Float(parameters["sdnn"] as? String ?? "") ?? 0
        self.power  = Float(parameters["power"] as? String ?? "")  ?? 0
        self.productivity   = Float(parameters["productivity"] as? String ?? "") ?? 0
        
        self.token   = parameters["token"] as? String
        self.stressColor = DDSResult.Color(rawValue: parameters["stress_c"] as? String ?? "unknown") ?? .unknown
        self.energyColor = DDSResult.Color(rawValue: parameters["energy_c"] as? String ?? "unknown") ?? .unknown
        self.productivityColor   = DDSResult.Color(rawValue: parameters["productivity_c"] as? String ?? "unknown") ?? .unknown
    }
}
