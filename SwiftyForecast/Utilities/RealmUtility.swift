import Foundation
import RealmSwift

//private func wordsList() -> [(String, String)] {
//  return [("Cuaderno", "Notebook\nElla tiene muchos cuadernos."),
//          ("Casa", "House\nNuestra familia vive en una gran casa"),
//          ("Aprender", "To learn\nMe gusta aprender"),
//          ("Hacer", "To do\nEmpecé a hacer yoga"),
//          ("Tren", "Train\nEl viaje en tren es muy rápido"),
//          ("Playa", "Beach\n¡Vamos a la playa!"),
//          ("Pelota", "Ball\nSu regalo de cumpleaños es una nueva pelota")]
//}

struct RealmUtility {
  static func runIfNeeded() {
    guard ProcessInfo.processInfo.environment["SIMULATOR_UDID"] != "",
      ProcessInfo.processInfo.environment["UTILITY"] == "1" else {
        return
    }
    
    createBundledRealm()
    exit(0)
  }
  
  private static func createBundledRealm() {
    let configuration = Realm.Configuration(fileURL: try! PathFinder.inDocuments("tooling-bundledSets.realm"), objectTypes: [City.self])
    let newBundledSetsRealm = try! Realm(configuration: configuration)
    //
    //    let set1Cards = downloadableSets["Numbers"]!
    //                    .map { ($0[0], $0[1]) }
    //                    .map(FlashCard.init)
    //
    //    let set1 = FlashCardSet("Numbers", cards: set1Cards)
    //    let set2 = FlashCardSet("Colors", cards: [])
    //    let set3 = FlashCardSet("Greetings", cards: [])
    //
    //    try! newBundledSetsRealm.write {
    //      newBundledSetsRealm.deleteAll()
    //      newBundledSetsRealm.add([set1, set2, set3])
    //    }
    
    //    print("""
    //    *
    //    * Created: \(newBundledSetsRealm.configuration.fileURL!)
    //    *
    //    """)
    
    //    loadCities { result in
    //      switch result {
    //      case .success(let data):
    //        let config = Realm.Configuration(fileURL: try! PathFinder.inDocuments("bundledCities.realm"),
    //                                       deleteRealmIfMigrationNeeded: true,
    //                                       objectTypes: [RetailCategorySet.self, RetailCategory.self])
    //        let newRetailCategoryRealm = try! Realm(configuration: config)
    //
    //        try! newRetailCategoryRealm.write {
    //          newRetailCategoryRealm.deleteAll()
    //          newRetailCategoryRealm.add(RetailCategorySet(categories: data))
    //        }
    //
    //        debugPrint("""
    //                    *
    //                    * Created: \(newRetailCategoryRealm.configuration.fileURL!)")
    //                    *
    //                    """)
    //
    //      case .failure(let error):
    //        debugPrint(error.localizedDescription)
    //      }
    //    }
  }
  
}

// MARK: - Private - Load cities
private extension RealmUtility {
  
  static func loadForecast(completion: (Result<ForecastResponse, WebServiceError>) -> Void) {
    do {
      let data = try JSONFileLoader.loadFile(with: "forecastChicagoStub")
      let result = NetworkResponseParser<ForecastResponse>.parseJSON(data)
      completion(result)
    } catch {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error.localizedDescription)")
    }
  }
  
  static func loadCities(completion: (Result<[City], WebServiceError>) -> Void) {
        do {
          let data = try JSONFileLoader.loadFile(with: "cities")
          let result = NetworkResponseParser<[City]>.parseJSON(data)
          completion(result)
        } catch {
          debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error.localizedDescription)")
        }
  }
  
}
