//
//  AdMob.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2022/10/09.
//

import GoogleMobileAds
import AppTrackingTransparency

struct AdMobConfig {
    static func checkTrackingAuthorizationStatus() {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
            AdMobConfig.requestTrackingAuthorization()
        case .restricted:
            AdMobConfig.updateTrackingAuthorizationStatus()
        case .denied:
            AdMobConfig.updateTrackingAuthorizationStatus()
        case .authorized:
            AdMobConfig.updateTrackingAuthorizationStatus()
        @unknown default:
            fatalError()
        }
    }
    
    private static func requestTrackingAuthorization() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .notDetermined: break
                case .restricted, .denied, .authorized:
                    AdMobConfig.updateTrackingAuthorizationStatus()
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    private static func updateTrackingAuthorizationStatus() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}
