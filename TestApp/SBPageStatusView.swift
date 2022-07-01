//
//  SBPageStatusView.swift
//  TestApp
//
//  Created by MACBOOK on 29/06/2022.
//

import SwiftUI

struct SBPageStatusView: View {
    
    var containingInList: SBListType
    
    var body: some View {
        Label {
            Text(containingInList.titleText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(containingInList.themeColor)
        } icon: {
            Image(containingInList.iconName)
                .frame(width: 20, height: 20)
        }
        .listRowBackground(containingInList.themeColor.opacity(0.1))
    }
}

