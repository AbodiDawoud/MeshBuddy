import SwiftUI
import HighlightSwift


struct SwiftCodeView: View {
    var gradient: MeshGradientDefinition
    @State private var didCopy: Bool = false
    @Environment(\.self) private var environment
    
    private var output: String {
        SwiftGenerator.generateOutput(gradient, in: environment)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            CodeText(output)
                .highlightLanguage(.swift)
                .codeTextColors(.theme(.xcode))
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .toolbar {
            Button(action: copy) {
                Image(systemName: didCopy ? "checkmark" : "document.on.document.fill")
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                    .foregroundStyle(didCopy ? .green : .gray)
                    .bold()
            }
            .help("Copy code to clipboard")
        }
    }
    
    func copy() {
        if didCopy { return } // skip if the animation is already playing
        
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(output, forType: .string)
       
        withAnimation {
            didCopy = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                didCopy = false
            }
        }
    }
}


struct SwiftCodeWindow: Scene {
    var body: some Scene {
        WindowGroup(for: MeshGradientDefinition.self) { meshGradient in
            if let gradient = meshGradient.wrappedValue {
                SwiftCodeView(gradient: gradient)
            }
        }
        .windowToolbarStyle(.unifiedCompact)
        .commandsRemoved()
    }
}


struct ViewSwiftCodeButton: View {
    @Environment(\.openWindow) private var openWindow
    
    var gradientProvider: () -> MeshGradientDefinition
    
    var body: some View {
        Button {
            openWindow(value: gradientProvider())
        } label: {
            Label("", systemImage: "ellipsis.curlybraces")
                .padding(10)
                .background(.thinMaterial, in: .circle)
                .labelStyle(.iconOnly)
                .overlay {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .foregroundColor(.gray.opacity(0.15))
                }
        }
        .help("View Swift code")
        .keyboardShortcut("c", modifiers: [.command, .option])
    }
}
