//
//  MailView.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2022/10/17.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    private let osVersion = UIDevice.current.systemVersion
    private let deviceName = UIDevice.current.name
    
    @Binding var isShowing: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> UIViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setSubject(L10n.Mail.title)
        controller.setToRecipients(["iossamidare@gmail.com"])
        //controller.setMessageBody(L10n.Mail.body(appVersion, osVersion, deviceName), isHTML: false)
        return controller
    }
    
    func makeCoordinator() -> MailView.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
        let parent: MailView
        
        init(parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            self.parent.isShowing = false
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}
