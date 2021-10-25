import SwiftUI

public struct SwipingCarousel<Pages: View>: View {
    @Binding var currentIndex: Int
    @Binding var transitionState: TransitionState
    @GestureState private var translation: CGFloat = 0
    
    let pages: Pages
    let pageCount: Int

    public init(
        pageCount: Int,
        currentIndex: Binding<Int>,
        transitionState: Binding<TransitionState>,
        @ViewBuilder pages: () -> Pages
    ) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self._transitionState = transitionState
        self.pages = pages()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                pages
                    .frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.easeInOut(duration: 0.3))
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onChanged { _ in
                    transitionState = .swiping
                }.onEnded { value in
                    transitionState = .ended
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
}

struct SwipingCarousel_Previews: PreviewProvider {
    static var previews: some View {
        SwipingCarousel<Text>(
            pageCount: 1,
            currentIndex: .constant(0),
            transitionState: .constant(.ended),
            pages: { Text("Hellow world") }
            
        )
    }
}
