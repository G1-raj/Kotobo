import SwiftUI

@main struct MyApp: App {
    
    @State private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(container)
        }
    }
}
