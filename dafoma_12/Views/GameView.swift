//
//  GameView.swift
//  Kangwon Game Color
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var showSettings = false
    @State private var showGameOver = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with score and timer
                    HeaderView()
                        .environmentObject(gameModel)
                    
                    // Main game content
                    if gameModel.gameState == .notStarted {
                        WelcomeView()
                            .environmentObject(gameModel)
                    } else if gameModel.gameState == .playing || gameModel.gameState == .paused {
                        ActiveGameView()
                            .environmentObject(gameModel)
                    } else if gameModel.gameState == .gameOver {
                        GameOverView()
                            .environmentObject(gameModel)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(gameModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HeaderView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var showSettings = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Score: \(gameModel.currentScore)")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(AppColors.primary)
                
                Text("Best: \(gameModel.highScore)")
                    .font(.caption)
                    .foregroundColor(AppColors.secondary.opacity(0.7))
            }
            
            Spacer()
            
            if gameModel.gameState == .playing || gameModel.gameState == .paused {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Level \(gameModel.currentLevel)")
                        .font(.headline)
                        .foregroundColor(AppColors.secondary)
                    
                    Text(String(format: "%.1fs", gameModel.timeRemaining))
                        .font(.title2.weight(.bold))
                        .foregroundColor(gameModel.timeRemaining <= 5 ? .red : AppColors.primary)
                }
            }
            
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.secondary)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(gameModel)
        }
    }
}

struct WelcomeView: View {
    @EnvironmentObject var gameModel: GameModel
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primary)
                
                Text("Kangwon Game Color")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(AppColors.secondary)
                
                Text("Match colors as fast as you can!")
                    .font(.title3)
                    .foregroundColor(AppColors.secondary.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button("Start Game") {
                    gameModel.startGame()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Text("Difficulty: \(gameModel.difficulty.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondary.opacity(0.7))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
    }
}

struct ActiveGameView: View {
    @EnvironmentObject var gameModel: GameModel
    
    var body: some View {
        VStack(spacing: 40) {
            // Target color display
            VStack(spacing: 16) {
                Text("Find this color:")
                    .font(.title2)
                    .foregroundColor(AppColors.secondary)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(gameModel.targetColor)
                    .frame(width: 120, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.secondary, lineWidth: 3)
                    )
                    .shadow(color: gameModel.targetColor.opacity(0.6), radius: 10)
            }
            .padding(.top, 40)
            
            // Streak indicator
            if gameModel.streak > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("Streak: \(gameModel.streak)")
                        .font(.headline)
                        .foregroundColor(AppColors.primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppColors.secondary.opacity(0.1))
                .cornerRadius(12)
            }
            
            Spacer()
            
            // Color options grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(0..<gameModel.colorOptions.count, id: \.self) { index in
                    ColorOptionButton(color: gameModel.colorOptions[index])
                        .environmentObject(gameModel)
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            // Pause button
            if gameModel.gameState == .playing {
                Button("Pause") {
                    gameModel.pauseGame()
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, 40)
            } else if gameModel.gameState == .paused {
                VStack(spacing: 16) {
                    Text("Game Paused")
                        .font(.title2)
                        .foregroundColor(AppColors.secondary)
                    
                    Button("Resume") {
                        gameModel.resumeGame()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct ColorOptionButton: View {
    @EnvironmentObject var gameModel: GameModel
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            gameModel.selectColor(color)
        }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.secondary.opacity(0.3), lineWidth: 2)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct GameOverView: View {
    @EnvironmentObject var gameModel: GameModel
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: gameModel.currentScore > gameModel.highScore ? "crown.fill" : "gamecontroller.fill")
                    .font(.system(size: 80))
                    .foregroundColor(gameModel.currentScore > gameModel.highScore ? AppColors.primary : AppColors.secondary)
                
                Text(gameModel.currentScore > gameModel.highScore ? "New High Score!" : "Game Over")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(AppColors.secondary)
                
                VStack(spacing: 12) {
                    Text("Score: \(gameModel.currentScore)")
                        .font(.title)
                        .foregroundColor(AppColors.primary)
                    
                    Text("Level Reached: \(gameModel.currentLevel)")
                        .font(.title3)
                        .foregroundColor(AppColors.secondary.opacity(0.8))
                    
                    if gameModel.streak > 0 {
                        Text("Best Streak: \(gameModel.streak)")
                            .font(.title3)
                            .foregroundColor(AppColors.secondary.opacity(0.8))
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button("Play Again") {
                    gameModel.startGame()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Main Menu") {
                    gameModel.gameState = .notStarted
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    GameView()
        .environmentObject(GameModel())
} 