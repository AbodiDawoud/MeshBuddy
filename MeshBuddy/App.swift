import SwiftUI

@main
struct MeshBuddyApp: App {
    private let updateManager = AppUpdateManager()

    var body: some Scene {
        DocumentGroup(newDocument: MeshGradientDefinitionDocument()) { configuration in
            DocumentView(document: configuration.$document)
                .gesture(WindowDragGesture())
                .frame(minWidth: 700, minHeight: 600)
        }
        .windowToolbarStyle(.unifiedCompact)
        .defaultSize(width: 900, height: 600)
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesButton(manager: updateManager)
            }
        }
        
        SwiftCodeWindow()
    }
}
