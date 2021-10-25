//
//  File.swift
//  
//
//  Created by Matt Beaney on 25/10/2021.
//

import SwiftUI

public struct PageView: View {
    
    @Binding var transitionState: TransitionState
    
    public let index: Int
    public let buttonTapped: (Int) -> Void
    
    private let viewModel: PageViewModel
    
    public init(
        transitionState: Binding<TransitionState>,
        index: Int,
        viewModel: PageViewModel,
        buttonTapped: @escaping (Int) -> Void
    ) {
        self._transitionState = transitionState
        self.index = index
        self.viewModel = viewModel
        self.buttonTapped = buttonTapped
    }
    
    public var body: some View {
        ZStack {
            viewModel.backgroundColor
                .edgesIgnoringSafeArea(.all)
            backgroundImage
            VStack(spacing: 16.0) {
                Spacer()
                titleText
                bodyText
                Rectangle()
                    .frame(width: 10.0, height: 12.0, alignment: .center)
                    .opacity(0.0)
                button
            }
            .padding()
        }
    }
    
    var backgroundImage: some View {
        viewModel.backgroundImage
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .opacity(pageOpacity)
    }
    
    var titleText: some View {
        Text(viewModel.title)
            .font(.title)
            .fontWeight(.heavy)
            .offset(x: 0, y: labelOffset)
            .opacity(pageOpacity)
            .animation(.easeInOut(duration: 0.3))
    }
    
    var bodyText: some View {
        Text(viewModel.summary)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .offset(x: 0, y: labelOffset)
            .opacity(pageOpacity)
            .animation(.easeInOut(duration: 0.3))
    }
    
    var button: some View {
        Button {
            buttonTapped(index)
        } label: {
            VStack {
                buttonText
                    .fontWeight(.bold)
                    .padding(12.0)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .opacity(buttonOpacity)
            .animation(.easeInOut(duration: 0.3))
            .cornerRadius(16.0)
        }
        .disabled(buttonDisabled)
    }
    
    var buttonText: Text {
        if #available(iOS 14.0, *) {
            return Text(viewModel.buttonTitle)
                .font(.title3)
        } else {
            return Text(viewModel.buttonTitle)
                .font(.system(size: 16.0))
        }
    }
}

extension PageView {
    var pageOpacity: CGFloat {
        transitionState.pageOpacity
    }
    
    var buttonOpacity: CGFloat {
        transitionState.buttonOpacity
    }
    
    var buttonDisabled: Bool {
        transitionState.buttonDisabled
    }
    
    var labelOffset: CGFloat {
        transitionState.labelOffset
    }
}

struct PageView_Previews: PreviewProvider {
    struct PreviewPageViewModel: PageViewModel {
        let backgroundImage = Image("background-1")
        let backgroundColor = Color("background-color-1")
        let title = "Introducing audio rooms"
        let summary = "We all know video calls can get tiring, so we've introduced a new form of room, just for audio. Share stories, music, or just listen to ambient sound while working from home."
        let buttonTitle = "Next"
    }
    
    static var previews: some View {
        PageView(
            transitionState: .constant(.ended),
            index: 0,
            viewModel: PreviewPageViewModel()
        ) { index in
            print(index)
        }
    }
}

fileprivate extension TransitionState {
    var pageOpacity: CGFloat {
        switch self {
        case .swiping: return 0.5
        case .jumping: return 0.0
        case .ended: return 1.0
        }
    }
    
    var buttonOpacity: CGFloat {
        switch self {
        case .swiping, .jumping: return 0.5
        case .ended: return 1.0
        }
    }
    
    var buttonDisabled: Bool {
        switch self {
        case .swiping, .jumping: return true
        default: return false
        }
    }
    
    var labelOffset: CGFloat {
        switch self {
        case .jumping: return -15.0
        default: return 0.0
        }
    }
}

