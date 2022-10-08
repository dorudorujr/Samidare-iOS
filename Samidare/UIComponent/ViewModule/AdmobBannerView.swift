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
        #if DEBUG
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        view.adUnitID = "ca-app-pub-8080856618058856/1855575051"
        #endif
        let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        view.rootViewController = windowScenes?.keyWindow?.rootViewController
        view.load(GADRequest())
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
