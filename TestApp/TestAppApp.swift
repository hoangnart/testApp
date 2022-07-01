//
//  TestAppApp.swift
//  TestApp
//
//  Created by MACBOOK on 18/05/2022.
//

import SwiftUI

@main
struct TestAppApp: App {
    @State private var presented = true
    var body: some Scene {
        WindowGroup {
            UIHostingController(rootView: EmptyView())
                .rootView.sheet(isPresented: $presented) {
                    SafeBrowsingView(pageModel: SBModel(item: sampleItem))
                }
        }
    }
}
