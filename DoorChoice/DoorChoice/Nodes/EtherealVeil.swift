import SpriteKit

// MARK: - Custom Modal Overlay
final class EtherealVeil: SKNode {

    private var obscuraBackdrop: SKSpriteNode!
    private var dialoguePanel: SKSpriteNode!
    private var canvasExtent: CGSize

    var onDismissCallback: (() -> Void)?

    init(canvasExtent: CGSize) {
        self.canvasExtent = canvasExtent
        super.init()
        self.zPosition = 500
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Danger Result Dialog
    func presentPerilOutcome(
        essence: PortcullisEssence,
        coinsLost: Int,
        epochReached: Int,
        onRetryTapped: @escaping () -> Void,
        onMenuTapped: @escaping () -> Void
    ) {
        assembleObscura()

        let panelWidth = canvasExtent.width * 0.85
        let panelHeight = canvasExtent.height * 0.55
        dialoguePanel = PrismForgeKit.forgePanel(
            breadth: panelWidth,
            altitude: panelHeight,
            chromaArray: [
                UIColor(red: 0.14, green: 0.18, blue: 0.32, alpha: 0.95),
                UIColor(red: 0.08, green: 0.10, blue: 0.22, alpha: 0.95)
            ],
            curvature: MeridianCalibrator.proportionalValue(24)
        )
        dialoguePanel.position = CGPoint(x: 0, y: 0)
        dialoguePanel.zPosition = 510
        addChild(dialoguePanel)

        // Danger image
        let dangerSprite = SKSpriteNode(imageNamed: essence.revealedAssetMoniker)
        let imgSize = MeridianCalibrator.proportionalValue(100)
        dangerSprite.size = CGSize(width: imgSize, height: imgSize * 1.2)
        dangerSprite.position = CGPoint(x: 0, y: panelHeight * 0.22)
        dangerSprite.zPosition = 520
        dialoguePanel.addChild(dangerSprite)

        // Title
        let titleLabel = GlyphForgeKit.forgeLabel(
            inscription: essence.perilCaption,
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(24),
            pigment: CelestialPigmentary.crimsomEmber
        )
        titleLabel.position = CGPoint(x: 0, y: panelHeight * 0.02)
        titleLabel.zPosition = 520
        dialoguePanel.addChild(titleLabel)

        // Subtitle
        let subtitleLabel = GlyphForgeKit.forgeLabel(
            inscription: essence.perilSubCaption,
            fontMoniker: GlyphForgeKit.bodyMoniker,
            magnitude: MeridianCalibrator.proportionalValue(14),
            pigment: CelestialPigmentary.ivoryWhisper
        )
        subtitleLabel.numberOfLines = 0
        subtitleLabel.preferredMaxLayoutWidth = panelWidth * 0.8
        subtitleLabel.position = CGPoint(x: 0, y: -panelHeight * 0.08)
        subtitleLabel.zPosition = 520
        dialoguePanel.addChild(subtitleLabel)

        // Stats line
        let statsLabel = GlyphForgeKit.forgeLabel(
            inscription: "Reached Stage \(epochReached)  |  Coins Lost: \(coinsLost)",
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(13),
            pigment: CelestialPigmentary.slateUmbra
        )
        statsLabel.position = CGPoint(x: 0, y: -panelHeight * 0.18)
        statsLabel.zPosition = 520
        dialoguePanel.addChild(statsLabel)

        // Retry button
        let btnWidth = MeridianCalibrator.proportionalValue(180)
        let btnHeight = MeridianCalibrator.proportionalValue(48)
        let retryBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Try Again",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [CelestialPigmentary.aquamarineSheen, CelestialPigmentary.verdantMeadow],
            fontMagnitude: MeridianCalibrator.proportionalValue(17)
        )
        retryBtn.position = CGPoint(x: 0, y: -panelHeight * 0.27)
        retryBtn.zPosition = 520
        retryBtn.name = "retryPortcullis"
        dialoguePanel.addChild(retryBtn)

        // Menu button
        let menuBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Main Menu",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [CelestialPigmentary.orchidTwilight, CelestialPigmentary.ceruleanDepth],
            fontMagnitude: MeridianCalibrator.proportionalValue(17)
        )
        menuBtn.position = CGPoint(x: 0, y: -panelHeight * 0.42)
        menuBtn.zPosition = 520
        menuBtn.name = "menuPortcullis"
        dialoguePanel.addChild(menuBtn)

        // Animate in
        dialoguePanel.setScale(0.3)
        dialoguePanel.alpha = 0
        let scaleIn = SKAction.scale(to: 1.0, duration: 0.35)
        scaleIn.timingMode = .easeOut
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        dialoguePanel.run(SKAction.group([scaleIn, fadeIn]))

