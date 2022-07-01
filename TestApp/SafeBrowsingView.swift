//
//  SafeBrowsingView.swift
//  TestApp
//
//  Created by MACBOOK on 23/06/2022.
//

import SwiftUI

struct SafeBrowsingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isOn = false
    @State private var showingAlert = false
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
                            self.showingAlert = true
                        })
                    }
                }
                
                //MARK: Connection Status View
                if pageModel.shouldShowConnectionStatus {
                    Section {
                        SBConnectionStatusView(
                            model: SBConnectionStatusViewModel(
                                pageType: pageModel.item.pageType,
                                isSecureConnection: pageModel.item.isSecureConnection))
                    } footer: {
                        if pageModel.item.isSecureConnection {
                            EmptyView()
                        } else {
                            Text("Bạn không nên nhập bất cứ thông tin nhạy cảm nào trên trang web này (ví dụ: mật khẩu hoặc thẻ tín dụng), vì những kẻ tấn công có thể đánh cắp thông tin đó.")
                        }
                    }
                }
                
                //MARK: Ads Block
                Section {
                    Toggle(isOn: $isOn) {
                        Label {
                            Text("Chặn quảng cáo trang")
                        } icon: {
                            ZStack(alignment: .center) {
                                Color.gray.opacity(0.2)
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(6)
                                Image("adblockIcon")
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
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Bạn có muốn ẩn cảnh báo trên trang này?"),
                    message: Text("Nếu bạn chọn ẩn cảnh báo, chúng tôi sẽ không hiện lại cảnh báo trên trang web này nữa."),
                    primaryButton: .destructive(Text("Ẩn cảnh báo trên trang này")),
                    secondaryButton: .cancel(Text("Không ẩn cảnh báo")
                        .foregroundColor(Color.green)))
                
                //dismissButton: .default(Text("Không ẩn cảnh báo").foregroundColor(Color.green))
            }
        }
    }
}

struct SafeBrowsingView_Previews: PreviewProvider {
    static var previews: some View {
        SafeBrowsingView(pageModel: SBModel(item: sampleItem))
    }
}

let sampleItem = SBItem(
    url: "https://vnexpress.net/purchase/purchase/purchase/purchase/purchase/purchase",
    imageName: "vnexpressIcon",
    isSecureConnection: true,
    pageType: .paymentOrAuthenticationPage,
    containedInList: .blackList)




class SBModel: ObservableObject {
    var item: SBItem
    @Published var shouldShowFullUrl: Bool
    
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
        if (item.pageType == .paymentOrAuthenticationPage &&
            item.containedInList == .whiteList &&
            item.isSecureConnection) ||
            item.containedInList == .blackList {
            return true
        }
        else { return false }
    }
    
    var shouldShowConnectionStatus: Bool {
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
