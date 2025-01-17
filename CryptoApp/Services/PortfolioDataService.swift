import SwiftUI
import CoreData

class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                print("error downloading from CoreData \(error)")
            }
            self.getPortfolio()
        })
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
           savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio entities. \(error)")
        }
    }
    
    func add(coin: Coin, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to CoreData. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
