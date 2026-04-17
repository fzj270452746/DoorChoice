import SpriteKit

// MARK: - HUD Coin Display Node
final class IridescentMedallion: SKNode {

    private var coinIconNode: SKSpriteNode!
    private var coinTallyLabel: SKLabelNode!
    private var currentTally: Int = 0

    override init() {
        super.init()
        assembleConstellation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func assembleConstellation() {
        let iconSize = MeridianCalibrator.proportionalValue(24)
        coinIconNode = SKSpriteNode(imageNamed: "icon_coin")
        coinIconNode.size = CGSize(width: iconSize, height: iconSize)
        coinIconNode.position = CGPoint(x: -iconSize * 0.6, y: 0)
        coinIconNode.zPosition = 100
        addChild(coinIconNode)

        coinTallyLabel = GlyphForgeKit.forgeLabel(
            inscription: "0",
            fontMoniker: GlyphForgeKit.accentMoniker,
            magnitude: MeridianCalibrator.proportionalValue(18),
            pigment: CelestialPigmentary.amberGleam
        )
        coinTallyLabel.horizontalAlignmentMode = .left
        coinTallyLabel.position = CGPoint(x: iconSize * 0.1, y: 0)
        coinTallyLabel.zPosition = 100
        addChild(coinTallyLabel)
    }

    func refreshTally(_ newTally: Int, animated: Bool = true) {
        let oldTally = currentTally
        currentTally = newTally
        coinTallyLabel.text = "\(newTally)"

        if animated && newTally > oldTally {
            let scaleUp = SKAction.scale(to: 1.3, duration: 0.15)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.15)
            scaleUp.timingMode = .easeOut
            scaleDown.timingMode = .easeIn
            coinTallyLabel.run(SKAction.sequence([scaleUp, scaleDown]))

            let spinAction = SKAction.rotate(byAngle: .pi * 2, duration: 0.3)
            coinIconNode.run(spinAction)
        }
    }
}
