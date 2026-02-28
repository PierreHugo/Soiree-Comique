//
//  WheelView.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI

struct WheelView: View {

    @StateObject private var vm = WheelViewModel()
    
    @Environment(\.colorScheme) private var scheme
    
    @State private var editingKind: WheelKind? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundPrimary(for: scheme)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {

                        VStack(spacing: 10) {
                            Text("🎡  Roues comiques")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundStyle(AppColors.brandPrimary)

                            Text("Tourne et laisse le hasard décider !")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(AppColors.textSecondary(for: scheme))
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 10)

                        ForEach(vm.wheels) { wheel in
                            WheelCardView(
                                title: wheel.id.title,
                                options: wheel.options,
                                onEdit: {
                                    editingKind = wheel.id
                                }                            )
                            .padding(.horizontal, 14)
                        }

                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $editingKind) { kind in
            EditWheelOptionsSheet(vm: vm, kind: kind)
                .presentationDetents([.medium, .large])
        }
    }
}
