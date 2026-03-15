import SwiftUI
import AppKit

class ImageManager: ObservableObject {
    @Published var image: NSImage?
    @Published var width: String = ""
    @Published var height: String = ""
    @Published var isResized: Bool = false

    private var originalPixelSize: NSSize?

    func updateImage(_ newImage: NSImage) {
        self.image = newImage
        
        // Get actual pixel dimensions
        if let rep = newImage.representations.first {
            let pixelSize = NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
            self.originalPixelSize = pixelSize
            self.width = "\(rep.pixelsWide)"
            self.height = "\(rep.pixelsHigh)"
        } else {
            self.originalPixelSize = newImage.size
            self.width = String(format: "%.0f", newImage.size.width)
            self.height = String(format: "%.0f", newImage.size.height)
        }
    }

    func pasteImage() {
        let pasteboard = NSPasteboard.general
        if let data = pasteboard.data(forType: .tiff), let newImage = NSImage(data: data) {
            updateImage(newImage)
        } else if let data = pasteboard.data(forType: .png), let newImage = NSImage(data: data) {
            updateImage(newImage)
        }
    }

    func loadImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            if let newImage = NSImage(contentsOf: url) {
                updateImage(newImage)
            }
        }
    }

    func clear() {
        image = nil
        width = ""
        height = ""
        originalPixelSize = nil
        isResized = false
    }

    func resizeImage() {
        guard let currentImage = image,
              let w = Double(width),
              let h = Double(height) else { return }

        let newSize = NSSize(width: w, height: h)
        if let resized = currentImage.resized(toPixels: newSize) {
            image = resized
            withAnimation {
                isResized = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.isResized = false
                }
            }
        }
    }

    func exportToClipboard() {
        guard let currentImage = image else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        
        // Use TIFF representation for best compatibility
        if let tiffData = currentImage.tiffRepresentation {
            pasteboard.setData(tiffData, forType: .tiff)
        }
        
        // Clear the state after export
        clear()
    }

    func updateWidthProportionally(_ newWidthStr: String) {
        guard let original = originalPixelSize, let w = MathEvaluator.evaluate(newWidthStr) else { return }
        width = String(format: "%.0f", w)
        let ratio = original.height / original.width
        height = String(format: "%.0f", w * ratio)
    }

    func updateHeightProportionally(_ newHeightStr: String) {
        guard let original = originalPixelSize, let h = MathEvaluator.evaluate(newHeightStr) else { return }
        height = String(format: "%.0f", h)
        let ratio = original.width / original.height
        width = String(format: "%.0f", h * ratio)
    }
}

extension NSImage {
    func resized(toPixels newSize: NSSize) -> NSImage? {
        guard let representation = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(newSize.width),
            pixelsHigh: Int(newSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) else { return nil }

        representation.size = newSize

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: representation)
        self.draw(in: NSRect(origin: .zero, size: newSize),
                  from: NSRect(origin: .zero, size: self.size),
                  operation: .copy,
                  fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()

        let newImage = NSImage(size: newSize)
        newImage.addRepresentation(representation)
        return newImage
    }
}
