import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                leftColumn
                Spacer()
                if showHoldingsColumn {
                    centerColumn
                }
                rightColumn
                    .frame(width: geometry.size.width / 3, alignment: .trailing)
            }
            .font(.subheadline)
        }
    }
}

#Preview {
        CoinRowView(
            coin: DeveloperPreview.shared.coin,
            showHoldingsColumn: true
        )
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .padding(.horizontal, 15)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
             Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.greenColor : Color.theme.redColor
                )
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
}
