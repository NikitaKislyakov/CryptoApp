//
//  DetailView.swift
//  CryptoApp
//
//  Created by Никита Кисляков on 26.09.2024.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionView
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                }
                .padding()
            }
        }
        .background(Color.theme.background)
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: DeveloperPreview.shared.coin)
    }
}

extension DetailView {
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionView: some View {
        ZStack {
            if let description = viewModel.coinDescription,
               !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Hide" : "Read more...")
                            .font(.caption)
                            .bold()
                            .padding(.vertical, 1)
                    })
                    .tint(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
        }
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/,
                  content: {
            ForEach(viewModel.overviewStatistics) { stat in
                    StatisticView(statistic: stat)
            }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/,
                  content: {
            ForEach(viewModel.additionalStatistics) { stat in
                    StatisticView(statistic: stat)
            }
        })
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = viewModel.webSiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = viewModel.redditURL,
               let redditURL = URL(string: redditString) {
                Link("Reddit", destination: redditURL)
            }
        }
        .tint(Color.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
            .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
}
