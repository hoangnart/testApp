//
//  SafeBrowsingView.swift
//  TestApp
//
//  Created by MACBOOK on 23/06/2022.
//

import SwiftUI

struct SafeBrowsingView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var pageModel: SBModel

    var body: some View {
        NavigationView {
            List {
                Section {
                    Label {
                        if pageModel.shouldShowFullUrl {
                            Group {
                                Text(pageModel.firstPartURLString)
                                    .bold() +
                                Text(pageModel.lastPartURLString)
                            }
                            .foregroundColor(Color.black)
                        } else {
                            Text(pageModel.headerTitle)
                                .foregroundColor(Color.black)
                        }
                    } icon: {
                        ZStack(alignment: .center) {
                            Color.gray.opacity(0.2)
                                .frame(width: 28, height: 28)
                                .cornerRadius(6)
                            Image(pageModel.item.imageName)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .onTapGesture(perform: {
                    pageModel.shouldShowFullUrl.toggle()
                })
                
                //MARK: Page Status View
                if pageModel.shouldShowPageStatus {
                    Section {
                        SBPageStatusView(containingInList: pageModel.item.containedInList)
                            .listRowBackground(pageModel.item.containedInList.themeColor.opacity(0.1))
                    } footer: {
                        SBPageStatusFooterView(containingInList: pageModel.item.containedInList, didTapDismissText: {
                            pageModel.showingAlert = true
                        })
                    }
                }
                
                //MARK: Connection Status View
                if pageModel.shouldShowConnectionStatus {
                    let connectionStatusViewModel =
                        SBConnectionStatusViewModel(
                            item: pageModel.item
                        )
                    Section {
                        SBConnectionStatusView(
                            model: connectionStatusViewModel
                        )
                    } footer: {
                        let footerText = Text("Bạn không nên nhập bất cứ thông tin nhạy cảm nào trên trang web này (ví dụ: mật khẩu hoặc thẻ tín dụng), vì những kẻ tấn công có thể đánh cắp thông tin đó.")
                        if pageModel.item.isSecureConnection {
                            EmptyView()
                        } else {
                            if connectionStatusViewModel.enableDismissOption {
                                Group {
                                    footerText +
                                    Text(" Ẩn cảnh báo này")
                                        .foregroundColor(
                                            connectionStatusViewModel
                                                .labelTextColor)
                                }
                                .onTapGesture {
                                    pageModel.showingAlert = true
                                }
                            } else {
                                footerText
                            }
                        }
                    }
                }
                
                //MARK: Ads Block
                Section {
                    Toggle(isOn: $pageModel.isAdsBlockOn) {
                        Label {
                            Text("Chặn quảng cáo trang")
                        } icon: {
                            ZStack(alignment: .center) {
                                Color.gray.opacity(0.2)
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(6)
                                Image("ccbr_sb_ads_block_icon")
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                    
                    Text("Cài đặt chặn quảng cáo...")
                        .foregroundColor(Color.green)
                }
                .padding(6)
            }
            .labelStyle(CentreAlignedLabelStyle())
            .listStyle(.insetGrouped)
            .navigationTitle(pageModel.headerTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Text("Xong")
                                .foregroundColor(Color.green)
                                .font(Font.headline.bold())
                        }
                    )
            )
            .alert(isPresented: $pageModel.showingAlert) {
                Alert(
                    title: Text("Bạn có muốn ẩn cảnh báo trên trang này?"),
                    message: Text("Nếu bạn chọn ẩn cảnh báo, chúng tôi sẽ không hiện lại cảnh báo trên trang web này nữa."),
                    primaryButton: .destructive(Text("Ẩn cảnh báo trên trang này"), action: dismissPageStatus),
                    secondaryButton: .cancel(Text("Không ẩn cảnh báo")
                        .foregroundColor(Color.green)))
            }
        }
    }
    
    //TODO: dismissPageStatus
    func dismissPageStatus() {
        print("TODO: dismissPageStatus")
    }
}

struct SafeBrowsingView_Previews: PreviewProvider {
    static var previews: some View {
        SafeBrowsingView(pageModel: SBModel(item: sampleItem))
    }
}

let sampleItem = SBItem(
    url: "https://vnexpress.net/purchase/purchase/purchase/purchase/purchase/purchase",
    imageName: "ccbr_sb_example_vnexpress_icon",
    isSecureConnection: false,
    pageType: .paymentOrAuthenticationPage,
    containedInList: .blackList)


class SBModel: ObservableObject {
    
    @Published var shouldShowFullUrl: Bool
    @Published var showingAlert = false
    @Published var isAdsBlockOn = false //TODO: get this value from remote
    
    var item: SBItem
    
    var headerTitle: String {
        item.url.getDomainName() ?? ""
    }
    
    var firstPartURLString: String {
        return item.url.getFullDomainName() ?? ""
    }
    
    var lastPartURLString: String {
        var lastPartText = item.url
        if let range = lastPartText.range(of: firstPartURLString) {
            lastPartText.removeSubrange(range)
        }
        
        return lastPartText
    }
    
    var shouldShowPageStatus: Bool {
        //TODO: check if user have dimiss PageStatus warning for this DOMAIN
        
        if (item.pageType == .paymentOrAuthenticationPage &&
            item.containedInList == .whiteList &&
            item.isSecureConnection) ||
            item.containedInList == .blackList {
            return true
        }
        else { return false }
    }
    
    var shouldShowConnectionStatus: Bool {
        //TODO: check if user have dimiss ConnectionStatus warning for this DOMAIN
        
        if item.containedInList == .blackList && item.isSecureConnection {
            return false
        } else {
            return true
        }
    }
    
    init(item: SBItem) {
        self.item = item
        self.shouldShowFullUrl = item.pageType.defaultShowFullUrl
    }
}

struct CentreAlignedLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .alignmentGuide(.firstTextBaseline) {
                    $0[VerticalAlignment.center]
                }
        } icon: {
            configuration.icon
                .alignmentGuide(.firstTextBaseline) {
                    $0[VerticalAlignment.center]
                }
        }
    }
}
