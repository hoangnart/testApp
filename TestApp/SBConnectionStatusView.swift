//
//  SBConnectionStatusView.swift
//  TestApp
//
//  Created by MACBOOK on 28/06/2022.
//

import SwiftUI
import Combine

struct SBConnectionStatusView: View {
    
    var model: SBConnectionStatusViewModel
    
    var body: some View {
        Label {
            Text(model.titleText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(model.labelTextColor)
        } icon: {
            ZStack(alignment: .center) {
                Color.gray.opacity(0.2)
                    .frame(width: 28, height: 28)
                    .cornerRadius(6)
                Image(model.iconName)
                    .frame(width: 20, height: 20)
            }
        }.listRowBackground(model.labelBackgroundColor)
    }
}

struct SBConnectionStatusViewModel {
    
    var item: SBItem
    
    var enableDismissOption: Bool {
        let check =
        (!item.isSecureConnection &&
        !isNormalPage &&
        isNotInBlackList)
        return check
    }
    
    var isNormalPage: Bool {
        item.pageType == .normalPage
    }
    
    var isNotInBlackList: Bool {
        return item.containedInList != .blackList
    }
    
    var titleText: String {
        item.isSecureConnection ? "Kết nối bảo mật":"Kết nối không bảo mật"
    }
    
    var iconName: String {
        if item.isSecureConnection {
            return "ccbr_sb_lock_icon"
        } else
        if isNormalPage {
            return "ccbr_sb_warning_icon"
        } else {
            return "ccbr_sb_list_type_blackList"
        }
    }
    
    var labelBackgroundColor: Color {
        if !item.isSecureConnection && !isNormalPage {
            return Color(hex: "#CC3648").opacity(0.1)
        }
        return .white
    }
    
    var labelTextColor: Color {
        if !item.isSecureConnection && !isNormalPage {
            return Color(hex: "#CC3648")
        }
        return .black
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
