import SpriteKit

// MARK: - Main Menu Scene
final class CitadelHaven: SKScene {

    private var voyagerLedger: WayfarerLedger!
    private var titleLabel: SKLabelNode!
    private var coinDisplayNode: IridescentMedallion!
    private var backgroundNode: SKSpriteNode!

    override func didMove(to view: SKView) {
        voyagerLedger = ObsidianArchive.sharedVault.reconstituteLedger()
        assembleAmbience()
        assembleTitle()
        assembleCoinHUD()
        assembleMenuButtons()
        assembleRecordDisplay()
        assembleFloatingParticles()
    }

    // MARK: - Background
    private func assembleAmbience() {
        let bgTexture = CelestialPigmentary.gradientTexture(
            colorsArray: [
                UIColor(red: 0.08, green: 0.12, blue: 0.28, alpha: 1.0),
                UIColor(red: 0.14, green: 0.10, blue: 0.30, alpha: 1.0),
                UIColor(red: 0.06, green: 0.08, blue: 0.20, alpha: 1.0)
            ],
            meridianExtent: self.size
        )
        backgroundNode = SKSpriteNode(texture: bgTexture, size: self.size)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)

        // Decorative door silhouettes
        let doorPositions: [CGFloat] = [0.2, 0.5, 0.8]
        for (i, xFrac) in doorPositions.enumerated() {
            let doorSilhouette = SKSpriteNode(imageNamed: "door_closed")
            let doorSize = MeridianCalibrator.proportionalValue(80)
            doorSilhouette.size = CGSize(width: doorSize, height: doorSize * 1.4)
            doorSilhouette.position = CGPoint(
                x: size.width * xFrac,
                y: size.height * 0.28
            )
            doorSilhouette.alpha = 0.12
            doorSilhouette.zPosition = -5
            addChild(doorSilhouette)

            let floatUp = SKAction.moveBy(x: 0, y: 8, duration: 2.0 + Double(i) * 0.3)
            floatUp.timingMode = .easeInEaseOut
            let floatDown = floatUp.reversed()
            doorSilhouette.run(SKAction.repeatForever(SKAction.sequence([floatUp, floatDown])))
        }
    }

    // MARK: - Title
    private func assembleTitle() {
        let titleSize = MeridianCalibrator.proportionalValue(36)
        titleLabel = GlyphForgeKit.forgeLabel(
            inscription: "DOOR CHOICE",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: titleSize,
            pigment: CelestialPigmentary.ivoryWhisper
        )
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.72)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        // Subtitle
        let subtitleLabel = GlyphForgeKit.forgeLabel(
            inscription: "Choose wisely. Survive the doors.",
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(14),
            pigment: CelestialPigmentary.slateUmbra
        )
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.72 - titleSize - 4)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)

        // Title glow pulse
        let glowUp = SKAction.fadeAlpha(to: 0.7, duration: 1.5)
        let glowDown = SKAction.fadeAlpha(to: 1.0, duration: 1.5)
        titleLabel.run(SKAction.repeatForever(SKAction.sequence([glowUp, glowDown])))
    }

    // MARK: - Coin HUD
    private func assembleCoinHUD() {
        coinDisplayNode = IridescentMedallion()
        coinDisplayNode.position = CGPoint(
            x: size.width / 2,
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(30)
        )
        coinDisplayNode.zPosition = 100
        addChild(coinDisplayNode)
        coinDisplayNode.refreshTally(voyagerLedger.totalHoardedCoins, animated: false)
    }

    // MARK: - Menu Buttons
    private func assembleMenuButtons() {
        let btnWidth = MeridianCalibrator.proportionalValue(220)
        let btnHeight = MeridianCalibrator.proportionalValue(48)
        let spacing = MeridianCalibrator.proportionalValue(12)
        let startY = size.height * 0.52

        // Play button
        let playBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Play",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [
                CelestialPigmentary.verdantMeadow,
                CelestialPigmentary.aquamarineSheen
            ],
            fontMagnitude: MeridianCalibrator.proportionalValue(20)
        )
        playBtn.position = CGPoint(x: size.width / 2, y: startY)
        playBtn.zPosition = 10
        playBtn.name = "embarkVoyage"
        addChild(playBtn)

        // Shop button
        let shopBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Shop",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [
                CelestialPigmentary.amberGleam,
                CelestialPigmentary.tangerineFlair
            ],
            fontMagnitude: MeridianCalibrator.proportionalValue(20)
        )
        shopBtn.position = CGPoint(x: size.width / 2, y: startY - btnHeight - spacing)
        shopBtn.zPosition = 10
        shopBtn.name = "mercantileAgora"
        addChild(shopBtn)

        // Inventory button
        let inventoryBtn = PrismForgeKit.forgeGradientButton(
            inscription: "My Items",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [
                CelestialPigmentary.orchidTwilight,
                UIColor(red: 0.40, green: 0.20, blue: 0.65, alpha: 1.0)
            ],
            fontMagnitude: MeridianCalibrator.proportionalValue(20)
        )
        inventoryBtn.position = CGPoint(x: size.width / 2, y: startY - (btnHeight + spacing) * 2)
        inventoryBtn.zPosition = 10
        inventoryBtn.name = "curioReliquary"
        addChild(inventoryBtn)

        // How to Play button
        let guideBtn = PrismForgeKit.forgeGradientButton(
            inscription: "How to Play",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [
                CelestialPigmentary.ceruleanDepth,
                CelestialPigmentary.slateUmbra
            ],
            fontMagnitude: MeridianCalibrator.proportionalValue(20)
        )
        guideBtn.position = CGPoint(x: size.width / 2, y: startY - (btnHeight + spacing) * 3)
        guideBtn.zPosition = 10
        guideBtn.name = "voyagerGuidance"
        addChild(guideBtn)
    }

    // MARK: - Record Display
    private func assembleRecordDisplay() {
        let bestEpoch = voyagerLedger.apexEpochReached
        let bestBounty = voyagerLedger.apexBountyRecord

        let recordPanel = PrismForgeKit.forgePanel(
            breadth: MeridianCalibrator.proportionalValue(260),
            altitude: MeridianCalibrator.proportionalValue(60),
            chromaArray: [
                UIColor.black.withAlphaComponent(0.3),
                UIColor.black.withAlphaComponent(0.15)
            ],
            curvature: MeridianCalibrator.proportionalValue(12)
        )
        recordPanel.position = CGPoint(x: size.width / 2, y: MeridianCalibrator.bottomSafeMargin + MeridianCalibrator.proportionalValue(50))
        recordPanel.zPosition = 10
        addChild(recordPanel)

        let trophyIcon = SKSpriteNode(imageNamed: "icon_trophy")
        let iconSize = MeridianCalibrator.proportionalValue(22)
        trophyIcon.size = CGSize(width: iconSize, height: iconSize)
        trophyIcon.position = CGPoint(x: -MeridianCalibrator.proportionalValue(100), y: 0)
        trophyIcon.zPosition = 11
        recordPanel.addChild(trophyIcon)

        let recordLabel = GlyphForgeKit.forgeLabel(
            inscription: "Best: Stage \(bestEpoch)  |  \(bestBounty) coins",
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(13),
            pigment: CelestialPigmentary.amberGleam
        )
        recordLabel.horizontalAlignmentMode = .left
        recordLabel.position = CGPoint(x: -MeridianCalibrator.proportionalValue(80), y: 0)
        recordLabel.zPosition = 11
        recordPanel.addChild(recordLabel)
    }

    // MARK: - Floating Particles
    private func assembleFloatingParticles() {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 3
        emitter.particleLifetime = 6
        emitter.particleLifetimeRange = 2
        emitter.particleSpeed = 20
        emitter.particleSpeedRange = 10
        emitter.emissionAngle = -.pi / 2
        emitter.emissionAngleRange = .pi / 4
        emitter.particleAlpha = 0.3
        emitter.particleAlphaSpeed = -0.05
        emitter.particleScale = 0.08
        emitter.particleScaleRange = 0.04
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColor = CelestialPigmentary.amberGleam
        let size2 = CGSize(width: 8, height: 8)
        let renderer = UIGraphicsImageRenderer(size: size2)
        let img = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size2))
        }
        emitter.particleTexture = SKTexture(image: img)
        emitter.position = CGPoint(x: size.width / 2, y: size.height)
        emitter.particlePositionRange = CGVector(dx: size.width, dy: 0)
        emitter.zPosition = -1
        addChild(emitter)
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        // Check for guidance dismiss first
        for node in touchedNodes {
            if let name = node.name ?? node.parent?.name, name == "dismissGuidance" || name == "Got it!" {
                dismissGuidanceOverlay()
                return
            }
        }

        // Ignore other taps if guidance is showing
        if childNode(withName: "guidanceVeil") != nil { return }

        for node in touchedNodes {
            if let name = node.name ?? node.parent?.name {
                handleButtonPress(name)
                return
            }
        }
    }

    private func handleButtonPress(_ name: String) {
        switch name {
        case "embarkVoyage", "Play":
            transitionToLabyrinth()
        case "mercantileAgora", "Shop":
            transitionToShop()
        case "curioReliquary", "My Items":
            transitionToInventory()
        case "voyagerGuidance", "How to Play":
            presentGuidanceOverlay()
        default:
            break
        }
    }

    private func transitionToLabyrinth() {
        let gameScene = LabyrinthNexus(size: self.size)
        gameScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }

    private func transitionToShop() {
        let shopScene = MercantileAgora(size: self.size)
        shopScene.scaleMode = .aspectFill
        let transition = SKTransition.push(with: .left, duration: 0.4)
        view?.presentScene(shopScene, transition: transition)
    }

    private func transitionToInventory() {
        let inventoryScene = CurioReliquary(size: self.size)
        inventoryScene.scaleMode = .aspectFill
        let transition = SKTransition.push(with: .left, duration: 0.4)
        view?.presentScene(inventoryScene, transition: transition)
    }

    // MARK: - Guidance Overlay
    private func dismissGuidanceOverlay() {
        guard let veil = childNode(withName: "guidanceVeil") else { return }
        veil.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.removeFromParent()
        ]))
    }

    private func presentGuidanceOverlay() {
        let veil = SKNode()
        veil.zPosition = 500
        veil.name = "guidanceVeil"
        addChild(veil)

        // Backdrop
        let backdrop = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.7), size: size)
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backdrop.zPosition = 500
        backdrop.alpha = 0
        veil.addChild(backdrop)
        backdrop.run(SKAction.fadeAlpha(to: 0.7, duration: 0.25))

        // Panel
        let panelWidth = size.width * 0.88
        let panelHeight = size.height * 0.72
        let panel = PrismForgeKit.forgePanel(
            breadth: panelWidth,
            altitude: panelHeight,
            chromaArray: [
                UIColor(red: 0.08, green: 0.12, blue: 0.26, alpha: 0.97),
                UIColor(red: 0.05, green: 0.08, blue: 0.20, alpha: 0.97)
            ],
            curvature: MeridianCalibrator.proportionalValue(20)
        )
        panel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        panel.zPosition = 510
        veil.addChild(panel)

        // Title
        let title = GlyphForgeKit.forgeLabel(
            inscription: "How to Play",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(24),
            pigment: CelestialPigmentary.amberGleam
        )
        title.position = CGPoint(x: 0, y: panelHeight * 0.40)
        title.zPosition = 520
        panel.addChild(title)

        // Guide text
        let guideLines = [
            "Each stage presents several doors.",
            "Only ONE door is safe — the rest are traps!",
            "",
            "Pick the safe door to advance and earn coins.",
            "The further you go, the bigger the reward.",
            "But beware — one wrong choice and you",
            "lose all coins earned this run!",
            "",
            "After each safe door, you can Cash Out",
            "to keep your coins, or risk continuing.",
            "",
            "Use items to help you survive:",
            "  Lucky Charm — adds a bonus door",
            "  X-Ray Vision — reveals one trap",
            "  Double Reward — 2x coins this stage",
            "",
            "Buy items in the Shop with your coins.",
            "How far can you go?"
        ]

        let lineHeight = MeridianCalibrator.proportionalValue(18)
        let textStartY = panelHeight * 0.32
        let fontSize = MeridianCalibrator.proportionalValue(13)

        for (i, line) in guideLines.enumerated() {
            let label = GlyphForgeKit.forgeLabel(
                inscription: line,
                fontMoniker: line.hasPrefix("  ") ? GlyphForgeKit.accentMoniker : GlyphForgeKit.bodyMoniker,
                magnitude: fontSize,
                pigment: line.isEmpty ? .clear : (line.hasPrefix("  ") ? CelestialPigmentary.amberGleam : CelestialPigmentary.ivoryWhisper)
            )
            label.position = CGPoint(x: 0, y: textStartY - CGFloat(i) * lineHeight)
            label.zPosition = 520
            panel.addChild(label)
        }

        // Close button
        let closeBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Got it!",
            breadth: MeridianCalibrator.proportionalValue(160),
            altitude: MeridianCalibrator.proportionalValue(46),
            chromaArray: [CelestialPigmentary.verdantMeadow, CelestialPigmentary.aquamarineSheen],
            fontMagnitude: MeridianCalibrator.proportionalValue(17)
        )
        closeBtn.position = CGPoint(x: 0, y: -panelHeight * 0.42)
        closeBtn.zPosition = 520
        closeBtn.name = "dismissGuidance"
        panel.addChild(closeBtn)

        // Animate in
        panel.setScale(0.3)
        panel.alpha = 0
        let scaleIn = SKAction.scale(to: 1.0, duration: 0.35)
        scaleIn.timingMode = .easeOut
        panel.run(SKAction.group([scaleIn, SKAction.fadeIn(withDuration: 0.25)]))
    }
}
