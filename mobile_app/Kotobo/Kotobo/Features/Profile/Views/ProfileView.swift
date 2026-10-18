//
//  ProfileView.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack(alignment: .top) {

            // Header image
            Image("profile_background")
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea(edges: .top)

            // White panel
            VStack {
                header
                    .padding(.top, 30)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 650)
            .background {
                UnevenRoundedRectangle(
                    topLeadingRadius: 30,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 30
                )
                .fill(Color.white)
            }
            .padding(.top, 230)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

private var header: some View {
    VStack {
        //info section
        HStack {
            //profile image
            Circle()
                .fill(.red)
                .frame(width: 80, height: 80)
                .padding(.trailing, 10)
            
            //name and level info
            VStack(alignment: .leading) {
                Text("Govind Rajput")
                    .font(.system(size: 24))
                    .bold()
                Text("Beginner Level 3")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            //settings button
            Button {
                print("Settings")
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.black)
            }
            .padding(.leading, 80)
        }
        .padding(.bottom, 20)
        
        //streak section
        
        HStack(spacing: 16) {
            StreakCard(
                icon: "flame.fill",
                value: "12",
                title: "Day Streak",
                iconColor: .orange
            )
            
            StreakCard(
                icon: "star.fill",
                value: "320",
                title: "Total XP",
                iconColor: .yellow
            )
            
            StreakCard(
                icon: "crown.fill",
                value: "8",
                title: "Badges",
                iconColor: .blue
            )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ProfileView()
}
