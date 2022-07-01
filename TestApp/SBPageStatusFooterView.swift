//
//  SBPageStatusFooterView.swift
//  TestApp
//
//  Created by MACBOOK on 29/06/2022.
//

import SwiftUI

struct SBPageStatusFooterView: View {
    
    var containingInList: SBListType
    var didTapDismissText: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            if containingInList == .whiteList {
                Text(containingInList.descriptionText)
                Label {
                    Text("CỐC CỐC ĐÃ XÁC THỰC")
                        .foregroundColor(containingInList.themeColor)
                        .fontWeight(.semibold)
                } icon: {
                    Image("guardIcon")
                        .frame(width: 14, height: 14)
                }
                .padding(6)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            containingInList.themeColor.opacity(0.3),
                            lineWidth: 2)
                }
            }
            else {
                Group {
                    Text(containingInList.descriptionText) +
                    Text(" Ẩn cảnh báo này")
                        .foregroundColor(containingInList.themeColor)
                }
                .onTapGesture(perform: didTapDismissText)
            }
        }
    }
}
