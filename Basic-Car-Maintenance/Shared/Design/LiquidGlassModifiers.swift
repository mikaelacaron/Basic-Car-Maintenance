import SwiftUI

struct LiquidGlassCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    
    func body(content: Content) -> some View {
        content
            .background(
                reduceTransparency ? 
                Color(UIColor.secondarySystemGroupedBackground) : Color.clear
            )
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 6, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colorSchemeContrast == .increased ?
                            Color.primary.opacity(0.8) : .primary.opacity(0.15),
                        lineWidth: colorSchemeContrast == .increased ? 2.0 : 0.5
                    )
            )
    }
}

struct LiquidGlassSectionModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.08), radius: 4, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colorSchemeContrast == .increased ?
                            Color.primary.opacity(0.5) : .primary.opacity(0.12),
                        lineWidth: colorSchemeContrast == .increased ? 1.0 : 0.5
                    )
            )
    }
}

struct LiquidGlassChartModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.25 : 0.1), radius: 8, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colorSchemeContrast == .increased ?
                            Color.primary.opacity(0.6) : .primary.opacity(0.2),
                        lineWidth: colorSchemeContrast == .increased ? 1.0 : 0.5
                    )
            )
            .padding(.horizontal)
    }
}

extension View {
    func liquidGlassCard() -> some View {
        modifier(LiquidGlassCardModifier())
    }
    
    func liquidGlassSection() -> some View {
        modifier(LiquidGlassSectionModifier())
    }
    
    func liquidGlassChart() -> some View {
        modifier(LiquidGlassChartModifier())
    }
}
