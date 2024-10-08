import SwiftUI

struct InfoView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let vkURL = URL(string: "https://vk.com")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com")!
    let telegramURL = URL(string: "https://t.me/nikitakislyakov")!
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                List {
                    coinGeckoSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    developerSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    applicationSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
            }
            .tint(Color.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XmarkButton()
                }
            }
        }
    }
}

#Preview {
    InfoView()
}

extension InfoView {
    private var coinGeckoSection: some View {
        Section("Coingecko") {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .scaledToFit()
                Text("All data comes from free API from CoinGecko!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko!", destination: coinGeckoURL)
            
        }
    }
    
    private var developerSection: some View {
        Section("Developer") {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
                Text("This app was developed by Nikita Kislyakov from Moscow. I'm mastering my skills now, so CoreData, FileManager, MVVM architecture, Combine and other technologies used here are new to me!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Find me on telegram!", destination: telegramURL)
            Link("Or VK...", destination: vkURL)
            
        }
    }
    
    private var applicationSection: some View {
        Section("Application") {
            Link("Terms of service", destination: defaultURL)
            Link("Privacy policy", destination: defaultURL)
            Link("Company website", destination: defaultURL)
            Link("Learn more", destination: defaultURL)
        }
    }
}
