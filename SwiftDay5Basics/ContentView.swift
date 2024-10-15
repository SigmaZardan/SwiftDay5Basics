//
//  ContentView.swift
//  SwiftDay5Basics
//
//  Created by Bibek Bhujel on 15/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            PivotRectangleView()
        }
    }
}


// explicit animation
// telling swift ui to animate some portions of the ui

struct BasicAnimations: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                // do something
                // here increase the animation amount
                animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount)
            .blur(radius: (animationAmount - 1) * 3)
            .animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true),
                value: animationAmount
            )
            // repeatForever as well
            
        }
       Spacer()
        Button("Another Button") {
            
        }
        .padding(50)
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .overlay(
            Circle()
                .stroke(.blue)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: animationAmount
                )
        )
        .onAppear {
            // it will make a blink effect on the blue button
//            animationAmount = 2
        }
        Spacer()
    }
}
// implicit animation as well
struct AnimationAnotherWay: View {
    @State private var animationAmount = 1.0
    var body: some View {
        VStack {
            // .animation() will change when value changes meaning the view changes
            Stepper("Scale amount", value: $animationAmount.animation(
                .easeInOut(duration: 1)
                       .repeatCount(3, autoreverses: true)
            )
                , in: 1...10)

                       Spacer()

                       Button("Tap Me") {
                           animationAmount += 1
                       }
                       .padding(40)
                       .background(.red)
                       .foregroundStyle(.white)
                       .clipShape(.circle)
                       .scaleEffect(animationAmount)
        }
    }
    
}



struct ExplicitAnimation: View {
    @State private var animationAmount = 0.0
    var body: some View {
        Button("Tap Me Again") {
            withAnimation(.spring(duration:1, bounce:0.5)){
                animationAmount += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .rotation3DEffect(.degrees(animationAmount), axis: (x:0, y:1, z:0))
    }
}


// animation stack
struct AnimationStack: View {
    @State private var enabled = false
    var body: some View {
        VStack {
            
            
            Button("Tap Me") {
                enabled.toggle()
            }
            .padding(50)
            .background(enabled ? .blue : .red)
            .animation(.default, value: enabled)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
            .animation(.spring(duration:1, bounce:0.6), value: enabled)
        }
       // making the color change instant
        // only animating the shapes part
        Button("Tap Me") {
            enabled.toggle()
        }
        .padding(50)
        .background(enabled ? .blue : .red)
        .animation(nil, value: enabled)
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
        .animation(.spring(duration:1, bounce:0.6), value: enabled)
    }
}


struct AnimatingGestures: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                   .frame(width: 300, height: 200)
                   .clipShape(.rect(cornerRadius: 10))
                   .offset(dragAmount)
                   .gesture(
                    DragGesture()
                        .onChanged {
                            dragAmount = $0.translation
                        }
                        .onEnded {
                            _ in
                            withAnimation(.bouncy) {
                                dragAmount = .zero
                            }
                        }
                   )
                   
    }
}


// view transitions and animations

struct ViewTransitionsAndAnimations: View {
    @State private var isShowingRed = false
    var body: some View {
        Button("Tap") {
           // do something
            withAnimation {
                isShowingRed.toggle()
            }
        }
        if isShowingRed {
            Rectangle()
                .fill(.red)
                .frame(width: 200, height: 200)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
        }
    }
}

// building custom transitions using view modifiers


struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading), identity: CornerRotateModifier(amount:0, anchor: .topLeading))
    }
}


struct PivotRectangleView: View {
    @State private var isShowingRed = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
