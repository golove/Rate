// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct RatelView: View {
	@State private var selectIndex = 0
	@State private var isThrottling: Bool = false
	public enum IconType: String {
			case star = "star"
			case heart = "heart"
		}
	var count:Int
	var spacing:CGFloat
	var icons:IconType
	var complect:(Int)->Void
	
	func icon(n:Int,m:Int) -> String{
		return n == 0 ? m == n ? icons.rawValue + ".slash.fill"  : icons.rawValue + ".slash" : m >= n ? icons.rawValue + ".fill" : icons.rawValue
	}
	
	// 使用计算属性来计算高度和间距项高度
	   private var height: CGFloat {
		   let totalItemHeight = CGFloat(30 * count)
		   let totalSpacing = spacing * CGFloat(count + 1)
		   return totalItemHeight + totalSpacing
	   }
	   
	   private var offsetYbyIndex: CGFloat {
		   selectIndex > 0 ? CGFloat((30 + spacing) / 2) * CGFloat(selectIndex) : 0
		
	   }
		
	private var capsuleHeight:CGFloat{
		if selectIndex > 0 {
			let a = CGFloat(30 * selectIndex)
			let b = CGFloat(selectIndex - 1) * spacing
			return a + b
//			return 30
		}else {
			return 30
		}
	}
	
	private var heightArray:[CGFloat]{
		var array:[CGFloat] = Array(repeating: 0, count: count)
		for n in 0..<count{
			array[n] = (height / CGFloat(count)) * CGFloat(n)
		}
		return array
	}
	
	private var capculeOffsetY:CGFloat{
		if selectIndex > 0 {
			return spacing * 1.5 - (height / 2) + 30
		}else{
			return spacing - (height / 2) + 15
		}
	}
	   
	public init( count: Int, spacing: CGFloat, icons: IconType, complect: @escaping (Int) -> Void) {
		self.count = count
		self.spacing = spacing
		self.icons = icons
		self.complect = complect
	}
	
	public var body: some View {
		ZStack{
			
			Capsule()
				.fill(Color.teal.opacity(0.3))
				.frame(width: 30, height: capsuleHeight )
				.offset(y: capculeOffsetY)
				.offset(y: offsetYbyIndex)
			
			VStack(spacing: spacing){
				Group{
					ForEach(Array(0..<count), id: \.self){n in
						Image(systemName:icon(n:n,m:selectIndex))
						.frame(width: 30,height: 30)
						.onTapGesture(perform: {
							withAnimation(.default){
								selectIndex = n
								hapticFeedback()
							}
						})
						.foregroundColor(selectIndex >= n ? .pink.opacity(0.7) : .white.opacity(0.5))
					}
					
				}
			}
			
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
		
		.frame(width: 40,height:height)
		.background(.ultraThinMaterial)
		.cornerRadius(30)
		
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
		// 检查是否需要根据拖动位置更新 selectIndex
		var newIndex = 0

			   for (index, element) in heightArray.enumerated() {
				   if index == count - 1 && location.y >= element {
					   newIndex = index
					   break
				   }else{
					   if index >= 0 && location.y >= element  && location.y < heightArray[index + 1] {
						   newIndex = index
						   break
					   }
				   }
			   }

			   if newIndex != selectIndex {
				   withAnimation(.default){
					hapticFeedback()
					   selectIndex = newIndex
					   complect(selectIndex)
				   }
			   }


			
		
	}
}



