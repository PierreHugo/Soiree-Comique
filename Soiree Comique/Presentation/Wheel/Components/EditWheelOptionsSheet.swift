//
//  EditWheelOptionsSheet.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI

struct EditWheelOptionsSheet: View {

    @ObservedObject var vm: WheelViewModel
    let kind: WheelKind

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    @State private var newOptionTitle: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundPrimary(for: scheme).ignoresSafeArea()

                VStack(spacing: 12) {
                    // Add
                    HStack(spacing: 10) {
                        TextField("Ajouter un choix…", text: $newOptionTitle)
                            .textFieldStyle(.roundedBorder)

                        Button("Ajouter") {
                            vm.addOption(to: kind, title: newOptionTitle)
                            newOptionTitle = ""
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppColors.brandPrimary)
                        .disabled(newOptionTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // List
                    List {
                        Section("Choix") {
                            ForEach(vm.options(for: kind)) { option in
                                HStack(spacing: 12) {
                                    TextField(
                                        "",
                                        text: Binding(
                                            get: { option.title },
                                            set: { vm.renameOption(in: kind, optionId: option.id, newTitle: $0) }
                                        )
                                    )
                                    .textInputAutocapitalization(.sentences)
                                    .disableAutocorrection(true)

                                    Spacer()

                                    Button {
                                        vm.removeOption(from: kind, optionId: option.id)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .buttonStyle(.borderless)
                                    .foregroundStyle(vm.canRemoveOption(from: kind) ? Color.red : AppColors.textSecondary(for: scheme))
                                    .disabled(!vm.canRemoveOption(from: kind))
                                }
                                .listRowBackground(AppColors.backgroundSecondary(for: scheme).opacity(0.55))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Modifier les choix")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Réinitialiser") {
                        vm.reset(kind: kind)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("OK") { dismiss() }
                }
            }
        }
    }
}
