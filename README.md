<img width="96" alt="Screenshot 2024-06-25 at 15 39 57" src="https://github.com/golove/Rate/assets/61925349/4582f8d6-266f-4b3d-8c8b-208b2cd185a7">
<img width="75" alt="Screenshot 2024-06-25 at 15 40 06" src="https://github.com/golove/Rate/assets/61925349/f9cbe53a-03c6-4dd1-b7e6-f5fbe8a8d089">
<img width="87" alt="Screenshot 2024-06-25 at 15 40 22" src="https://github.com/golove/Rate/assets/61925349/7631740e-a032-4f81-94fa-729a0e1cd6ce">


# Rate

Rate is a simple and beautiful rating control written in SwiftUI, which supports touch gestures and can be customized with different colors and sizes.

## Features

- 支持自定义count。
- 支持自定义icon。
- 支持自定义color。
- 支持自定义size。
- 支持点击和滑动事件。
- 支持震动反馈

## Usage

To use Rate, simply import it into your SwiftUI project and create an instance of the `RateView` struct.

```swift
import Rate

struct ContentView: View {
    @State private var rating = 0

    var body: some View {
			// default propotize count: Int = 6, size: FontSize = .regular ,icon:IconType = .heart,color:Color = .pink 
			Rate(rating: $rating)
			
        }
    }
}
```
    
## Customization

Rate supports customization of colors, sizes, labels, and more. To customize a RateView, simply pass in the desired values as parameters when creating the instance.

```swift
	Rate(rating: $rating, count: 5, size: .large, color: .pink)
```

## Installation

Rate is available through [Swift Package Manager](https://swift.org/package-manager/). To install it, simply add Rate to your `Package.swift` file and run `swift package update`.

```swift
dependencies: [
                  .package(url: "https://github.com/golove/Rate.git", from: "1.0.0")
            ]
`
