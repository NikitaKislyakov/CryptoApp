import SwiftUI
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var coinDescription: String? = nil
    @Published var webSiteURL: String? = nil
    @Published var redditURL: String? = nil


    
    @Published var coin: Coin
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.webSiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        let overviewArray: [Statistic] = createOverviewArray(coin: coin)
        let additionalArray: [Statistic] = createAdditionalArray(coinDetail: coinDetail, coin: coin)
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coin: Coin) -> [Statistic] {
        var overviewArray: [Statistic] = []
        
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        overviewArray.append(contentsOf: [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ])
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetail: CoinDetail?, coin: Coin) -> [Statistic] {
        var additionalArray: [Statistic] = []
        
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapCHangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : String(blockTime)
        let blockStat = Statistic(title: "Block time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        additionalArray.append(contentsOf: [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapCHangeStat,
            blockStat,
            hashingStat
        ])
        
        return additionalArray
    }
    
}
