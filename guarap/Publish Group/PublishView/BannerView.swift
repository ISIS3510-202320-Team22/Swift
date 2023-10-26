//
//  BannerView.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 26-10-2023.
//

import SwiftUI

struct BannerView: View {
    let text: String
    let color: Color

    @State private var isShowing = true

    var body: some View {
        if isShowing {
            return AnyView(Text(text)
                .foregroundColor(.white)
                .padding()
                .background(color)
                .frame(maxWidth: .infinity)
                .opacity(1)
                .onAppear {
                    withAnimation {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}
