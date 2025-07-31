//
//  SettingsView.swift
//  Kangwon Game Color
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameModel: GameModel
    @Environment(\.presentationMode) var presentationMode
    @State private var tempSoundEnabled: Bool = true
    @State private var tempDifficulty: GameModel.Difficulty = .normal
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "gearshape.2.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primary)
                            
                            Text("Settings")
                                .font(.largeTitle.weight(.bold))
                                .foregroundColor(AppColors.secondary)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 24) {
                            // Sound Settings
                            SettingsCard {
                                VStack(spacing: 16) {
                                    HStack {
                                        Image(systemName: "speaker.wave.3.fill")
                                            .font(.title2)
                                            .foregroundColor(AppColors.primary)
                                        
                                        Text("Sound Effects")
                                            .font(.headline)
                                            .foregroundColor(AppColors.secondary)
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: $tempSoundEnabled)
                                            .tint(AppColors.primary)
                                    }
                                    
                                    Text("Enable sound effects during gameplay")
                                        .font(.caption)
                                        .foregroundColor(AppColors.secondary.opacity(0.7))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            // Difficulty Settings
                            SettingsCard {
                                VStack(spacing: 16) {
                                    HStack {
                                        Image(systemName: "dial.high.fill")
                                            .font(.title2)
                                            .foregroundColor(AppColors.primary)
                                        
                                        Text("Difficulty")
                                            .font(.headline)
                                            .foregroundColor(AppColors.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    VStack(spacing: 12) {
                                        ForEach(GameModel.Difficulty.allCases, id: \.self) { difficulty in
                                            DifficultyOption(
                                                difficulty: difficulty,
                                                isSelected: tempDifficulty == difficulty
                                            ) {
                                                tempDifficulty = difficulty
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Statistics
                            SettingsCard {
                                VStack(spacing: 16) {
                                    HStack {
                                        Image(systemName: "chart.bar.fill")
                                            .font(.title2)
                                            .foregroundColor(AppColors.primary)
                                        
                                        Text("Statistics")
                                            .font(.headline)
                                            .foregroundColor(AppColors.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    VStack(spacing: 8) {
                                        StatRow(title: "High Score", value: "\(gameModel.highScore)")
                                        StatRow(title: "Games Played", value: "\(UserDefaults.standard.integer(forKey: "gamesPlayed"))")
                                        StatRow(title: "Current Difficulty", value: gameModel.difficulty.rawValue)
                                    }
                                }
                            }
                            
                            // About
                            SettingsCard {
                                VStack(spacing: 16) {
                                    HStack {
                                        Image(systemName: "info.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(AppColors.primary)
                                        
                                        Text("About")
                                            .font(.headline)
                                            .foregroundColor(AppColors.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Kangwon Game Color")
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundColor(AppColors.secondary)
                                        
                                        Text("Version 1.0.0")
                                            .font(.caption)
                                            .foregroundColor(AppColors.secondary.opacity(0.7))
                                        
                                        Text("A fast-paced color matching game that tests your reflexes and color recognition skills.")
                                            .font(.caption)
                                            .foregroundColor(AppColors.secondary.opacity(0.7))
                                            .padding(.top, 4)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        gameModel.updateSettings(soundEnabled: tempSoundEnabled, difficulty: tempDifficulty)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                    .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        .onAppear {
            tempSoundEnabled = gameModel.soundEnabled
            tempDifficulty = gameModel.difficulty
        }
    }
}

struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding(20)
        .background(AppColors.secondary.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.secondary.opacity(0.1), lineWidth: 1)
        )
    }
}

struct DifficultyOption: View {
    let difficulty: GameModel.Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.rawValue)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(AppColors.secondary)
                    
                    Text(difficultyDescription)
                        .font(.caption2)
                        .foregroundColor(AppColors.secondary.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.secondary.opacity(0.3))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? AppColors.primary.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
    }
    
    private var difficultyDescription: String {
        switch difficulty {
        case .easy:
            return "More time, 3 color options"
        case .normal:
            return "Standard time, 4 color options"
        case .hard:
            return "Less time, 6 color options"
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(AppColors.secondary.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundColor(AppColors.primary)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(GameModel())
} 