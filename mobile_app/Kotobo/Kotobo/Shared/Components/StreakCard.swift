//
//  StreakCard.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import SwiftUI


struct StreakCard: View {
    let icon: String
    let value: String
    let title: String
    var iconColor: Color = .orange

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(iconColor)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.gray)
        }
        .frame(width: 120, height: 120)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: .black.opacity(0.2),
            radius: 5,
            x: 0,
            y: 4
        )
    }
}


#Preview {
    StreakCard(
        icon: "flame.fill",
        value: "12",
        title: "Day Streak",
        iconColor: .red
    )
}
