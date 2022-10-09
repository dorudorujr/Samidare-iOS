//
//  AdmobBannerView.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2022/10/08.
//

import SwiftUI
import GoogleMobileAds

struct AdmobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        if let id = adUnitID(key: "banner") {
            view.adUnitID = id
        }
        let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        view.rootViewController = windowScenes?.keyWindow?.rootViewController
        view.load(GADRequest())
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    private func adUnitID(key: String) -> String? {
        guard let adUnitIDs = Bundle.main.object(forInfoDictionaryKey: "AdUnitIDs") as? [String: String] else {
            return nil
        }
        return adUnitIDs[key]
    }
}
