//
//  DDSConfig.swift
//  WelltoryDDSDemo
//
//  Created by Anton Rogachevskyi on 26/08/2019.
//  Copyright © 2019 Welltory LTD. All rights reserved.
//

import Foundation

struct DDSConfig {
    
    private static let firstMeasurementLink     = "https://welltory.onelink.me/2180424117/bf497b9"
    private static let recurrentMeasurementLink = "https://welltory.com/action/dds/measurement"
    
    
    public static let appName                   = "DemoApp"
    public static let callbackUrl               = "ddsdemo://Measurement"
    public static var measurementLink: String {
        return UserDefaults.standard.isFirstMeasurement ? firstMeasurementLink : recurrentMeasurementLink
    }
}
