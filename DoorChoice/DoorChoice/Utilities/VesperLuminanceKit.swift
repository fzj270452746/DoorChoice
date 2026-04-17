import SpriteKit
import UIKit

// MARK: - Color Palette
struct CelestialPigmentary {
    static let amberGleam = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
    static let verdantMeadow = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
    static let crimsomEmber = UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.0)
    static let orchidTwilight = UIColor(red: 0.56, green: 0.27, blue: 0.68, alpha: 1.0)
    static let ceruleanDepth = UIColor(red: 0.16, green: 0.22, blue: 0.38, alpha: 1.0)
    static let midnightVault = UIColor(red: 0.10, green: 0.14, blue: 0.28, alpha: 1.0)
    static let ivoryWhisper = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
    static let slateUmbra = UIColor(red: 0.55, green: 0.55, blue: 0.60, alpha: 1.0)
    static let tangerineFlair = UIColor(red: 1.0, green: 0.60, blue: 0.20, alpha: 1.0)
    static let aquamarineSheen = UIColor(red: 0.20, green: 0.80, blue: 0.85, alpha: 1.0)
    static let pearlLuster = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15)

    static func gradientTexture(
        colorsArray: [UIColor],
        meridianExtent: CGSize,
        isHorizontal: Bool = false
    ) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: meridianExtent)
        let image = renderer.image { ctx in
            let cgColors = colorsArray.map { $0.cgColor }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: cgColors as CFArray,
                locations: nil
            ) else { return }
            let startPoint: CGPoint
            let endPoint: CGPoint
            if isHorizontal {
                startPoint = .zero
                endPoint = CGPoint(x: meridianExtent.width, y: 0)
            } else {
                startPoint = .zero
                endPoint = CGPoint(x: 0, y: meridianExtent.height)
            }
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: startPoint,
                end: endPoint,
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
            )
        }
        return SKTexture(image: image)
    }
}

// MARK: - Font Helper
struct GlyphForgeKit {
    static let headlineMoniker = "AvenirNext-Bold"
    static let bodyMoniker = "AvenirNext-Medium"
    static let captionMoniker = "AvenirNext-Regular"
    static let accentMoniker = "AvenirNext-DemiBold"

    static func forgeLabel(
        inscription: String,
        fontMoniker: String = GlyphForgeKit.bodyMoniker,
        magnitude: CGFloat = 18,
        pigment: UIColor = CelestialPigmentary.ivoryWhisper
    ) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: fontMoniker)
        label.text = inscription
        label.fontSize = magnitude
        label.fontColor = pigment
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        return label
    }
}

// MARK: - Button Factory
struct PrismForgeKit {

    static func forgeGradientButton(
        inscription: String,
        breadth: CGFloat = 200,
        altitude: CGFloat = 50,
        chromaArray: [UIColor] = [
            CelestialPigmentary.aquamarineSheen,
            CelestialPigmentary.orchidTwilight
        ],
        cornerCurvature: CGFloat = 14,
        fontMagnitude: CGFloat = 18
    ) -> SKSpriteNode {
        let buttonSize = CGSize(width: breadth, height: altitude)
        let texture = renderRoundedGradient(
            extent: buttonSize,
            chromaArray: chromaArray,
            curvature: cornerCurvature
        )
        let button = SKSpriteNode(texture: texture, size: buttonSize)
        button.name = inscription

        let label = GlyphForgeKit.forgeLabel(
            inscription: inscription,
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: fontMagnitude,
            pigment: .white
        )
        label.position = .zero
        label.zPosition = 1
        button.addChild(label)

        return button
    }

    static func renderRoundedGradient(
        extent: CGSize,
        chromaArray: [UIColor],
        curvature: CGFloat
    ) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: extent)
        let image = renderer.image { ctx in
            let path = UIBezierPath(
                roundedRect: CGRect(origin: .zero, size: extent),
                cornerRadius: curvature
            )
            path.addClip()
            let cgColors = chromaArray.map { $0.cgColor }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: cgColors as CFArray,
                locations: nil
            ) else { return }
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: extent.width, y: 0),
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
            )
        }
        return SKTexture(image: image)
    }

    static func forgePanel(
        breadth: CGFloat,
        altitude: CGFloat,
        chromaArray: [UIColor] = [
            CelestialPigmentary.ceruleanDepth,
            CelestialPigmentary.midnightVault
        ],
        curvature: CGFloat = 20,
        borderChroma: UIColor = CelestialPigmentary.pearlLuster,
        borderThickness: CGFloat = 2
    ) -> SKSpriteNode {
        let panelSize = CGSize(width: breadth, height: altitude)
        let renderer = UIGraphicsImageRenderer(size: panelSize)
        let image = renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: panelSize)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: curvature)
            path.addClip()

            let cgColors = chromaArray.map { $0.cgColor }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: cgColors as CFArray,
                locations: nil
            ) {
                ctx.cgContext.drawLinearGradient(
                    gradient,
                    start: .zero,
                    end: CGPoint(x: 0, y: panelSize.height),
                    options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
                )
            }

            ctx.cgContext.setStrokeColor(borderChroma.cgColor)
            ctx.cgContext.setLineWidth(borderThickness)
            let insetRect = rect.insetBy(dx: borderThickness / 2, dy: borderThickness / 2)
            let borderPath = UIBezierPath(roundedRect: insetRect, cornerRadius: curvature)
            borderPath.stroke()
        }
        let texture = SKTexture(image: image)
        return SKSpriteNode(texture: texture, size: panelSize)
    }
}

