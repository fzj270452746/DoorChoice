import SpriteKit

// MARK: - Inventory Scene
final class CurioReliquary: SKScene {

    private var voyagerLedger: WayfarerLedger!
    private var backgroundNode: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var reliquaryNodes: [SKNode] = []

    override func didMove(to view: SKView) {
        voyagerLedger = ObsidianArchive.sharedVault.reconstituteLedger()
        assembleAmbience()
        assembleNavigation()
        assembleReliquaryDisplay()
    }

    // MARK: - Background
    private func assembleAmbience() {
        let bgTexture = CelestialPigmentary.gradientTexture(
            colorsArray: [
                UIColor(red: 0.06, green: 0.08, blue: 0.22, alpha: 1.0),
                UIColor(red: 0.10, green: 0.12, blue: 0.26, alpha: 1.0),
                UIColor(red: 0.04, green: 0.06, blue: 0.18, alpha: 1.0)
            ],
            meridianExtent: self.size
        )
        backgroundNode = SKSpriteNode(texture: bgTexture, size: self.size)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
    }

    // MARK: - Navigation
    private func assembleNavigation() {
        let backBtnWidth = MeridianCalibrator.proportionalValue(90)
        let backBtnHeight = MeridianCalibrator.proportionalValue(38)
        let backBtn = PrismForgeKit.forgeGradientButton(
            inscription: "← Back",
            breadth: backBtnWidth,
            altitude: backBtnHeight,
            chromaArray: [CelestialPigmentary.slateUmbra, CelestialPigmentary.ceruleanDepth],
            fontMagnitude: MeridianCalibrator.proportionalValue(14)
        )
        backBtn.position = CGPoint(
            x: MeridianCalibrator.proportionalValue(60),
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(28)
        )
        backBtn.zPosition = 200
        backBtn.name = "retreatToCitadel"
        addChild(backBtn)

        titleLabel = GlyphForgeKit.forgeLabel(
            inscription: "MY RELICS",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(26),
            pigment: CelestialPigmentary.orchidTwilight
        )
        titleLabel.position = CGPoint(
            x: size.width / 2,
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(72)
        )
        titleLabel.zPosition = 200
        addChild(titleLabel)
    }

    // MARK: - Reliquary Display
    private func assembleReliquaryDisplay() {
        let relicKinds: [ArcanaRelicKind] = [.serendipityCharm, .clairvoyanceLens, .amplificationSigil]
        let cardWidth = size.width * 0.85
        let cardHeight = MeridianCalibrator.proportionalValue(120)
        let spacing = MeridianCalibrator.proportionalValue(18)
        let startY = size.height * 0.58

        var hasAnyRelic = false

        for (i, kind) in relicKinds.enumerated() {
            let count = voyagerLedger.relicStockpile(kind)
            if count > 0 { hasAnyRelic = true }
            let relic = ArcanaRelic(relicKind: kind, stockpileCount: count)
            let card = forgeReliquaryCard(relic: relic, cardWidth: cardWidth, cardHeight: cardHeight)
            card.position = CGPoint(
                x: size.width / 2,
                y: startY - CGFloat(i) * (cardHeight + spacing)
            )
            card.zPosition = 100
            addChild(card)
            reliquaryNodes.append(card)

            // Animate in
            card.alpha = 0
            card.setScale(0.85)
            let delay = SKAction.wait(forDuration: Double(i) * 0.12)
            let fadeIn = SKAction.fadeIn(withDuration: 0.3)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
            scaleUp.timingMode = .easeOut
            card.run(SKAction.sequence([delay, SKAction.group([fadeIn, scaleUp])]))
        }

        if !hasAnyRelic {
            // Hide all cards and show empty message instead
            for node in reliquaryNodes {
                node.removeFromParent()
            }
            reliquaryNodes.removeAll()

            let emptyLabel = GlyphForgeKit.forgeLabel(
                inscription: "No relics yet. Visit the shop!",
                fontMoniker: GlyphForgeKit.bodyMoniker,
                magnitude: MeridianCalibrator.proportionalValue(16),
                pigment: CelestialPigmentary.slateUmbra
            )
            emptyLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
            emptyLabel.zPosition = 100
            addChild(emptyLabel)
        }
    }

