//
//  LottieView.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 06/02/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let url : URL
    let speed: CGFloat
    
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        
        DotLottieFile.loadedFrom(url: url) { result in
            switch result {
            case .success(let success):
                animationView.loadAnimation(from: success)
                animationView.loopMode  = .loop
                animationView.animationSpeed = speed
                animationView.play()

            case .failure(let failure):
                print(failure)
            }
        }
    }
}
