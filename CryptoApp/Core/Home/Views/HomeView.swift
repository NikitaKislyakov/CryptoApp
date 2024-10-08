import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView = false
    @State private var showInfoView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(viewModel)
                })
            
            VStack {
                homeHeader
                
                HomeStatisticsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            portfolioCoinsList
                        }
                    }
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showInfoView, content: {
                InfoView()
            })
            .navigationDestination(for: Coin.self) { coin in
                DetailView(coin: coin)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden)
    }
    .environmentObject(DeveloperPreview.shared.homeViewModel)
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: false)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showInfoView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .animation(.none)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                NavigationLink(value: coin) {
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .listRowInsets(
                            .init(
                                top: 10,
                                leading: 0,
                                bottom: 10,
                                trailing: 10
                            )
                        )
                }
                .listRowBackground(Color.theme.background)
            }
        }
        .refreshable {
            viewModel.reloadData()
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 0,
                            bottom: 10,
                            trailing: 10
                        )
                    )
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioEmptyText: some View {
        Text("You haven't added any coins to your portfolio yet! Click the + button to start.")
            .font(.callout)
            .foregroundStyle(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private var columnTitles: some View {
        GeometryReader { geo in
            HStack {
                HStack(spacing: 4) {
                    Text("Coin")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
                }
                .padding(.leading)
                .onTapGesture {
                    withAnimation {
                        viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                    }
                }
                Spacer()
                if showPortfolio {
                    HStack(spacing: 4) {
                        Text("Holdings")
                        Image(systemName: "chevron.down")
                            .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                            .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                        }
                    }
                }
                
                HStack(spacing: 4) {
                    Text("Price")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
                }
                .padding(.trailing)
                .frame(width: geo.size.width / 3, alignment: .trailing)
                .onTapGesture {
                    withAnimation {
                        viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 15)
        .padding(.horizontal)
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
}
