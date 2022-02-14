//
//  SwiftUI-View+referenceFrame.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/02/14.
//

import Foundation
import SwiftUI

extension SwiftUI.View {
    // iPhone12,13 Pro Max
    func referenceFrame() -> some View {
        self.frame(width: 428, height: 926)
    }
}
