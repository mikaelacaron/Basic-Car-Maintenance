import SwiftUI

struct LiquidGlassCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.accessibilityHighContrast) var highContrast
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 6, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        highContrast ? Color.primary.opacity(0.6) : .primary.opacity(0.15),
                        lineWidth: highContrast ? 1.0 : 0.5
                    )
            )
    }
}

struct LiquidGlassSheetModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.accessibilityHighContrast) var highContrast
    
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.4 : 0.15), radius: 10, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        highContrast ? Color.primary.opacity(0.7) : .primary.opacity(0.2),
                        lineWidth: highContrast ? 1.5 : 1.0
                    )
            )
    }
}

struct LiquidGlassSectionModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.accessibilityHighContrast) var highContrast
    
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.08), radius: 4, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        highContrast ? Color.primary.opacity(0.5) : .primary.opacity(0.12),
                        lineWidth: highContrast ? 1.0 : 0.5
                    )
            )
    }
}

struct LiquidGlassChartModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.accessibilityHighContrast) var highContrast
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.25 : 0.1), radius: 8, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        highContrast ? Color.primary.opacity(0.6) : .primary.opacity(0.2),
                        lineWidth: highContrast ? 1.0 : 0.5
                    )
            )
            .padding(.horizontal)
    }
}

// Helper view for visual effects
struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

extension UIColor {
    var color: Color {
        Color(self)
    }
}

extension View {
    func liquidGlassCard() -> some View {
        modifier(LiquidGlassCardModifier())
    }
    
    func liquidGlassSheet() -> some View {
        modifier(LiquidGlassSheetModifier())
    }
    
    func liquidGlassSection() -> some View {
        modifier(LiquidGlassSectionModifier())
    }
    
    func liquidGlassChart() -> some View {
        modifier(LiquidGlassChartModifier())
    }
}