    private func forgeReliquaryCard(relic: ArcanaRelic, cardWidth: CGFloat, cardHeight: CGFloat) -> SKSpriteNode {
        let hasStock = relic.stockpileCount > 0

        let card = PrismForgeKit.forgePanel(
            breadth: cardWidth,
            altitude: cardHeight,
            chromaArray: hasStock
                ? [UIColor(red: 0.10, green: 0.14, blue: 0.28, alpha: 0.9),
                   UIColor(red: 0.06, green: 0.10, blue: 0.22, alpha: 0.9)]
                : [UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 0.7),
                   UIColor(red: 0.05, green: 0.05, blue: 0.08, alpha: 0.7)],
            curvature: MeridianCalibrator.proportionalValue(16)
        )

        // Icon
        let iconSize = MeridianCalibrator.proportionalValue(52)
        let icon = SKSpriteNode(imageNamed: relic.iconAssetMoniker)
        icon.size = CGSize(width: iconSize, height: iconSize)
        icon.position = CGPoint(x: -cardWidth / 2 + iconSize / 2 + MeridianCalibrator.proportionalValue(20), y: MeridianCalibrator.proportionalValue(6))
        icon.zPosition = 110
        icon.alpha = hasStock ? 1.0 : 0.3
        card.addChild(icon)

        // Name
        let nameLabel = GlyphForgeKit.forgeLabel(
            inscription: relic.displayMoniker,
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(17),
            pigment: hasStock ? CelestialPigmentary.ivoryWhisper : CelestialPigmentary.slateUmbra
        )
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: -cardWidth / 2 + iconSize + MeridianCalibrator.proportionalValue(32), y: MeridianCalibrator.proportionalValue(18))
        nameLabel.zPosition = 110
        card.addChild(nameLabel)

        // Description
        let descLabel = GlyphForgeKit.forgeLabel(
            inscription: relic.synopsisText,
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(12),
            pigment: hasStock ? CelestialPigmentary.ivoryWhisper.withAlphaComponent(0.7) : CelestialPigmentary.slateUmbra
        )
        descLabel.horizontalAlignmentMode = .left
        descLabel.numberOfLines = 2
        descLabel.preferredMaxLayoutWidth = cardWidth * 0.55
        descLabel.position = CGPoint(x: -cardWidth / 2 + iconSize + MeridianCalibrator.proportionalValue(32), y: -MeridianCalibrator.proportionalValue(6))
        descLabel.zPosition = 110
        card.addChild(descLabel)

        // Quantity badge
        let qtyLabel = GlyphForgeKit.forgeLabel(
            inscription: "x\(relic.stockpileCount)",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(24),
            pigment: hasStock ? CelestialPigmentary.amberGleam : CelestialPigmentary.slateUmbra
        )
        qtyLabel.position = CGPoint(x: cardWidth / 2 - MeridianCalibrator.proportionalValue(36), y: 0)
        qtyLabel.zPosition = 110
        card.addChild(qtyLabel)

        // Glow for items in stock
        if hasStock {
            let glowCircle = SKShapeNode(circleOfRadius: iconSize / 2 + 4)
            glowCircle.fillColor = .clear
            glowCircle.strokeColor = CelestialPigmentary.amberGleam.withAlphaComponent(0.3)
            glowCircle.lineWidth = 2
            glowCircle.position = icon.position
            glowCircle.zPosition = 105
            card.addChild(glowCircle)

            let pulseUp = SKAction.fadeAlpha(to: 0.6, duration: 1.0)
            let pulseDown = SKAction.fadeAlpha(to: 0.2, duration: 1.0)
            glowCircle.run(SKAction.repeatForever(SKAction.sequence([pulseUp, pulseDown])))
        }

        return card
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        for node in touchedNodes {
            if let name = node.name ?? node.parent?.name {
                if name == "retreatToCitadel" || name == "← Back" {
                    retreatToCitadel()
                    return
                }
            }
        }
    }

    // MARK: - Navigation
    private func retreatToCitadel() {
        let menuScene = CitadelHaven(size: self.size)
        menuScene.scaleMode = .aspectFill
        let transition = SKTransition.push(with: .right, duration: 0.4)
        view?.presentScene(menuScene, transition: transition)
    }
}
