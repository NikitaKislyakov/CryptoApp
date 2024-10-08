import SwiftUI
import Combine

final class MarketDataService {
    @Published var marketData: MarketData?
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {

        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedData in
                guard let self = self else { return }
                self.marketData = returnedData.data
                self.marketDataSubscription?.cancel()
            })
    }
}
