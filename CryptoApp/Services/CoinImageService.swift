import SwiftUI
import Combine

final class CoinImageService {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.shared
    private let folderForCoinImages = "Coin_images"
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderForCoinImages) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.imageStringURL) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard
                    let self = self,
                    let strongImage = returnedImage
                    else { return }
                self.image = strongImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: strongImage, imageName: imageName, folderName: folderForCoinImages)
            })
    }
}
