//
//  GameOverView.swift
//  G2
//
//  Created by Pietro Carnevale on 08/12/23.
//

import SwiftUI

struct GameOverView: View {
    
    var score: Int
    
    var body: some View {
        ZStack {
            Image("background")
            VStack{
                Spacer()
                Text("YOUR SCORE IS \(score)!")
                    .bold()
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                Spacer()
                HStack{
                    Image("background")
                        .resizable()
                        .frame(width: 200, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    GameOverView(score: 10)
}
