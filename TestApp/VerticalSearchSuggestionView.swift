//
//  ContentView.swift
//  TestApp
//
//  Created by MACBOOK on 18/05/2022.
//

import SwiftUI
import Combine
import Foundation

fileprivate class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data: Data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(withUrl url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

fileprivate class PaddedImageView: UIImageView {
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4)
    }
}

fileprivate struct VSSImageView: UIViewRepresentable {

    var imageView: PaddedImageView = PaddedImageView(frame: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
    @State var image:UIImage
    @State var urlString: String
    
    init(urlString: String, image: UIImage) {
        self.urlString = urlString
        self.image = image
    }
    
    func makeUIView(context: Context) -> UIImageView {
        imageView.image = UIImage(named: "Icon")
        imageView.contentMode = .scaleAspectFit
//        imageView.padding(4)
        imageView.clipsToBounds = true
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }
    
}

fileprivate struct CCBRImageView: View {
    
    @ObservedObject var imageLoader: ImageLoader
    
    @State var image:UIImage = UIImage()
    
    var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        self.imageLoader = ImageLoader(withUrl: URL(string: urlString)!)
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
                .shadow(color: .red, radius: 5)
            VSSImageView(urlString: urlString, image: image)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .cornerRadius(16)
                .padding(4)
                .clipped()
//                .onReceive(imageLoader.didChange) { data in
//                    guard let image = UIImage(data: data) else { return }
//                    self.image = image
//                }
        }
    }
}

struct VSSItem {
    var id: Int
    let title, imageUrl: String
}

struct VSSItemView: View {
    let item: VSSItem
    @State private var showText = true
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 8)
                .aspectRatio(contentMode: .fill)
//            CCBRImageView(urlString: item.imageUrl)
            Button("ACB") {
                showText.toggle()
            }
            Spacer()
                .frame(height: 8)
                .aspectRatio(contentMode: .fill)
            if showText {
                Text(item.title)
                    .font(.subheadline)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
        }
    }
}

struct CCBRVerticalSearchSuggestionView: View {
    
    let listItems:[VSSItem] = [
        VSSItem(id: 0, title: "aaaaaaaaaaaaaaaaasdadasdasdasdassfasdasdasd", imageUrl: "https://picsum.photos/200"),
        VSSItem(id: 1, title: "aaaaaaaaaaaaaaaaaasdadasdasdasdassfasdasdasd", imageUrl: "https://picsum.photos/200"),
        VSSItem(id: 2, title: "aaaaaaaaaaaaaaaaaasdadasdasdasdassfasdasdasd", imageUrl: "https://picsum.photos/200"),
        VSSItem(id: 3, title: "aaaaaaaaaaaaaaaaaasdadasdasdasdassfasdasdasd", imageUrl: "https://picsum.photos/200"),
        VSSItem(id: 4, title: "aaaaaaaaaaaaaaaaaasdadasdasdasdassfasdasdasd", imageUrl: "https://picsum.photos/200"),
        VSSItem(id: 5, title: "aaaaaaaaaaaaaaaaaasdadasdasdasdassfasdasdasd", imageUrl: "https://picsum.photos/200")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(listItems, id: \.id) { item in
                    VSSItemView(item: item)
                        .frame(width: 78,height: 104, alignment: .top)
                        .onTapGesture {
                            //Todo
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CCBRVerticalSearchSuggestionView()
    }
}