        self.onRetryHandler = onRetryTapped
        self.onMenuHandler = onMenuTapped
    }

    // MARK: - Safe Passage Dialog
    func presentSanctuaryOutcome(
        epoch: Int,
        rewardCoins: Int,
        totalAccrued: Int,
        onContinueTapped: @escaping () -> Void,
        onCashOutTapped: @escaping () -> Void
    ) {
        assembleObscura()

        let panelWidth = canvasExtent.width * 0.85
        let panelHeight = canvasExtent.height * 0.50
        dialoguePanel = PrismForgeKit.forgePanel(
            breadth: panelWidth,
            altitude: panelHeight,
            chromaArray: [
                UIColor(red: 0.10, green: 0.22, blue: 0.18, alpha: 0.95),
                UIColor(red: 0.06, green: 0.14, blue: 0.12, alpha: 0.95)
            ],
            curvature: MeridianCalibrator.proportionalValue(24)
        )
        dialoguePanel.position = CGPoint(x: 0, y: 0)
        dialoguePanel.zPosition = 510
        addChild(dialoguePanel)

        // Safe image
        let safeSprite = SKSpriteNode(imageNamed: "door_safe_open")
        let imgSize = MeridianCalibrator.proportionalValue(90)
        safeSprite.size = CGSize(width: imgSize, height: imgSize * 1.2)
        safeSprite.position = CGPoint(x: 0, y: panelHeight * 0.24)
        safeSprite.zPosition = 520
        dialoguePanel.addChild(safeSprite)

        // Title
        let titleLabel = GlyphForgeKit.forgeLabel(
            inscription: "Safe Passage!",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(24),
            pigment: CelestialPigmentary.verdantMeadow
        )
        titleLabel.position = CGPoint(x: 0, y: panelHeight * 0.06)
        titleLabel.zPosition = 520
        dialoguePanel.addChild(titleLabel)

        // Reward info
        let rewardLabel = GlyphForgeKit.forgeLabel(
            inscription: "+\(rewardCoins) coins",
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(20),
            pigment: CelestialPigmentary.amberGleam
        )
        rewardLabel.position = CGPoint(x: 0, y: -panelHeight * 0.04)
        rewardLabel.zPosition = 520
        dialoguePanel.addChild(rewardLabel)

        // Total accrued
        let totalLabel = GlyphForgeKit.forgeLabel(
            inscription: "Total: \(totalAccrued) coins",
            fontMoniker: GlyphForgeKit.bodyMoniker,
            magnitude: MeridianCalibrator.proportionalValue(16),
            pigment: CelestialPigmentary.ivoryWhisper
        )
        totalLabel.position = CGPoint(x: 0, y: -panelHeight * 0.13)
        totalLabel.zPosition = 520
        dialoguePanel.addChild(totalLabel)

        // Continue button
        let btnWidth = MeridianCalibrator.proportionalValue(180)
        let btnHeight = MeridianCalibrator.proportionalValue(48)
        let continueBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Continue",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [CelestialPigmentary.verdantMeadow, CelestialPigmentary.aquamarineSheen],
            fontMagnitude: MeridianCalibrator.proportionalValue(17)
        )
        continueBtn.position = CGPoint(x: 0, y: -panelHeight * 0.24)
        continueBtn.zPosition = 520
        continueBtn.name = "continuePortcullis"
        dialoguePanel.addChild(continueBtn)

        // Cash Out button
        let cashOutBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Cash Out (\(totalAccrued))",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [CelestialPigmentary.amberGleam, CelestialPigmentary.tangerineFlair],
            fontMagnitude: MeridianCalibrator.proportionalValue(17)
        )
        cashOutBtn.position = CGPoint(x: 0, y: -panelHeight * 0.39)
        cashOutBtn.zPosition = 520
        cashOutBtn.name = "cashOutPortcullis"
        dialoguePanel.addChild(cashOutBtn)

        // Animate in
        dialoguePanel.setScale(0.3)
        dialoguePanel.alpha = 0
        let scaleIn = SKAction.scale(to: 1.0, duration: 0.35)
        scaleIn.timingMode = .easeOut
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        dialoguePanel.run(SKAction.group([scaleIn, fadeIn]))

        self.onContinueHandler = onContinueTapped
        self.onCashOutHandler = onCashOutTapped
    }

    // MARK: - Lucky Bonus Dialog
    func presentFortuneBounty(
        bonusCoins: Int,
        onContinueTapped: @escaping () -> Void
    ) {
        assembleObscura()

        let panelWidth = canvasExtent.width * 0.80
        let panelHeight = canvasExtent.height * 0.38
        dialoguePanel = PrismForgeKit.forgePanel(
            breadth: panelWidth,
            altitude: panelHeight,
            chromaArray: [
                UIColor(red: 0.22, green: 0.18, blue: 0.06, alpha: 0.95),
                UIColor(red: 0.14, green: 0.12, blue: 0.04, alpha: 0.95)
            ],
            curvature: MeridianCalibrator.proportionalValue(24)
        )
        dialoguePanel.position = CGPoint(x: 0, y: 0)
        dialoguePanel.zPosition = 510
        addChild(dialoguePanel)

        let luckySprite = SKSpriteNode(imageNamed: "door_lucky_open")
        let imgSize = MeridianCalibrator.proportionalValue(80)
        luckySprite.size = CGSize(width: imgSize, height: imgSize * 1.2)
        luckySprite.position = CGPoint(x: 0, y: panelHeight * 0.22)
        luckySprite.zPosition = 520
        dialoguePanel.addChild(luckySprite)

        let titleLabel = GlyphForgeKit.forgeLabel(
            inscription: "Lucky Bonus!",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(22),
            pigment: CelestialPigmentary.amberGleam
        )
        titleLabel.position = CGPoint(x: 0, y: panelHeight * 0.0)
        titleLabel.zPosition = 520
        dialoguePanel.addChild(titleLabel)

        let bonusLabel = GlyphForgeKit.forgeLabel(
            inscription: "+\(bonusCoins) coins!",
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(20),
            pigment: CelestialPigmentary.amberGleam
        )
        bonusLabel.position = CGPoint(x: 0, y: -panelHeight * 0.12)
        bonusLabel.zPosition = 520
        dialoguePanel.addChild(bonusLabel)

        let btnWidth = MeridianCalibrator.proportionalValue(160)
        let btnHeight = MeridianCalibrator.proportionalValue(46)
        let continueBtn = PrismForgeKit.forgeGradientButton(
            inscription: "Continue",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [CelestialPigmentary.amberGleam, CelestialPigmentary.tangerineFlair],
            fontMagnitude: MeridianCalibrator.proportionalValue(17)
        )
        continueBtn.position = CGPoint(x: 0, y: -panelHeight * 0.30)
        continueBtn.zPosition = 520
        continueBtn.name = "fortuneContinue"
        dialoguePanel.addChild(continueBtn)

        dialoguePanel.setScale(0.3)
        dialoguePanel.alpha = 0
        let scaleIn = SKAction.scale(to: 1.0, duration: 0.35)
        scaleIn.timingMode = .easeOut
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        dialoguePanel.run(SKAction.group([scaleIn, fadeIn]))

        self.onFortuneContinueHandler = onContinueTapped
    }

    // MARK: - Obscura Backdrop
    private func assembleObscura() {
        obscuraBackdrop = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: canvasExtent)
        obscuraBackdrop.position = .zero
        obscuraBackdrop.zPosition = 500
        obscuraBackdrop.alpha = 0
        addChild(obscuraBackdrop)
        obscuraBackdrop.run(SKAction.fadeAlpha(to: 0.6, duration: 0.25))
    }

    // MARK: - Dismiss
    func dissolveVeil(completion: (() -> Void)? = nil) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let scaleDown = SKAction.scale(to: 0.5, duration: 0.25)
        dialoguePanel?.run(SKAction.group([fadeOut, scaleDown]))
        obscuraBackdrop?.run(fadeOut) { [weak self] in
            self?.removeFromParent()
            completion?()
        }
    }

    // MARK: - Touch Handling
    private var onRetryHandler: (() -> Void)?
    private var onMenuHandler: (() -> Void)?
    private var onContinueHandler: (() -> Void)?
    private var onCashOutHandler: (() -> Void)?
    private var onFortuneContinueHandler: (() -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        for node in touchedNodes {
            if let name = node.name ?? node.parent?.name {
                switch name {
                case "retryPortcullis", "Try Again":
                    dissolveVeil { [weak self] in self?.onRetryHandler?() }
                    return
                case "menuPortcullis", "Main Menu":
                    dissolveVeil { [weak self] in self?.onMenuHandler?() }
                    return
                case "continuePortcullis", "Continue":
                    dissolveVeil { [weak self] in self?.onContinueHandler?() }
                    return
                case let n where n.hasPrefix("cashOutPortcullis") || n.hasPrefix("Cash Out"):
                    dissolveVeil { [weak self] in self?.onCashOutHandler?() }
                    return
                case "fortuneContinue":
                    dissolveVeil { [weak self] in self?.onFortuneContinueHandler?() }
                    return
                default:
                    break
                }
            }
        }
    }
}
