//
//  OnboardingView.swift
//  Kangwon Game Color
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var currentPage = 0
    @State private var showMainGame = false
    
    let onboardingPages = [
        OnboardingPage(
            title: "Welcome to\nKangwon Game Color",
            description: "Test your reflexes and color recognition skills in this fast-paced matching game",
            systemImage: "paintbrush.pointed.fill"
        ),
        OnboardingPage(
            title: "Match Colors\nQuickly",
            description: "Find the matching color from the options before time runs out",
            systemImage: "eyedropper.halffull"
        ),
        OnboardingPage(
            title: "Beat Your\nHigh Score",
            description: "Compete with yourself and track your progress as you improve",
            systemImage: "trophy.fill"
        ),
        OnboardingPage(
            title: "Ready to\nPlay?",
            description: "Let's start your color matching journey!",
            systemImage: "play.fill"
        )
    ]
    
    var body: some View {
        if showMainGame {
            GameView()
                .environmentObject(gameModel)
        } else {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            OnboardingPageView(page: onboardingPages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    VStack(spacing: 30) {
                        // Page indicator
                        HStack(spacing: 8) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? AppColors.primary : AppColors.secondary.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Action buttons
                        VStack(spacing: 16) {
                            if currentPage == onboardingPages.count - 1 {
                                Button("Start Game") {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showMainGame = true
                                    }
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            } else {
                                Button("Next") {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage += 1
                                    }
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                            
                            if currentPage > 0 {
                                Button("Skip") {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showMainGame = true
                                    }
                                }
                                .buttonStyle(SecondaryButtonStyle())
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(AppColors.primary)
                .padding(.top, 60)
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(AppColors.secondary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.title3)
                    .foregroundColor(AppColors.secondary.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2.weight(.semibold))
            .foregroundColor(AppColors.background)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.primary)
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.weight(.medium))
            .foregroundColor(AppColors.secondary.opacity(0.7))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(AppColors.secondary.opacity(0.1))
            .cornerRadius(14)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(GameModel())
} 