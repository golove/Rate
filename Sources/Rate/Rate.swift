// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 15,*)
public struct Rate:View{
	@Binding var rating:Int
	@State private var isThrottling: Bool = false
	var count:Int

	var size:FontSize
	
	var icon:IconType
	
	var color:Color
	
	var height:CGFloat{
		CGFloat(count) * (calculte.itemSize + calculte.spacing)
	}
	
	var CapsuleHeight:CGFloat{
		if rating > 1 {
			height / CGFloat(count) * CGFloat(rating)
		}else {
			height / CGFloat(count)
		}
			
	}
	
	struct CalcultePropertizes{
		var fontSize:Font
		var itemSize:CGFloat
		var spacing:CGFloat
	}
	
	var calculte:CalcultePropertizes{
		switch size {
			case .huge:
				CalcultePropertizes(fontSize: .largeTitle, itemSize: 34, spacing: 14)
			case .large:
				CalcultePropertizes(fontSize: .title, itemSize: 28, spacing: 10)
			case .medium:
				CalcultePropertizes(fontSize: .title2, itemSize: 22, spacing: 8)
			case .regular:
				CalcultePropertizes(fontSize: .headline, itemSize: 18, spacing: 6)
			case .small:
				CalcultePropertizes(fontSize: .footnote, itemSize: 13, spacing: 4)
			case .tink:
				CalcultePropertizes(fontSize: .caption2, itemSize: 11, spacing: 4)
			
		}
	}
	

	
	public enum FontSize{
		case huge
		case large
		case medium
		case regular
		case small
		case tink
	}
	
	public enum IconType:String {
		case star = "star"
		case heart = "heart"
	}
	func icon(_ n:Int,_ m:Int) -> String{
		return n == 0 ? m == n ? icon.rawValue + ".slash.fill"  : icon.rawValue + ".slash" : m >= n ? icon.rawValue + ".fill" : icon.rawValue
	}
	public init(rating:Binding<Int>,count: Int = 6, size: FontSize = .small ,icon:IconType = .heart,color:Color = .pink) {
		self._rating = rating
			self.count = count
			self.size = size
			self.icon = icon
			self.color = color
		}
	
	public var body: some View{
		ZStack{
			Capsule()
				.fill(.white.opacity(0.3))
				.frame(width: calculte.itemSize + calculte.spacing,height: CapsuleHeight)
				
				.frame(maxHeight: height,alignment: .top)
				.offset(y:rating > 0 ? calculte.itemSize + calculte.spacing : 0)
				
			VStack(spacing: calculte.spacing){
				ForEach(Array(0..<count),id: \.self){n in
					Image(systemName: icon(n,rating))
						.resizable()
						.scaledToFit()
						.frame(width: calculte.itemSize,height: calculte.itemSize)
						
						.foregroundColor(rating >= n ? color.opacity(0.7) : .gray.opacity(0.7))
						.onTapGesture {
							withAnimation(.default){
								rating = n
								
							}
						}
						
				}
			}
			
			
		}
		.padding(calculte.spacing / 2)
		.background(.ultraThinMaterial)
		.cornerRadius(calculte.itemSize)
		
		.gesture(
						DragGesture()
							.onChanged { value in
								// 手指滑动时触发的事件
								throttleHandleDrag(location: value.location)
							}
							.onEnded { value in
								// 手指滑动结束时重置节流状态
								isThrottling = false
							}
						
					)
		
			
	}
	
	private func hapticFeedback() {
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.impactOccurred()
		}
		
		private func throttleHandleDrag(location: CGPoint) {
			// 如果当前处于节流状态，则不执行
			if isThrottling {
				return
			}
			
			// 否则，执行handleDrag函数并开始节流
			handleDrag(location: location)
			
			// 设置节流状态为true，并在150毫秒后重置为false
			isThrottling = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
				self.isThrottling = false
			}
		}
		
		private func handleDrag( location: CGPoint) {
			// 检查是否需要根据拖动位置更新 rating
			var newIndex:Int{
				let n = Int(location.y / (height / CGFloat(count)))
				if n >= 0 && n <= count - 1{
					return n
				}else if n < 0{
					return 0
				}else if n > count - 1{
					return count - 1
				}
				return 0
			}
				   if newIndex != rating {
					   withAnimation(.default){
						hapticFeedback()
						   rating = newIndex
						  
					   }
				   }


				
			
		}
	

	
}

@available(iOS 18,*)
#Preview {
	@Previewable @State var rating:Int = 3
	Rate(rating:$rating,size: .large)
}
