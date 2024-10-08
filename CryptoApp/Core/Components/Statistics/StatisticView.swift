import SwiftUI

struct StatisticView: View {
    let statistic: Statistic

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (statistic.percentageChange ?? 0) >= 0 ? 0 : 180))

                Text(statistic.percentageChange?.asPercentString() ?? "")
                .bold()
                .font(.caption)
            }
            .foregroundStyle(
                (statistic.percentageChange ?? 0) >= 0 ?
                 Color.theme.greenColor : Color.theme.redColor)
            .opacity(statistic.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    StatisticView(statistic: DeveloperPreview.shared.statistic1)
}
