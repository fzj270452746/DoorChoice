import SpriteKit

// MARK: - Shop Scene
final class MercantileAgora: SKScene {

    private var voyagerLedger: WayfarerLedger!
    private var coinMedallion: IridescentMedallion!
    private var merchandiseNodes: [SKNode] = []
    private var backgroundNode: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var interactionLocked: Bool = false

    override func didMove(to view: SKView) {
        voyagerLedger = ObsidianArchive.sharedVault.reconstituteLedger()
        assembleAmbience()
        assembleNavigation()
        assembleCoinDisplay()
        assembleMerchandise()
    }

    // MARK: - Background
    private func assembleAmbience() {
        let bgTexture = CelestialPigmentary.gradientTexture(
            colorsArray: [
                UIColor(red: 0.08, green: 0.06, blue: 0.20, alpha: 1.0),
                UIColor(red: 0.14, green: 0.10, blue: 0.28, alpha: 1.0),
                UIColor(red: 0.06, green: 0.04, blue: 0.16, alpha: 1.0)
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
            inscription: "ARCANE SHOP",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(26),
            pigment: CelestialPigmentary.amberGleam
        )
        titleLabel.position = CGPoint(
            x: size.width / 2,
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(72)
        )
        titleLabel.zPosition = 200
        addChild(titleLabel)
    }

    // MARK: - Coin Display
    private func assembleCoinDisplay() {
        coinMedallion = IridescentMedallion()
        coinMedallion.position = CGPoint(
            x: size.width / 2,
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(106)
        )
        coinMedallion.zPosition = 200
        addChild(coinMedallion)
        coinMedallion.refreshTally(voyagerLedger.totalHoardedCoins, animated: false)
    }

    // MARK: - Merchandise Cards
    private func assembleMerchandise() {
        let relicKinds: [ArcanaRelicKind] = [.serendipityCharm, .clairvoyanceLens, .amplificationSigil]
        let cardWidth = size.width * 0.85
        let cardHeight = MeridianCalibrator.proportionalValue(130)
        let spacing = MeridianCalibrator.proportionalValue(16)
        let startY = size.height * 0.62

        for (i, kind) in relicKinds.enumerated() {
            let relic = ArcanaRelic(relicKind: kind, stockpileCount: voyagerLedger.relicStockpile(kind))
            let card = forgeMerchandiseCard(relic: relic, cardWidth: cardWidth, cardHeight: cardHeight)
            card.position = CGPoint(
                x: size.width / 2,
                y: startY - CGFloat(i) * (cardHeight + spacing)
            )
            card.zPosition = 100
            card.name = "procure_\(kind.rawValue)"
            addChild(card)
            merchandiseNodes.append(card)

            // Animate in
            card.alpha = 0
            card.setScale(0.8)
            let delay = SKAction.wait(forDuration: Double(i) * 0.1)
            let fadeIn = SKAction.fadeIn(withDuration: 0.25)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
            scaleUp.timingMode = .easeOut
            card.run(SKAction.sequence([delay, SKAction.group([fadeIn, scaleUp])]))
        }
    }

    private func forgeMerchandiseCard(relic: ArcanaRelic, cardWidth: CGFloat, cardHeight: CGFloat) -> SKSpriteNode {
        let canAfford = voyagerLedger.totalHoardedCoins >= relic.tariffCost

        let card = PrismForgeKit.forgePanel(
            breadth: cardWidth,
            altitude: cardHeight,
            chromaArray: canAfford
                ? [UIColor(red: 0.12, green: 0.16, blue: 0.30, alpha: 0.9),
                   UIColor(red: 0.08, green: 0.10, blue: 0.24, alpha: 0.9)]
                : [UIColor(red: 0.10, green: 0.10, blue: 0.14, alpha: 0.9),
                   UIColor(red: 0.06, green: 0.06, blue: 0.10, alpha: 0.9)],
            curvature: MeridianCalibrator.proportionalValue(16)
        )

        // Icon
        let iconSize = MeridianCalibrator.proportionalValue(56)
        let icon = SKSpriteNode(imageNamed: relic.iconAssetMoniker)
        icon.size = CGSize(width: iconSize, height: iconSize)
        icon.position = CGPoint(x: -cardWidth / 2 + iconSize / 2 + MeridianCalibrator.proportionalValue(20), y: MeridianCalibrator.proportionalValue(8))
        icon.zPosition = 110
        icon.alpha = canAfford ? 1.0 : 0.4
        card.addChild(icon)

        // Name
        let nameLabel = GlyphForgeKit.forgeLabel(
            inscription: relic.displayMoniker,
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(17),
            pigment: canAfford ? CelestialPigmentary.ivoryWhisper : CelestialPigmentary.slateUmbra
        )
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: -cardWidth / 2 + iconSize + MeridianCalibrator.proportionalValue(36), y: MeridianCalibrator.proportionalValue(22))
        nameLabel.zPosition = 110
        card.addChild(nameLabel)

        // Description
        let descLabel = GlyphForgeKit.forgeLabel(
            inscription: relic.synopsisText,
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(12),
            pigment: canAfford ? CelestialPigmentary.ivoryWhisper.withAlphaComponent(0.7) : CelestialPigmentary.slateUmbra
        )
        descLabel.horizontalAlignmentMode = .left
        descLabel.numberOfLines = 2
        descLabel.preferredMaxLayoutWidth = cardWidth - iconSize - MeridianCalibrator.proportionalValue(60)
        descLabel.position = CGPoint(x: -cardWidth / 2 + iconSize + MeridianCalibrator.proportionalValue(36), y: -MeridianCalibrator.proportionalValue(2))
        descLabel.zPosition = 110
        card.addChild(descLabel)

        // Price tag
        let priceBtn = PrismForgeKit.forgeGradientButton(
            inscription: "\(relic.tariffCost) coins",
            breadth: MeridianCalibrator.proportionalValue(100),
            altitude: MeridianCalibrator.proportionalValue(32),
            chromaArray: canAfford
                ? [CelestialPigmentary.amberGleam, CelestialPigmentary.tangerineFlair]
                : [CelestialPigmentary.slateUmbra, CelestialPigmentary.slateUmbra],
            fontMagnitude: MeridianCalibrator.proportionalValue(13)
        )
        priceBtn.position = CGPoint(x: cardWidth / 2 - MeridianCalibrator.proportionalValue(70), y: -cardHeight / 2 + MeridianCalibrator.proportionalValue(24))
        priceBtn.zPosition = 110
        card.addChild(priceBtn)

        // Owned count
        let ownedLabel = GlyphForgeKit.forgeLabel(
            inscription: "Owned: \(relic.stockpileCount)",
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(11),
            pigment: CelestialPigmentary.aquamarineSheen
        )
        ownedLabel.position = CGPoint(x: -cardWidth / 2 + MeridianCalibrator.proportionalValue(60), y: -cardHeight / 2 + MeridianCalibrator.proportionalValue(20))
        ownedLabel.zPosition = 110
        card.addChild(ownedLabel)

        return card
    }

