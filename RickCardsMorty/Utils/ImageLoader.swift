//
//  ImageLoader.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 24/09/21.
//  This code was based on this tutorial https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
//
import Foundation
import Combine
import UIKit
import SwiftUI

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private var cancelable: AnyCancellable?
    private var url: URL?
    private var cache: ImageCache?
    private(set) var isLoading = false
    // Taking care of the thread
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(stringUrl: String, cache: ImageCache? = nil) {
        self.url = URL(string: stringUrl)
        self.cache = cache
    }
    
    func load() {
        
        if let url = url {
            
            guard !isLoading else { return }
            
            if let image = cache?[url] { // Getting image from cache
                self.image = image
                return
            }
            
            cancelable = URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: Self.imageProcessingQueue)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
            // Handling the states
                .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                              receiveOutput: { [weak self] in self?.cache($0) },
                              receiveCompletion: { [weak self] _ in self?.onFinish() },
                              receiveCancel: { [weak self] in self?.onFinish() })
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in self?.image = $0 }
        }
    }
    
    func cancel() {
        cancelable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        if let url = url {
            image.map { cache?[url] = $0 }
        }
    }
}

struct RemoteImage<ImagePlaceholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let imagePlaceholder: ImagePlaceholder
    private let image: (UIImage) -> Image
    // This make the image customisable
    init(
        stringURL: String,
        @ViewBuilder imagePlaceholder: @escaping () -> ImagePlaceholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.imagePlaceholder = imagePlaceholder()
        // To wrap the value in a StateObject Object
        _loader = StateObject(wrappedValue: ImageLoader(stringUrl: stringURL, cache: Environment(\.imageCache).wrappedValue))
        self.image = image
    }
    
    var body: some View {
        content.onAppear {
            loader.load()
        }
    }
    
    private var content: some View {
        Group {
            if let loadImage =  loader.image {
                image(loadImage)
            } else {
                imagePlaceholder
            }
        }
    }
    
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}
