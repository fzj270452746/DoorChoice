import SpriteKit

// MARK: - Top HUD Bar
final class ZenithDiadem: SKNode {

    private var epochLabel: SKLabelNode!
    private var coinMedallion: IridescentMedallion!
    private var trophyNode: SKSpriteNode!
    private var bestRunLabel: SKLabelNode!
    private var backdropNode: SKSpriteNode!

    private let canvasWidth: CGFloat

    init(canvasWidth: CGFloat) {
        self.canvasWidth = canvasWidth
        super.init()
        assembleConstellation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func assembleConstellation() {
        let barHeight = MeridianCalibrator.proportionalValue(56)
        let texture = CelestialPigmentary.gradientTexture(
            colorsArray: [
                UIColor.black.withAlphaComponent(0.5),
                UIColor.black.withAlphaComponent(0.2)
            ],
            meridianExtent: CGSize(width: canvasWidth, height: barHeight)
        )
        backdropNode = SKSpriteNode(texture: texture, size: CGSize(width: canvasWidth, height: barHeight))
        backdropNode.position = .zero
        backdropNode.zPosition = 90
        addChild(backdropNode)

        // Epoch label (center)
        epochLabel = GlyphForgeKit.forgeLabel(
            inscription: "Stage 1",
            fontMoniker: GlyphForgeKit.headlineMoniker,
            magnitude: MeridianCalibrator.proportionalValue(18),
            pigment: CelestialPigmentary.ivoryWhisper
        )
        epochLabel.horizontalAlignmentMode = .center
        epochLabel.position = CGPoint(x: 0, y: 0)
        epochLabel.zPosition = 100
        addChild(epochLabel)

        // Trophy + best run (far right)
        let iconSize = MeridianCalibrator.proportionalValue(20)
        trophyNode = SKSpriteNode(imageNamed: "icon_trophy")
        trophyNode.size = CGSize(width: iconSize, height: iconSize)
        trophyNode.position = CGPoint(x: canvasWidth / 2 - MeridianCalibrator.proportionalValue(40), y: 0)
        trophyNode.zPosition = 100
        addChild(trophyNode)

        bestRunLabel = GlyphForgeKit.forgeLabel(
            inscription: "0",
            fontMoniker: GlyphForgeKit.captionMoniker,
            magnitude: MeridianCalibrator.proportionalValue(14),
            pigment: CelestialPigmentary.amberGleam
        )
        bestRunLabel.horizontalAlignmentMode = .left
        bestRunLabel.position = CGPoint(x: canvasWidth / 2 - MeridianCalibrator.proportionalValue(26), y: 0)
        bestRunLabel.zPosition = 100
        addChild(bestRunLabel)

        // Coin display (right, left of trophy)
        coinMedallion = IridescentMedallion()
        coinMedallion.position = CGPoint(x: canvasWidth / 2 - MeridianCalibrator.proportionalValue(110), y: 0)
        coinMedallion.zPosition = 100
        addChild(coinMedallion)
    }

    func refreshEpochDisplay(_ epoch: Int) {
        epochLabel.text = "Stage \(epoch)"
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.15)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.15)
        epochLabel.run(SKAction.sequence([scaleUp, scaleDown]))
    }

    func refreshCoinDisplay(_ coins: Int, animated: Bool = true) {
        coinMedallion.refreshTally(coins, animated: animated)
    }

    func refreshBestRunDisplay(_ bestEpoch: Int) {
        bestRunLabel.text = "\(bestEpoch)"
    }
}