    // MARK: - Refresh
    private func refreshMerchandise() {
        for node in merchandiseNodes {
            node.removeFromParent()
        }
        merchandiseNodes.removeAll()
        assembleMerchandise()
        coinMedallion.refreshTally(voyagerLedger.totalHoardedCoins, animated: true)
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !interactionLocked, let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        for node in touchedNodes {
            if let name = node.name ?? node.parent?.name {
                if name == "retreatToCitadel" || name == "← Back" {
                    retreatToCitadel()
                    return
                }
                if name.hasPrefix("procure_") {
                    let relicRaw = String(name.dropFirst(8))
                    if let kind = ArcanaRelicKind(rawValue: relicRaw) {
                        attemptProcurement(kind)
                        return
                    }
                }
            }
        }
    }

    // MARK: - Purchase
    private func attemptProcurement(_ kind: ArcanaRelicKind) {
        guard voyagerLedger.procureRelic(kind) else {
            showInsufficientFundsFlash()
            return
        }
        ObsidianArchive.sharedVault.synchronizeLedger(voyagerLedger)
        showProcurementSuccess(kind)
        refreshMerchandise()
    }

    private func showProcurementSuccess(_ kind: ArcanaRelicKind) {
        let relic = ArcanaRelic(relicKind: kind, stockpileCount: 0)
        let toast = GlyphForgeKit.forgeLabel(
            inscription: "✓ \(relic.displayMoniker) acquired!",
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(16),
            pigment: CelestialPigmentary.verdantMeadow
        )
        toast.position = CGPoint(x: size.width / 2, y: size.height * 0.18)
        toast.zPosition = 300
        toast.alpha = 0
        addChild(toast)
        toast.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
    }

    private func showInsufficientFundsFlash() {
        let toast = GlyphForgeKit.forgeLabel(
            inscription: "Not enough coins!",
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(16),
            pigment: CelestialPigmentary.crimsomEmber
        )
        toast.position = CGPoint(x: size.width / 2, y: size.height * 0.18)
        toast.zPosition = 300
        toast.alpha = 0
        addChild(toast)
        toast.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
    }

    // MARK: - Navigation
    private func retreatToCitadel() {
        let menuScene = CitadelHaven(size: self.size)
        menuScene.scaleMode = .aspectFill
        let transition = SKTransition.push(with: .right, duration: 0.4)
        view?.presentScene(menuScene, transition: transition)
    }
}
