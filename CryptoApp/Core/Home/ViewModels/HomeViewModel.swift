//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Никита Кисляков on 12.09.2024.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var statistics: [Statistic] = []
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allcoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
                        
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapMarketDataToStatistics)
            .sink(receiveValue: { [weak self] arrayOfStats in
                self?.statistics = arrayOfStats
            })
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        let filteredCoins = filterCoins(text: text, coins: coins)
        let sortedAndFilteredCoins = sortCoins(sortOption: sortOption, coins: filteredCoins)
        return sortedAndFilteredCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter {
            $0.name.lowercased().contains(lowercasedText) ||
            $0.symbol.lowercased().contains(lowercasedText) ||
            $0.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sortOption: SortOption, coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .rank, .holdings:
            return coins.sorted(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            return coins.sorted(by: { $1.rank < $0.rank })
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return coins.sorted(by: { $1.currentPrice > $0.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(coinModels: [Coin], portfolioEntities: [PortfolioEntity]) -> [Coin] {
        coinModels
            .compactMap { coin -> Coin? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHolding(amount: entity.amount)
        }
    }
    
    private func mapMarketDataToStatistics(_ marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else { return stats }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = 
            portfolioCoins
                .map { $0.currentHoldingsValue }
                .reduce(0, { $0 + $1 })

        let previousValue =
            portfolioCoins
            .map { coin in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0.0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        stats.append(
            contentsOf: [
                marketCap,
                volume,
                btcDominance,
                portfolio
            ])
        return stats
    }
}
