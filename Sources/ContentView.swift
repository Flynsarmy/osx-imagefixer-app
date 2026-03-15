import SwiftUI

struct TransparencyGrid: View {
    var body: some View {
        Canvas { context, size in
            let gridSize: CGFloat = 8
            for y in stride(from: 0, to: size.height, by: gridSize) {
                for x in stride(from: 0, to: size.width, by: gridSize) {
                    if Int((x / gridSize) + (y / gridSize)) % 2 == 0 {
                        context.fill(Path(CGRect(x: x, y: y, width: gridSize, height: gridSize)), with: .color(Color.white))
                    } else {
                        context.fill(Path(CGRect(x: x, y: y, width: gridSize, height: gridSize)), with: .color(Color(white: 0.85)))
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var manager = ImageManager()
    @FocusState private var focusedField: Field?
    var onClose: () -> Void

    enum Field {
        case width, height
    }

    var body: some View {
        VStack(spacing: 20) {
            if let nsImage = manager.image {
                ZStack {
                    TransparencyGrid()
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .aspectRatio(nsImage.size.width / nsImage.size.height, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .cornerRadius(8)
                .shadow(radius: 2)
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
                    Button("Export (PNG)") { 
                        manager.exportToClipboard(as: .png)
                        onClose()
                    }
                    Button("Export (JPG)") { 
                        manager.exportToClipboard(as: .jpg)
                        onClose()
                    }
                    Spacer()
                    Button("Clear", role: .destructive) { 
                        manager.clear()
                    }
                    .keyboardShortcut(.escape, modifiers: [])
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