// MARK: - Animation Helpers
struct KineticWeaveKit {

    static func pulsateSequence(scaleFactor: CGFloat = 1.08, cadence: TimeInterval = 0.8) -> SKAction {
        let enlarge = SKAction.scale(to: scaleFactor, duration: cadence / 2)
        enlarge.timingMode = .easeInEaseOut
        let shrink = SKAction.scale(to: 1.0, duration: cadence / 2)
        shrink.timingMode = .easeInEaseOut
        return SKAction.repeatForever(SKAction.sequence([enlarge, shrink]))
    }

    static func shimmerSequence(cadence: TimeInterval = 1.2) -> SKAction {
        let fadeDown = SKAction.fadeAlpha(to: 0.6, duration: cadence / 2)
        fadeDown.timingMode = .easeInEaseOut
        let fadeUp = SKAction.fadeAlpha(to: 1.0, duration: cadence / 2)
        fadeUp.timingMode = .easeInEaseOut
        return SKAction.repeatForever(SKAction.sequence([fadeDown, fadeUp]))
    }

    static func bounceInSequence(cadence: TimeInterval = 0.4) -> SKAction {
        let setScale = SKAction.scale(to: 0.3, duration: 0)
        let scaleUp = SKAction.scale(to: 1.0, duration: cadence)
        scaleUp.timingMode = .easeOut
        let fadeIn = SKAction.fadeIn(withDuration: cadence * 0.6)
        return SKAction.sequence([setScale, SKAction.group([scaleUp, fadeIn])])
    }

    static func shakeSequence(magnitude: CGFloat = 8, cadence: TimeInterval = 0.05, repetitions: Int = 4) -> SKAction {
        var actions: [SKAction] = []
        for _ in 0..<repetitions {
            actions.append(SKAction.moveBy(x: magnitude, y: 0, duration: cadence))
            actions.append(SKAction.moveBy(x: -magnitude * 2, y: 0, duration: cadence))
            actions.append(SKAction.moveBy(x: magnitude, y: 0, duration: cadence))
        }
        return SKAction.sequence(actions)
    }

    static func coinBurstEmitter() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 30
        emitter.numParticlesToEmit = 20
        emitter.particleLifetime = 1.2
        emitter.particleLifetimeRange = 0.4
        emitter.emissionAngleRange = .pi * 2
        emitter.particleSpeed = 120
        emitter.particleSpeedRange = 40
        emitter.particleAlpha = 1.0
        emitter.particleAlphaSpeed = -0.8
        emitter.particleScale = 0.15
        emitter.particleScaleRange = 0.05
        emitter.particleScaleSpeed = -0.1
        emitter.yAcceleration = -200
        if let coinImage = UIImage(named: "icon_coin") {
            emitter.particleTexture = SKTexture(image: coinImage)
        }
        return emitter
    }

    static func explosionBurstEmitter() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 80
        emitter.numParticlesToEmit = 40
        emitter.particleLifetime = 0.8
        emitter.particleLifetimeRange = 0.3
        emitter.emissionAngleRange = .pi * 2
        emitter.particleSpeed = 180
        emitter.particleSpeedRange = 60
        emitter.particleAlpha = 1.0
        emitter.particleAlphaSpeed = -1.2
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.15
        emitter.particleScaleSpeed = -0.2
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColor = CelestialPigmentary.tangerineFlair
        emitter.particleColorRedRange = 0.2
        emitter.particleColorGreenRange = 0.1
        let circle = renderCircleTexture(radius: 8, color: .white)
        emitter.particleTexture = circle
        return emitter
    }

    private static func renderCircleTexture(radius: CGFloat, color: UIColor) -> SKTexture {
        let size = CGSize(width: radius * 2, height: radius * 2)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            color.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
        return SKTexture(image: image)
    }
}
