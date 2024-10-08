import SwiftUI

// URL: "https://api.coingecko.com/api/v3/global"

// JSON Response
/*
 {
   "date": {
     "active_cryptocurrencies": 13690,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1046,
     "total_market_cap": {
       "btc": 39003738.0847159
     },
     "total_volume": {
       "btc": 993675.225562481,
     },
     "market_cap_percentage": {
       "btc": 50.4465263233584
     },
     "market_cap_change_percentage_24h_usd": 1.72179506060272,
     "updated_at": 1712512855
   }
 }
 */

struct GlobalData: Codable {
    let data: MarketData
}

struct MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
