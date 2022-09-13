//
//  SafariView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/09/11.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    private let url: URL
    typealias UIViewControllerType = SFSafariViewController
    
    init(url: URL) {
        self.url = url
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        return safariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "")!)
    }
}
