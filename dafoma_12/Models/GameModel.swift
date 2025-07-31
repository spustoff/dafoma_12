//
//  GameModel.swift
//  Kangwon Game Color
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI
import Foundation

class GameModel: ObservableObject {
    @Published var currentScore: Int = 0
    @Published var highScore: Int = 0
    @Published var gameState: GameState = .notStarted
    @Published var timeRemaining: Double = 30.0
    @Published var currentLevel: Int = 1
    @Published var targetColor: Color = AppColors.gameColors.randomElement()!
    @Published var colorOptions: [Color] = []
    @Published var streak: Int = 0
    @Published var soundEnabled: Bool = true
    @Published var difficulty: Difficulty = .normal
    
    private var timer: Timer?
    private let gameTime: Double = 30.0
    
    enum GameState {
        case notStarted
        case playing
        case paused
        case gameOver
    }
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case normal = "Normal"
        case hard = "Hard"
        
        var timeMultiplier: Double {
            switch self {
            case .easy: return 1.5
            case .normal: return 1.0
            case .hard: return 0.7
            }
        }
        
        var optionsCount: Int {
            switch self {
            case .easy: return 3
            case .normal: return 4
            case .hard: return 6
            }
        }
    }
    
    init() {
        loadHighScore()
        loadSettings()
    }
    
    func startGame() {
        gameState = .playing
        currentScore = 0
        streak = 0
        currentLevel = 1
        timeRemaining = gameTime * difficulty.timeMultiplier
        generateNewChallenge()
        startTimer()
    }
    
    func pauseGame() {
        gameState = .paused
        timer?.invalidate()
    }
    
    func resumeGame() {
        gameState = .playing
        startTimer()
    }
    
    func endGame() {
        gameState = .gameOver
        timer?.invalidate()
        
        if currentScore > highScore {
            highScore = currentScore
            saveHighScore()
        }
    }
    
    func selectColor(_ color: Color) {
        guard gameState == .playing else { return }
        
        if colorsMatch(color, targetColor) {
            // Correct answer
            let points = calculatePoints()
            currentScore += points
            streak += 1
            
            if streak % 5 == 0 {
                currentLevel += 1
            }
            
            generateNewChallenge()
        } else {
            // Wrong answer
            streak = 0
            endGame()
        }
    }
    
    private func generateNewChallenge() {
        targetColor = AppColors.gameColors.randomElement()!
        
        var options = [targetColor]
        let otherColors = AppColors.gameColors.filter { !colorsMatch($0, targetColor) }
        
        for _ in 1..<difficulty.optionsCount {
            if let randomColor = otherColors.randomElement() {
                options.append(randomColor)
            }
        }
        
        colorOptions = options.shuffled()
    }
    
    private func colorsMatch(_ color1: Color, _ color2: Color) -> Bool {
        // Simple color comparison - in a real app you might want more sophisticated comparison
        return color1.description == color2.description
    }
    
    private func calculatePoints() -> Int {
        let basePoints = 10
        let levelBonus = currentLevel * 2
        let streakBonus = streak * 5
        return basePoints + levelBonus + streakBonus
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeRemaining -= 0.1
            
            if self.timeRemaining <= 0 {
                self.endGame()
            }
        }
    }
    
    // MARK: - Persistence
    
    private func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: "highScore")
    }
    
    private func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: "highScore")
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        UserDefaults.standard.set(difficulty.rawValue, forKey: "difficulty")
    }
    
    private func loadSettings() {
        soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        if let difficultyString = UserDefaults.standard.string(forKey: "difficulty"),
           let savedDifficulty = Difficulty(rawValue: difficultyString) {
            difficulty = savedDifficulty
        }
    }
    
    func updateSettings(soundEnabled: Bool, difficulty: Difficulty) {
        self.soundEnabled = soundEnabled
        self.difficulty = difficulty
        saveSettings()
    }
} 