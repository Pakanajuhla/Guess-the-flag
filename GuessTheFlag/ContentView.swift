//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Владислав on 09.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionCount = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0, green: 0.40, blue: 1), location: 0.3),
                .init(color: Color(red: 1, green: 1, blue: 0), location: 0.7)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.semibold))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.heavy))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Text("Score  \(userScore)")
                    .font(.title.bold())
                    .foregroundStyle(.primary)
                
                Spacer()
                
                    .alert(scoreTitle, isPresented: $showingScore) {
                        if showingFinalScore {
                            Button("Restart", action: restartGame)
                        } else {
                            Button("Continue", action: askQuestion)
                        }
                    } message: {
                        Text("Your score is \(userScore)")
                    }
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! Its the flag \(countries[number])"
            userScore -= 1
        }
        
        questionCount += 1
        
        if questionCount == 7 {
            showingFinalScore = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        questionCount = 0
        userScore = 0
        showingFinalScore = false
        askQuestion()
    }
}

#Preview {
    ContentView()
}
