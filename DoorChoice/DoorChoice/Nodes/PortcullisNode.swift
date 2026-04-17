import SpriteKit

// MARK: - Door Node
final class PortcullisNode: SKSpriteNode {

    let essenceData: PortcullisEssence
    private var isUnveiled: Bool = false
    private var dangerBadgeNode: SKSpriteNode?

    init(essenceData: PortcullisEssence, dimension: CGSize) {
        self.essenceData = essenceData
        let closedTexture = SKTexture(imageNamed: "door_closed")
        super.init(texture: closedTexture, color: .clear, size: dimension)
        self.isUserInteractionEnabled = false
        self.name = "portcullis_\(essenceData.sequenceIndex)"
        self.zPosition = 10
        assembleShadowUnderglow(dimension: dimension)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Shadow
    private func assembleShadowUnderglow(dimension: CGSize) {
        let shadowNode = SKShapeNode(ellipseOf: CGSize(width: dimension.width * 0.8, height: dimension.height * 0.1))
        shadowNode.fillColor = UIColor.black.withAlphaComponent(0.25)
        shadowNode.strokeColor = .clear
        shadowNode.position = CGPoint(x: 0, y: -dimension.height * 0.48)
        shadowNode.zPosition = -1
        addChild(shadowNode)
    }

    // MARK: - Hover Effect
    func applyHoverGleam() {
        guard !isUnveiled else { return }
        let hoverTexture = SKTexture(imageNamed: "door_hover")
        self.texture = hoverTexture
        let pulseUp = SKAction.scale(to: 1.08, duration: 0.12)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.12)
        pulseUp.timingMode = .easeOut
        pulseDown.timingMode = .easeIn
        run(SKAction.sequence([pulseUp, pulseDown]))
    }

    func removeHoverGleam() {
        guard !isUnveiled else { return }
        let closedTexture = SKTexture(imageNamed: "door_closed")
        self.texture = closedTexture
    }

    // MARK: - Unveil Animation
    func unveilPortcullis(completion: @escaping () -> Void) {
        guard !isUnveiled else { return }
        isUnveiled = true

        let revealTexture = SKTexture(imageNamed: essenceData.revealedAssetMoniker)

        let swingOpen = SKAction.scaleX(to: 0.05, duration: 0.2)
        swingOpen.timingMode = .easeIn

        let changeTexture = SKAction.run { [weak self] in
            self?.texture = revealTexture
        }

        let swingReveal = SKAction.scaleX(to: 1.0, duration: 0.25)
        swingReveal.timingMode = .easeOut

        let bounceUp = SKAction.scale(to: 1.1, duration: 0.1)
        let bounceDown = SKAction.scale(to: 1.0, duration: 0.1)

        let sequence = SKAction.sequence([
            swingOpen, changeTexture, swingReveal,
            bounceUp, bounceDown,
            SKAction.wait(forDuration: 0.3),
            SKAction.run(completion)
        ])
        run(sequence)
    }

    // MARK: - Danger Badge (X-Ray)
    func brandDangerInsignia() {
        guard dangerBadgeNode == nil else { return }
        let badge = SKSpriteNode(imageNamed: "icon_danger")
        let badgeSize = self.size.width * 0.4
        badge.size = CGSize(width: badgeSize, height: badgeSize)
        badge.position = CGPoint(x: 0, y: self.size.height * 0.25)
        badge.zPosition = 20
        badge.alpha = 0
        badge.name = "dangerInsignia"
        addChild(badge)
        dangerBadgeNode = badge

        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.15, duration: 0.4),
            SKAction.scale(to: 1.0, duration: 0.4)
        ])
        badge.run(SKAction.group([fadeIn, SKAction.repeatForever(pulse)]))
    }

    // MARK: - Shake for wrong
    func tremblePortcullis() {
        let shakeLeft = SKAction.moveBy(x: -6, y: 0, duration: 0.05)
        let shakeRight = SKAction.moveBy(x: 12, y: 0, duration: 0.05)
        let shakeBack = SKAction.moveBy(x: -6, y: 0, duration: 0.05)
        let shakeSequence = SKAction.sequence([shakeLeft, shakeRight, shakeBack])
        run(SKAction.repeat(shakeSequence, count: 3))
    }

    // MARK: - Idle Animation
    func beginIdleOscillation() {
        let floatUp = SKAction.moveBy(x: 0, y: 4, duration: 1.2)
        floatUp.timingMode = .easeInEaseOut
        let floatDown = SKAction.moveBy(x: 0, y: -4, duration: 1.2)
        floatDown.timingMode = .easeInEaseOut
        let oscillate = SKAction.sequence([floatUp, floatDown])
        run(SKAction.repeatForever(oscillate), withKey: "idleOscillation")
    }

    func ceaseIdleOscillation() {
        removeAction(forKey: "idleOscillation")
    }
}
