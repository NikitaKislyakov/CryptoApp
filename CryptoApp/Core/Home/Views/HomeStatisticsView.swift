import SwiftUI

struct HomeStatisticsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                ForEach(viewModel.statistics) { stat in
                    StatisticView(statistic: stat)
                        .frame(width: geo.size.width / 3)
                }
            }
            .frame(width: geo.size.width,
                   alignment: showPortfolio ? .trailing : .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
    }
}

#Preview {
    HomeStatisticsView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.shared.homeViewModel)
}
