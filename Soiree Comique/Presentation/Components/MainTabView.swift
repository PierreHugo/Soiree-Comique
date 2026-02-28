import SwiftUI

struct MainTabView: View {

    @Environment(\.colorScheme) private var colorScheme
    
    enum Tab {
        case wheel
        case questions
        case chooser
        case settings
    }

    @State private var selectedTab: Tab = .chooser   // ← défaut = Wheel

    var body: some View {
        TabView(selection: $selectedTab) {

            ChooserView()
                .tabItem {
                    Label("Chooser", systemImage: "person.2")
                }
                .tag(Tab.chooser)

            WheelView()
                .tabItem {
                    Label("Roues", systemImage: "circle.grid.cross")
                }
                .tag(Tab.wheel)

            QuestionsView()
                .tabItem {
                    Label("Questions", systemImage: "questionmark.circle")
                }
                .tag(Tab.questions)

            SettingsView()
                .tabItem {
                    Label("Réglages", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .tint(AppColors.brandPrimary)
        .background(AppColors.backgroundPrimary(for: colorScheme))
    }
}

#Preview {
    MainTabView()
}
