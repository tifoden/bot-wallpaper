import AVFoundation
import CoreImage
import Foundation

/// Renders the selected desktop appearance into the movie used by Apple's Aerial player.
enum LockScreenVideoRenderer {
    private static let recolor = CIColorKernel(source: """
        kernel vec4 recolor(__sample pixel, vec3 tint) {
            float lo = min(pixel.r, min(pixel.g, pixel.b));
            float hi = max(pixel.r, max(pixel.g, pixel.b));
            float neutral = 1.0 - smoothstep(0.025, 0.12, hi - lo);
            float coverage = clamp((lo - 0.00243) / (0.905 - 0.00243), 0.0, 1.0);
            vec3 colored = mix(vec3(0.00243), tint, coverage);
            return vec4(mix(pixel.rgb, colored, neutral), pixel.a);
        }
        """)
    private static let outline = CIColorKernel(source: """
        kernel vec4 outline(__sample pixel) {
            float strength = max(pixel.r, max(pixel.g, pixel.b));
            float edge = smoothstep(0.08, 0.70, strength);
            return vec4(vec3(0.00243 + 0.07 * edge), 1.0);
        }
        """)
    private static func linear(_ byte: UInt32) -> CGFloat {
        let s = CGFloat(byte) / 255
        return s <= 0.04045 ? s / 12.92 : pow((s + 0.055) / 1.055, 2.4)
    }
    static func render(source: URL, output: URL, color: UInt32, size: Int) async throws {
        guard size >= 0 && size <= 3, color <= 0x1000000 else {
            throw NSError(domain: "LockScreenVideoRenderer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wallpaper appearance"])
        }
        let asset = AVURLAsset(url: source)
        let composition = AVMutableVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            let image = request.sourceImage
            let extent = image.extent
            var rendered = image
            if color == 0x1000000, let kernel = outline {
                let edges = image.clampedToExtent().applyingFilter("CIEdges", parameters: [kCIInputIntensityKey: 1.0]).applyingFilter("CIMorphologyMaximum", parameters: [kCIInputRadiusKey: 1.0]).cropped(to: extent)
                rendered = kernel.apply(extent: extent, arguments: [edges]) ?? image
            } else if color != 0xFFFFFF, let kernel = recolor {
                let tint = CIVector(x: linear((color >> 16) & 255), y: linear((color >> 8) & 255), z: linear(color & 255))
                rendered = kernel.apply(extent: extent, arguments: [image, tint]) ?? image
            }
            let scale: CGFloat = size == 1 ? 0.75 : size == 2 ? 0.5 : 1.0
            let dx = extent.midX * (1 - scale)
            let dy = extent.midY * (1 - scale) - (size == 3 ? extent.height * 0.36 : 0)
            let transformed = rendered.transformed(by: CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: dx, ty: dy))
            let background = CIImage(color: CIColor(red: 0, green: 0, blue: 0)).cropped(to: extent)
            request.finish(with: transformed.composited(over: background).cropped(to: extent), context: nil)
        })
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHEVCHighestQuality) else {
            throw NSError(domain: "LockScreenVideoRenderer", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not create video exporter"])
        }
        exporter.outputURL = output
        exporter.outputFileType = .mov
        exporter.videoComposition = composition
        await exporter.export()
        guard exporter.status == .completed else {
            throw exporter.error ?? NSError(domain: "LockScreenVideoRenderer", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not render lock screen video"])
        }
    }
}
