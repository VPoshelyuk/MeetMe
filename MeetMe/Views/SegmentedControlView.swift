//
//  SegmentedControlView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize // Define that the PreferenceKey attribute is of type CGSize
    static var defaultValue: CGSize = .zero // Default to zero size
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

struct SizeAwareViewModifier: ViewModifier {
    
    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

struct SegmentedControlView: View {
    private static let ActiveSegmentColor: Color = Color(.tertiarySystemBackground)
    private static let BackgroundColor: Color = Color(.secondarySystemBackground)
    private static let ShadowColor: Color = Color.black.opacity(0.2)
    private static let TextColor: Color = Color(.secondaryLabel)
    private static let SelectedTextColor: Color = Color("textViewColor")
    private static let TextFont: Font = .system(size: 14)
    
    private static let SegmentCornerRadius: CGFloat = 12
    private static let ShadowRadius: CGFloat = 4
    private static let SegmentXPadding: CGFloat = 16
    private static let SegmentYPadding: CGFloat = 8
    private static let PickerPadding: CGFloat = 4
    
    private static let AnimationDuration: Double = 0.3
    
    @State private var segmentSize: CGSize = .zero
    @Binding private var selected: Int
    
    init(selected: Binding<Int>) {
        self._selected = selected
    }
    
    private let picsText = [(image: "cards_stack", text: "Cards"),(image: "profile", text: "Me"),(image: "settings", text: "Settings")]
    
    private var activeSegmentView: AnyView {
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        return
            RoundedRectangle(cornerRadius: SegmentedControlView.SegmentCornerRadius)
                .foregroundColor(SegmentedControlView.ActiveSegmentColor)
                .shadow(color: SegmentedControlView.ShadowColor, radius: SegmentedControlView.ShadowRadius)
                .frame(width: self.segmentSize.width, height: self.segmentSize.height)
                .offset(x: self.computeActiveSegmentHorizontalOffset(), y: 0)
                .animation(Animation.linear(duration: SegmentedControlView.AnimationDuration))
                .eraseToAnyView()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            self.activeSegmentView
            HStack {
                ForEach(0..<self.picsText.count, id: \.self) { index in
                  self.getSegment(for: index)
                }
            }
        }
        .padding(SegmentedControlView.PickerPadding)
        .background(SegmentedControlView.BackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: SegmentedControlView.SegmentCornerRadius))
    }
    
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(self.selected) * (self.segmentSize.width + SegmentedControlView.SegmentXPadding / 2)
    }
    
    private func getSegment(for index: Int) -> some View {
        guard index < self.picsText.count else {
            return EmptyView().eraseToAnyView()
        }
        let isSelected = self.selected == index
        return
            HStack{
                Image(picsText[index].image)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                Text(picsText[index].text)
                    .font(SegmentedControlView.TextFont)
            }
            .foregroundColor(isSelected ? SegmentedControlView.SelectedTextColor: SegmentedControlView.TextColor)
            .lineLimit(1)
            .padding(.vertical, SegmentedControlView.SegmentYPadding)
            .padding(.horizontal, SegmentedControlView.SegmentXPadding)
            .frame(minWidth: 0, maxWidth: .infinity)
            .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
            .onTapGesture { self.onTap(index) }
            .eraseToAnyView()
    }
    
    private func onTap(_ index: Int) {
        self.selected = index
    }
}

struct SegmentedControlView_Previews: PreviewProvider {
    @State static var selected = 0
    static var previews: some View {
        SegmentedControlView(selected: $selected)
    }
}
