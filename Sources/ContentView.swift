import SwiftUI

struct ContentView: View {
    @StateObject private var manager = ImageManager()
    @FocusState private var focusedField: Field?

    enum Field {
        case width, height
    }

    var body: some View {
        VStack(spacing: 20) {
            if let nsImage = manager.image {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("Paste or Load an Image")
                        .foregroundColor(.gray)
                    HStack {
                        Button("Paste Image") { manager.pasteImage() }
                        Button("Load from Disk") { manager.loadImage() }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(Color.black.opacity(0.05))
                .cornerRadius(8)
            }

            if manager.image != nil {
                HStack(spacing: 15) {
                    VStack(alignment: .leading) {
                        Text("Width").font(.caption).foregroundColor(.secondary)
                        TextField("Width", text: $manager.width)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .width)
                            .onSubmit { manager.updateWidthProportionally(manager.width) }
                    }

                    VStack(alignment: .leading) {
                        Text("Height").font(.caption).foregroundColor(.secondary)
                        TextField("Height", text: $manager.height)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .height)
                            .onSubmit { manager.updateHeightProportionally(manager.height) }
                    }

                    VStack {
                        Spacer().frame(height: 15)
                        Button(action: {
                            manager.resizeImage()
                        }) {
                            HStack {
                                if manager.isResized {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Resized!")
                                        .foregroundColor(.green)
                                } else {
                                    Text("Resize")
                                }
                            }
                        }
                    }
                }
                .onChange(of: focusedField) { oldValue, newValue in
                    if oldValue == .width && newValue != .width {
                        manager.updateWidthProportionally(manager.width)
                    } else if oldValue == .height && newValue != .height {
                        manager.updateHeightProportionally(manager.height)
                    }
                }
                .padding(.top)

                Divider()

                HStack {
                    Button("Export to Clipboard") { 
                        manager.exportToClipboard()
                        // Dismiss the MenuBarExtra window more directly
                        DispatchQueue.main.async {
                            NSApp.keyWindow?.close()
                        }
                    }
                    Spacer()
                    Button("Clear", role: .destructive) { manager.clear() }
                }
            }
        }
        .padding()
        .frame(width: 500)
        .background(
            Button("") {
                manager.pasteImage()
            }
            .keyboardShortcut("v", modifiers: .command)
            .opacity(0)
        )
    }
}
