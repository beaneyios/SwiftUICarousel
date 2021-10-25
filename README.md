# UnflowCarousel

This package allows the consumer to pass in a series of SwiftUI views, that can then be skipped/swiped along.

It takes a `currentIndex` binding that is managed both by the carousel itself (in the event of a swipe) and by the consumer app (in the event of a button tap). I didn't want to tightly couple button taps with advancements in the carousel because the user might want an individual page to do something different when the button is tapped.

It also takes a `transitionState` binding - this allows the user to tell the pages to change their state to a "transitioning" state i.e. to animate their subviews appropriately depending on the type of transition (button tap or swipe). Failing to maintain a @State object that contains this binding (and instead passing in a `.constant` value) will just mean the subviews are not animated on swipe/jump. 

Credit to https://swiftwithmajid.com/2019/12/25/building-pager-view-in-swiftui/ for the swipe-to-page idea. Previously I just had buttons (the jumping mechanism you already see).
