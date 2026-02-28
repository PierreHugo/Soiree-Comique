import SwiftUI

struct MainTabView: View {

    enum Tab {
        case wheel
        case questions
        case chooser
        case settings
    }

    @State private var selectedTab: Tab = .wheel   // ← défaut = Wheel

    var body: some View {
        TabView(selection: $selectedTab) {

            WheelView()
                .tabItem {
                    Label("Wheel", systemImage: "circle.grid.cross")
                }
                .tag(Tab.wheel)

            QuestionsView()
                .tabItem {
                    Label("Questions", systemImage: "questionmark.circle")
                }
                .tag(Tab.questions)

            ChooserView()
                .tabItem {
                    Label("Chooser", systemImage: "person.2")
                }
                .tag(Tab.chooser)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .tint(AppColors.brandPrimary)
        .background(AppColors.backgroundPrimary)
    }
}

#Preview {
    MainTabView()
}
