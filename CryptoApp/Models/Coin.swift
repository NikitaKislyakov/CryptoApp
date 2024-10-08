import SwiftUI

//MARK: API Info
/*
 url: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h

 Json response:
{
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
    "current_price": 60055,
    "market_cap": 1183893407051,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 1259065620123,
    "total_volume": 46078845482,
    "high_24h": 62460,
    "low_24h": 58060,
    "price_change_24h": -2385.568790411293,
    "price_change_percentage_24h": -3.82053,
    "market_cap_change_24h": -48457580054.427,
    "market_cap_change_percentage_24h": -3.93212,
    "circulating_supply": 19746200,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 73738,
    "ath_change_percentage": -18.6656,
    "ath_date": "2024-03-14T07:10:36.635Z",
    "atl": 67.81,
    "atl_change_percentage": 88345.94578,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2024-08-28T11:53:34.763Z",
    "sparkline_in_7d": {
      "price": [
      ]

    },
    "price_change_percentage_24h_in_currency": -3.820530566403631
  }
 */

struct Coin: Identifiable, Codable, Hashable {
    
    let id, symbol, name: String
    let imageStringURL: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let currentHoldings: Double?
    let priceChangePercentage24hInCurrency: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, ath, atl
        case imageStringURL = "image"
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24hInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHolding(amount: Double) -> Coin {
        return Coin(
            id: id,
            symbol: symbol,
            name: name,
            imageStringURL: imageStringURL,
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: marketCapRank,
            fullyDilutedValuation: fullyDilutedValuation,
            totalVolume: totalVolume,
            high24H: high24H,
            low24H: low24H,
            priceChange24H: priceChange24H,
            priceChangePercentage24H: priceChangePercentage24H,
            marketCapChange24H: marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            maxSupply: maxSupply,
            ath: ath,
            athChangePercentage: ath,
            athDate: athDate,
            atl: atl,
            atlChangePercentage: athChangePercentage,
            atlDate: atlDate,
            lastUpdated: lastUpdated,
            sparklineIn7D: sparklineIn7D,
            currentHoldings: amount, 
            priceChangePercentage24hInCurrency: priceChangePercentage24hInCurrency
        )
    }
    
    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id + symbol + name + imageStringURL)
    }
    
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id == rhs.id
    }
}


struct SparklineIn7D: Codable {
    let price: [Double]?
}

