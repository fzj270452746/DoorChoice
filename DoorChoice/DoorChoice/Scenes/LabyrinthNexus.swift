import SpriteKit

// MARK: - Main Gameplay Scene
final class LabyrinthNexus: SKScene {

    private var voyagerLedger: WayfarerLedger!
    private var zenithBar: ZenithDiadem!
    private var portcullisArray: [PortcullisEssence] = []
    private var portalNodes: [PortcullisNode] = []
    private var backgroundNode: SKSpriteNode!
    private var relicTrayNode: SKNode!
    private var interactionLocked: Bool = false
    private var clairvoyanceUsedThisEpoch: Bool = false
    private var serendipityUsedThisEpoch: Bool = false
    private var amplificationUsedThisEpoch: Bool = false
    private var accruedBountyLabel: SKLabelNode!
    private var stagePromptLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        voyagerLedger = ObsidianArchive.sharedVault.reconstituteLedger()
        voyagerLedger.resetExpedition()
        assembleAmbience()
        assembleRetreatButton()
        assembleZenithBar()
        assembleAccruedDisplay()
        assembleRelicTray()
        commenceNewEpoch()
    }

    // MARK: - Retreat Button
    private func assembleRetreatButton() {
        let btnWidth = MeridianCalibrator.proportionalValue(70)
        let btnHeight = MeridianCalibrator.proportionalValue(32)
        let backBtn = PrismForgeKit.forgeGradientButton(
            inscription: "← Exit",
            breadth: btnWidth,
            altitude: btnHeight,
            chromaArray: [CelestialPigmentary.slateUmbra, CelestialPigmentary.ceruleanDepth],
            fontMagnitude: MeridianCalibrator.proportionalValue(13)
        )
        backBtn.position = CGPoint(
            x: MeridianCalibrator.proportionalValue(50),
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(34)
        )
        backBtn.zPosition = 250
        backBtn.name = "retreatToCitadel"
        addChild(backBtn)
    }

    // MARK: - Background
    private func assembleAmbience() {
        let bgTexture = CelestialPigmentary.gradientTexture(
            colorsArray: [
                UIColor(red: 0.06, green: 0.10, blue: 0.24, alpha: 1.0),
                UIColor(red: 0.12, green: 0.08, blue: 0.26, alpha: 1.0),
                UIColor(red: 0.04, green: 0.06, blue: 0.18, alpha: 1.0)
            ],
            meridianExtent: self.size
        )
        backgroundNode = SKSpriteNode(texture: bgTexture, size: self.size)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
    }

    // MARK: - HUD
    private func assembleZenithBar() {
        zenithBar = ZenithDiadem(canvasWidth: size.width)
        zenithBar.position = CGPoint(
            x: size.width / 2,
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(34)
        )
        zenithBar.zPosition = 200
        addChild(zenithBar)
        zenithBar.refreshEpochDisplay(voyagerLedger.currentEpoch)
        zenithBar.refreshCoinDisplay(voyagerLedger.totalHoardedCoins, animated: false)
        zenithBar.refreshBestRunDisplay(voyagerLedger.apexEpochReached)
    }

    private func assembleAccruedDisplay() {
        accruedBountyLabel = GlyphForgeKit.forgeLabel(
            inscription: "Reward: 0",
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(16),
            pigment: CelestialPigmentary.amberGleam
        )
        accruedBountyLabel.position = CGPoint(
            x: size.width / 2,
            y: size.height - MeridianCalibrator.topSafeMargin - MeridianCalibrator.proportionalValue(68)
        )
        accruedBountyLabel.zPosition = 200
        addChild(accruedBountyLabel)

        stagePromptLabel = GlyphForgeKit.forgeLabel(
            inscription: "Choose a door",
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(15),
            pigment: CelestialPigmentary.ivoryWhisper
        )
        stagePromptLabel.position = CGPoint(
            x: size.width / 2,
            y: size.height * 0.78
        )
        stagePromptLabel.zPosition = 200
        stagePromptLabel.alpha = 0.8
        addChild(stagePromptLabel)
    }

    // MARK: - Relic Tray
    private func assembleRelicTray() {
        relicTrayNode = SKNode()
        relicTrayNode.position = CGPoint(
            x: size.width / 2,
            y: MeridianCalibrator.bottomSafeMargin + MeridianCalibrator.proportionalValue(50)
        )
        relicTrayNode.zPosition = 200
        addChild(relicTrayNode)
        refreshRelicTray()
    }

    private func refreshRelicTray() {
        relicTrayNode.removeAllChildren()

        let relicKinds: [ArcanaRelicKind] = [.serendipityCharm, .clairvoyanceLens, .amplificationSigil]
        let iconSize = MeridianCalibrator.proportionalValue(44)
        let spacing = MeridianCalibrator.proportionalValue(16)
        let totalWidth = CGFloat(relicKinds.count) * iconSize + CGFloat(relicKinds.count - 1) * spacing
        let startX = -totalWidth / 2 + iconSize / 2

        for (i, kind) in relicKinds.enumerated() {
            let count = voyagerLedger.relicStockpile(kind)
            let relic = ArcanaRelic(relicKind: kind, stockpileCount: count)

            let container = SKSpriteNode(color: .clear, size: CGSize(width: iconSize + 8, height: iconSize + 20))
            container.position = CGPoint(x: startX + CGFloat(i) * (iconSize + spacing), y: 0)
            container.name = "relic_\(kind.rawValue)"
            container.zPosition = 210

            // Background circle
            let bgCircle = SKShapeNode(circleOfRadius: iconSize / 2 + 2)
            bgCircle.fillColor = count > 0
                ? UIColor.white.withAlphaComponent(0.12)
                : UIColor.black.withAlphaComponent(0.3)
            bgCircle.strokeColor = count > 0
                ? CelestialPigmentary.amberGleam.withAlphaComponent(0.5)
                : CelestialPigmentary.slateUmbra.withAlphaComponent(0.3)
            bgCircle.lineWidth = 1.5
            bgCircle.position = CGPoint(x: 0, y: 4)
            bgCircle.zPosition = 0
            container.addChild(bgCircle)

            let icon = SKSpriteNode(imageNamed: relic.iconAssetMoniker)
            icon.size = CGSize(width: iconSize * 0.7, height: iconSize * 0.7)
            icon.position = CGPoint(x: 0, y: 4)
            icon.zPosition = 1
            icon.alpha = count > 0 ? 1.0 : 0.35
            container.addChild(icon)

            let countLabel = GlyphForgeKit.forgeLabel(
                inscription: "x\(count)",
                fontMoniker: GlyphForgeKit.captionMoniker,
                magnitude: MeridianCalibrator.proportionalValue(11),
                pigment: count > 0 ? CelestialPigmentary.amberGleam : CelestialPigmentary.slateUmbra
            )
            countLabel.position = CGPoint(x: 0, y: -iconSize / 2 - 4)
            countLabel.zPosition = 1
            container.addChild(countLabel)

            relicTrayNode.addChild(container)
        }
    }

    // MARK: - New Epoch
    private func commenceNewEpoch() {
        interactionLocked = true
        clairvoyanceUsedThisEpoch = false
        serendipityUsedThisEpoch = false
        amplificationUsedThisEpoch = false

        // Clear old doors
        for node in portalNodes {
            node.removeFromParent()
        }
        portalNodes.removeAll()

        zenithBar.refreshEpochDisplay(voyagerLedger.currentEpoch)
        accruedBountyLabel.text = "Reward: \(voyagerLedger.accruedBounty)"
        stagePromptLabel.text = "Stage \(voyagerLedger.currentEpoch) — Choose a door"
        refreshRelicTray()

        // Generate doors
        let portalCount = voyagerLedger.portalCountForEpoch
        portcullisArray = AugurArbiter.sharedOracle.conjurePortcullisArray(
            portalCount: portalCount,
            serendipityActive: false
        )

        arrangePortcullisNodes()

        // Animate doors in
        for (i, node) in portalNodes.enumerated() {
            node.alpha = 0
            node.setScale(0.5)
            let delay = SKAction.wait(forDuration: Double(i) * 0.08)
            let fadeIn = SKAction.fadeIn(withDuration: 0.25)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
            scaleUp.timingMode = .easeOut
            node.run(SKAction.sequence([delay, SKAction.group([fadeIn, scaleUp])])) {
                node.beginIdleOscillation()
            }
        }

        // Unlock after animation
        let totalDelay = Double(portalNodes.count) * 0.08 + 0.35
        run(SKAction.wait(forDuration: totalDelay)) { [weak self] in
            self?.interactionLocked = false
        }
    }

    // MARK: - Door Layout
    private func arrangePortcullisNodes() {
        let portalCount = portcullisArray.count
        let columns = MeridianCalibrator.doorColumnsForStage(portalCount)
        let rows = Int(ceil(Double(portalCount) / Double(columns)))
        let doorSize = MeridianCalibrator.portalDimension(forCount: portalCount)
        let hSpacing = MeridianCalibrator.proportionalValue(14)
        let vSpacing = MeridianCalibrator.proportionalValue(18)

        let totalGridWidth = CGFloat(columns) * doorSize.width + CGFloat(columns - 1) * hSpacing
        let totalGridHeight = CGFloat(rows) * doorSize.height + CGFloat(rows - 1) * vSpacing
        let gridCenterY = size.height * 0.48
        let _ = (size.width - totalGridWidth) / 2 + doorSize.width / 2
        let gridStartY = gridCenterY + totalGridHeight / 2 - doorSize.height / 2

        for (index, essence) in portcullisArray.enumerated() {
            let row = index / columns
            let col = index % columns

            // Center last row if not full
            let itemsInRow = min(columns, portalCount - row * columns)
            let rowWidth = CGFloat(itemsInRow) * doorSize.width + CGFloat(itemsInRow - 1) * hSpacing
            let rowStartX = (size.width - rowWidth) / 2 + doorSize.width / 2

            let x = rowStartX + CGFloat(col) * (doorSize.width + hSpacing)
            let y = gridStartY - CGFloat(row) * (doorSize.height + vSpacing)

            let node = PortcullisNode(essenceData: essence, dimension: doorSize)
            node.position = CGPoint(x: x, y: y)
            addChild(node)
            portalNodes.append(node)
        }
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        // Check retreat button (always responsive)
        for node in touchedNodes {
            if let name = node.name ?? node.parent?.name, name == "retreatToCitadel" || name == "← Exit" {
                returnToCitadel()
                return
            }
        }

        guard !interactionLocked else { return }

        // Check relic tray
        for node in touchedNodes {
            if let name = node.name ?? node.parent?.name, name.hasPrefix("relic_") {
                let relicRaw = String(name.dropFirst(6))
                if let kind = ArcanaRelicKind(rawValue: relicRaw) {
                    activateRelic(kind)
                    return
                }
            }
        }

        // Check doors
        for node in touchedNodes {
            if let portalNode = node as? PortcullisNode {
                handlePortalSelection(portalNode)
                return
            }
            if let parent = node.parent as? PortcullisNode {
                handlePortalSelection(parent)
                return
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for node in portalNodes {
            if node.contains(location) {
                node.applyHoverGleam()
            } else {
                node.removeHoverGleam()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for node in portalNodes {
            node.removeHoverGleam()
        }
    }

    // MARK: - Relic Activation
    private func activateRelic(_ kind: ArcanaRelicKind) {
        switch kind {
        case .serendipityCharm:
            guard !serendipityUsedThisEpoch else { return }
            guard voyagerLedger.expendRelic(.serendipityCharm) else { return }
            serendipityUsedThisEpoch = true
            // Regenerate doors with a lucky door
            regenerateWithSerendipity()

        case .clairvoyanceLens:
            guard !clairvoyanceUsedThisEpoch else { return }
            guard voyagerLedger.expendRelic(.clairvoyanceLens) else { return }
            clairvoyanceUsedThisEpoch = true
            if let targetIndex = AugurArbiter.sharedOracle.selectClairvoyanceTarget(from: portcullisArray) {
                portalNodes[targetIndex].brandDangerInsignia()
            }

        case .amplificationSigil:
            guard !amplificationUsedThisEpoch else { return }
            guard voyagerLedger.expendRelic(.amplificationSigil) else { return }
            amplificationUsedThisEpoch = true
            voyagerLedger.amplificationActiveFlag = true
        }

        ObsidianArchive.sharedVault.synchronizeLedger(voyagerLedger)
        refreshRelicTray()
    }

    private func regenerateWithSerendipity() {
        interactionLocked = true
        for node in portalNodes {
            node.ceaseIdleOscillation()
            node.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.2),
                SKAction.removeFromParent()
            ]))
        }
        portalNodes.removeAll()

        run(SKAction.wait(forDuration: 0.3)) { [weak self] in
            guard let self = self else { return }
            let portalCount = self.voyagerLedger.portalCountForEpoch
            self.portcullisArray = AugurArbiter.sharedOracle.conjurePortcullisArray(
                portalCount: portalCount,
                serendipityActive: true
            )
            self.arrangePortcullisNodes()
            for (i, node) in self.portalNodes.enumerated() {
                node.alpha = 0
                node.setScale(0.5)
                let delay = SKAction.wait(forDuration: Double(i) * 0.06)
                let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                let scaleUp = SKAction.scale(to: 1.0, duration: 0.25)
                node.run(SKAction.sequence([delay, SKAction.group([fadeIn, scaleUp])])) {
                    node.beginIdleOscillation()
                }
            }
            let totalDelay = Double(self.portalNodes.count) * 0.06 + 0.3
            self.run(SKAction.wait(forDuration: totalDelay)) { [weak self] in
                self?.interactionLocked = false
            }
        }
    }

    // MARK: - Door Selection
    private func handlePortalSelection(_ portalNode: PortcullisNode) {
        interactionLocked = true
        let essence = portalNode.essenceData

        for node in portalNodes {
            node.ceaseIdleOscillation()
        }

        portalNode.unveilPortcullis { [weak self] in
            guard let self = self else { return }

            if essence.isSanctuary {
                self.handleSanctuaryOutcome()
            } else if essence.isFortuneBlessing {
                self.handleFortuneOutcome()
            } else {
                self.handlePerilOutcome(essence: essence)
            }
        }
    }

    // MARK: - Outcomes
    private func handleSanctuaryOutcome() {
        let reward = voyagerLedger.epochBountyReward
        voyagerLedger.advanceEpoch()
        accruedBountyLabel.text = "Reward: \(voyagerLedger.accruedBounty)"

        // Coin particle
        let coinEmitter = KineticWeaveKit.coinBurstEmitter()
        coinEmitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        coinEmitter.zPosition = 300
        addChild(coinEmitter)
        coinEmitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.removeFromParent()
        ]))

        let veil = EtherealVeil(canvasExtent: size)
        veil.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(veil)

        veil.presentSanctuaryOutcome(
            epoch: voyagerLedger.currentEpoch - 1,
            rewardCoins: reward,
            totalAccrued: voyagerLedger.accruedBounty,
            onContinueTapped: { [weak self] in
                self?.commenceNewEpoch()
            },
            onCashOutTapped: { [weak self] in
                self?.executeCashOut()
            }
        )
    }

    private func handleFortuneOutcome() {
        let bonusCoins = BountyReaper.sharedCollector.fortuneBlessingBounty()
        voyagerLedger.accruedBounty += bonusCoins
        voyagerLedger.advanceEpoch()
        accruedBountyLabel.text = "Reward: \(voyagerLedger.accruedBounty)"

        let fortuneEmitter = KineticWeaveKit.coinBurstEmitter()
        fortuneEmitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        fortuneEmitter.zPosition = 300
        addChild(fortuneEmitter)
        fortuneEmitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.removeFromParent()
        ]))

        let veil = EtherealVeil(canvasExtent: size)
        veil.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(veil)

        veil.presentFortuneBounty(
            bonusCoins: bonusCoins,
            onContinueTapped: { [weak self] in
                self?.commenceNewEpoch()
            }
        )
    }

    private func handlePerilOutcome(essence: PortcullisEssence) {
        // Explosion effect
        let emitter = KineticWeaveKit.explosionBurstEmitter()
        emitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        emitter.zPosition = 300
        addChild(emitter)
        emitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.2),
            SKAction.removeFromParent()
        ]))

        // Screen shake
        let shakeAction = SKAction.sequence([
            SKAction.moveBy(x: -8, y: 0, duration: 0.04),
            SKAction.moveBy(x: 16, y: 0, duration: 0.04),
            SKAction.moveBy(x: -16, y: 0, duration: 0.04),
            SKAction.moveBy(x: 8, y: 0, duration: 0.04)
        ])
        backgroundNode.run(SKAction.repeat(shakeAction, count: 3))

        let coinsLost = voyagerLedger.accruedBounty
        let epochReached = voyagerLedger.currentEpoch
        voyagerLedger.forfeitExpedition()
        ObsidianArchive.sharedVault.synchronizeLedger(voyagerLedger)
        ObsidianArchive.sharedVault.incrementExpeditionTally()

        run(SKAction.wait(forDuration: 0.6)) { [weak self] in
            guard let self = self else { return }
            let veil = EtherealVeil(canvasExtent: self.size)
            veil.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            self.addChild(veil)

            veil.presentPerilOutcome(
                essence: essence,
                coinsLost: coinsLost,
                epochReached: epochReached,
                onRetryTapped: { [weak self] in
                    self?.restartExpedition()
                },
                onMenuTapped: { [weak self] in
                    self?.returnToCitadel()
                }
            )
        }
    }

    // MARK: - Cash Out
    private func executeCashOut() {
        voyagerLedger.cashOutBounty()
        ObsidianArchive.sharedVault.synchronizeLedger(voyagerLedger)
        ObsidianArchive.sharedVault.incrementExpeditionTally()
        returnToCitadel()
    }

    // MARK: - Navigation
    private func restartExpedition() {
        voyagerLedger = ObsidianArchive.sharedVault.reconstituteLedger()
        voyagerLedger.resetExpedition()
        zenithBar.refreshCoinDisplay(voyagerLedger.totalHoardedCoins, animated: false)
        zenithBar.refreshBestRunDisplay(voyagerLedger.apexEpochReached)
        commenceNewEpoch()
    }

    private func returnToCitadel() {
        let menuScene = CitadelHaven(size: self.size)
        menuScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(menuScene, transition: transition)
    }
}
