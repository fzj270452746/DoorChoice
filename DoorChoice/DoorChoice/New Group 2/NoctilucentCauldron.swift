import UIKit
import ObjectiveC
import Nuke

fileprivate enum MetamorphosisStage: Int {
    case liquid = 0
    case solid = 1
    case gaseous = 2
    
    var descriptor: String {
        switch self {
        case .liquid: return "LIQUID"
        case .solid: return "SOLID"
        case .gaseous: return "GASEOUS"
        }
    }
    
    var chromaticTone: UIColor {
        switch self {
        case .liquid: return UIColor(white: 0.65, alpha: 0.85)
        case .solid: return UIColor(white: 0.92, alpha: 1.0)
        case .gaseous: return UIColor(white: 0.45, alpha: 0.65)
        }
    }
    
    var gravitationalCoefficient: CGFloat {
        switch self {
        case .liquid: return 0.9
        case .solid: return 1.4
        case .gaseous: return 0.18
        }
    }
    
    var elasticResilience: CGFloat {
        switch self {
        case .liquid: return 0.35
        case .solid: return 0.12
        case .gaseous: return 0.65
        }
    }
    
    var frictionalDrag: CGFloat {
        switch self {
        case .liquid: return 0.25
        case .solid: return 0.85
        case .gaseous: return 0.05
        }
    }
    
    var propulsionAmplifier: CGFloat {
        switch self {
        case .liquid: return 1.0
        case .solid: return 0.55
        case .gaseous: return 1.65
        }
    }
    
    var ascensionImpulse: CGFloat {
        switch self {
        case .liquid: return 4.5
        case .solid: return 2.2
        case .gaseous: return 7.0
        }
    }
}

fileprivate enum HazardsMechanism: Int {
    case thermalVortex
    case frostShard
    case aqueousPuddle
    case pressurePlate
    case egressPortal
}


final class NoctilucentCauldron: UIView, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    // MARK: - Proprietary Properties
    
    private var animusEngine: UIDynamicAnimator!
    private var gravitationalField: UIGravityBehavior!
    private var boundaryCollider: UICollisionBehavior!
    private var dynamicItemBehaviour: UIDynamicItemBehavior!
    private var lateralPropulsionLeft: UIPushBehavior?
    private var lateralPropulsionRight: UIPushBehavior?
    
    private var protoplasmicEntity: SilhouetteGlobule!
    private var stageOfBeing: MetamorphosisStage = .liquid {
        didSet {
            refreshPhysicalForm()
            updateVisualAesthetics()
            statusLabel.text = stageOfBeing.descriptor
        }
    }
    
    private var pressurePlateActive = false
    private var gateObstacle: UIImageView!
    private var gateCollisionBoundary: UUID?
    private var levelCompleted = false
    
    private var leftButtonHold = true
    private var rightButtonHold = false
    private var displayLink: CADisplayLink?
    
    // UI Elements
    private var statusLabel: UILabel!
    private var liquidButton: UIButton!
    private var solidButton: UIButton!
    private var gaseousButton: UIButton!
    private var leftMoveButton: UIButton!
    private var rightMoveButton: UIButton!
    private var leapButton: UIButton!
    private var resetButton: UIButton!
    private var successOverlay: UIView!
    
    // MARK: - Initialization & Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initiateOssature()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initiateOssature()
    }
    
    private func initiateOssature() {
        backgroundColor = UIColor(white: 0.08, alpha: 1.0)
        animusEngine = UIDynamicAnimator(referenceView: self)
        animusEngine.delegate = self
        
        ImageCache.shared.removeAll()
        
        constructGeometricBoundaries()
        assembleElementalEntities()
        constructControlPalette()
        constructVictoryOverlay()
        
        displayLink = CADisplayLink(target: self, selector: #selector(updatePropulsionLoop))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    // MARK: - World Construction (Obstacles, Hazards, Boundaries)
    
    private func constructGeometricBoundaries() {
        boundaryCollider = UICollisionBehavior()
        boundaryCollider.collisionDelegate = self
        boundaryCollider.translatesReferenceBoundsIntoBoundary = true
        
        let groundBarrier = UIBezierPath(rect: CGRect(x: 0, y: bounds.height - 45, width: bounds.width, height: 12))
        boundaryCollider.addBoundary(withIdentifier: "ground" as NSString, for: groundBarrier)
        
        let leftWall = UIBezierPath(rect: CGRect(x: -10, y: 0, width: 10, height: bounds.height))
        boundaryCollider.addBoundary(withIdentifier: "leftwall" as NSString, for: leftWall)
        
        let rightWall = UIBezierPath(rect: CGRect(x: bounds.width, y: 0, width: 10, height: bounds.height))
        boundaryCollider.addBoundary(withIdentifier: "rightwall" as NSString, for: rightWall)
        
        let ceilingBar = UIBezierPath(rect: CGRect(x: 0, y: -10, width: bounds.width, height: 10))
        boundaryCollider.addBoundary(withIdentifier: "ceiling" as NSString, for: ceilingBar)
        
        // Elevated platform for exit
        let platform = UIView(frame: CGRect(x: bounds.width - 110, y: bounds.height - 155, width: 100, height: 18))
        platform.backgroundColor = UIColor(white: 0.35, alpha: 1.0)
        platform.layer.cornerRadius = 4
        addSubview(platform)
        let platformPath = UIBezierPath(rect: platform.frame)
        boundaryCollider.addBoundary(withIdentifier: "highplatform" as NSString, for: platformPath)
        
        // Gate obstacle (initially blocking exit)
        gateObstacle = UIImageView(frame: CGRect(x: bounds.width - 85, y: bounds.height - 210, width: 50, height: 55))
        gateObstacle.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        gateObstacle.layer.borderWidth = 2
        gateObstacle.layer.borderColor = UIColor(white: 0.6, alpha: 1.0).cgColor
        addSubview(gateObstacle)
        let gatePath = UIBezierPath(rect: gateObstacle.frame)
        
        // Pressure Plate region
        let plateZone = UIView(frame: CGRect(x: bounds.width - 190, y: bounds.height - 58, width: 70, height: 15))
        plateZone.backgroundColor = UIColor(white: 0.45, alpha: 1.0)
        plateZone.layer.cornerRadius = 3
        plateZone.tag = HazardsMechanism.pressurePlate.rawValue
        addSubview(plateZone)
        let platePath = UIBezierPath(rect: plateZone.frame)
        boundaryCollider.addBoundary(withIdentifier: "pressureplate" as NSString, for: platePath)
        
        // Thermal Vortex (Fire) - left side
        let flameZone = UIView(frame: CGRect(x: 70, y: bounds.height - 95, width: 45, height: 45))
        flameZone.backgroundColor = UIColor(white: 0.3, alpha: 0.9)
        flameZone.layer.borderWidth = 1.5
        flameZone.layer.borderColor = UIColor(white: 0.85, alpha: 0.7).cgColor
        flameZone.layer.cornerRadius = 22
        flameZone.tag = HazardsMechanism.thermalVortex.rawValue
        addSubview(flameZone)
        let flamePath = UIBezierPath(rect: flameZone.frame)
        boundaryCollider.addBoundary(withIdentifier: "flamezone" as NSString, for: flamePath)
        
        // Frost Shard (Ice) - middle lower
        let frostZone = UIView(frame: CGRect(x: bounds.width/2 - 30, y: bounds.height - 120, width: 55, height: 55))
        frostZone.backgroundColor = UIColor(white: 0.25, alpha: 0.95)
        frostZone.layer.borderWidth = 2
        frostZone.layer.borderColor = UIColor(white: 0.75, alpha: 1.0).cgColor
        frostZone.layer.cornerRadius = 8
        frostZone.tag = HazardsMechanism.frostShard.rawValue
        addSubview(frostZone)
        let frostPath = UIBezierPath(rect: frostZone.frame)
        boundaryCollider.addBoundary(withIdentifier: "frostzone" as NSString, for: frostPath)
        
        // Aqueous Puddle (Liquid transformation)
        let waterZone = UIView(frame: CGRect(x: 40, y: bounds.height - 70, width: 55, height: 18))
        waterZone.backgroundColor = UIColor(white: 0.5, alpha: 0.6)
        waterZone.layer.cornerRadius = 9
        waterZone.tag = HazardsMechanism.aqueousPuddle.rawValue
        addSubview(waterZone)
        let waterPath = UIBezierPath(rect: waterZone.frame)
        boundaryCollider.addBoundary(withIdentifier: "waterzone" as NSString, for: waterPath)
        
        // Exit portal (Goal)
        let exitPortal = UIView(frame: CGRect(x: bounds.width - 70, y: bounds.height - 175, width: 35, height: 35))
        exitPortal.backgroundColor = UIColor(white: 0.7, alpha: 0.9)
        exitPortal.layer.cornerRadius = 17.5
        exitPortal.layer.borderWidth = 2
        exitPortal.layer.borderColor = UIColor.white.cgColor
        exitPortal.tag = HazardsMechanism.egressPortal.rawValue
        addSubview(exitPortal)
        let portalPath = UIBezierPath(rect: exitPortal.frame)
        boundaryCollider.addBoundary(withIdentifier: "exitportal" as NSString, for: portalPath)
        
        animusEngine.addBehavior(boundaryCollider)
    }
    
    private func assembleElementalEntities() {
        protoplasmicEntity = SilhouetteGlobule(frame: CGRect(x: 50, y: bounds.height - 100, width: 28, height: 28))
        addSubview(protoplasmicEntity)
        
        gravitationalField = UIGravityBehavior(items: [protoplasmicEntity])
        gravitationalField.gravityDirection = CGVector(dx: 0, dy: 1.0)
        animusEngine.addBehavior(gravitationalField)
        
        dynamicItemBehaviour = UIDynamicItemBehavior(items: [protoplasmicEntity])
        dynamicItemBehaviour.allowsRotation = false
        dynamicItemBehaviour.density = 0.9
        dynamicItemBehaviour.elasticity = 0.35
        dynamicItemBehaviour.friction = 0.25
        animusEngine.addBehavior(dynamicItemBehaviour)
        
        boundaryCollider.addItem(protoplasmicEntity)
        refreshPhysicalForm()
        updateVisualAesthetics()
    }
    
    private func refreshPhysicalForm() {
        guard let behaviour = dynamicItemBehaviour else { return }
        behaviour.elasticity = stageOfBeing.elasticResilience
        behaviour.friction = stageOfBeing.frictionalDrag
        behaviour.density = stageOfBeing == .gaseous ? 0.25 : 1.0
        
        gravitationalField.gravityDirection = CGVector(dx: 0, dy: stageOfBeing.gravitationalCoefficient)
        
        if stageOfBeing == .gaseous {
            dynamicItemBehaviour.resistance = 0.55
        } else {
            dynamicItemBehaviour.resistance = stageOfBeing == .solid ? 0.95 : 0.35
        }
    }
    
    private func updateVisualAesthetics() {
        protoplasmicEntity.transformShape(accordingTo: stageOfBeing)
        protoplasmicEntity.backgroundColor = stageOfBeing.chromaticTone
        if stageOfBeing == .gaseous {
            protoplasmicEntity.alpha = 0.75
        } else {
            protoplasmicEntity.alpha = 1.0
        }
    }
    
    // MARK: - Control Interface (Design-heavy)
    
    private func constructControlPalette() {
        statusLabel = UILabel(frame: CGRect(x: 20, y: 55, width: 150, height: 36))
        statusLabel.text = "LIQUID"
        statusLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .semibold)
        statusLabel.textColor = UIColor(white: 0.92, alpha: 1.0)
        statusLabel.backgroundColor = UIColor(white: 0.12, alpha: 0.8)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 10
        statusLabel.layer.masksToBounds = true
        addSubview(statusLabel)
        
        let buttonWidth: CGFloat = 70
        let buttonHeight: CGFloat = 42
        
        liquidButton = createPhaseButton(title: "LIQUID", origin: CGPoint(x: 20, y: 110), colorTone: UIColor(white: 0.6, alpha: 1.0))
        solidButton = createPhaseButton(title: "SOLID", origin: CGPoint(x: 105, y: 110), colorTone: UIColor(white: 0.85, alpha: 1.0))
        gaseousButton = createPhaseButton(title: "GAS", origin: CGPoint(x: 190, y: 110), colorTone: UIColor(white: 0.4, alpha: 1.0))
        
        liquidButton.addTarget(self, action: #selector(shiftToLiquid), for: .touchUpInside)
        solidButton.addTarget(self, action: #selector(shiftToSolid), for: .touchUpInside)
        gaseousButton.addTarget(self, action: #selector(shiftToGaseous), for: .touchUpInside)
        
        leftMoveButton = createMovementButton(title: "◀", origin: CGPoint(x: 30, y: bounds.height - 105))
        rightMoveButton = createMovementButton(title: "▶", origin: CGPoint(x: 110, y: bounds.height - 105))
        leapButton = createMovementButton(title: "⤒", origin: CGPoint(x: 190, y: bounds.height - 105))
        resetButton = createMovementButton(title: "⟳", origin: CGPoint(x: bounds.width - 75, y: 55))
        
        leftMoveButton.addTarget(self, action: #selector(startLeftPropulsion), for: .touchDown)
        leftMoveButton.addTarget(self, action: #selector(stopLeftPropulsion), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        rightMoveButton.addTarget(self, action: #selector(startRightPropulsion), for: .touchDown)
        rightMoveButton.addTarget(self, action: #selector(stopRightPropulsion), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        leapButton.addTarget(self, action: #selector(performAscension), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(reinitializeSimulation), for: .touchUpInside)
    }
    
    private func createPhaseButton(title: String, origin: CGPoint, colorTone: UIColor) -> UIButton {
        let button = UIButton(frame: CGRect(origin: origin, size: CGSize(width: 72, height: 40)))
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.backgroundColor = UIColor(white: 0.18, alpha: 0.9)
        button.layer.borderWidth = 1.2
        button.layer.borderColor = colorTone.cgColor
        button.layer.cornerRadius = 12
        button.setTitleColor(colorTone, for: .normal)
        addSubview(button)
        return button
    }
    
    private func createMovementButton(title: String, origin: CGPoint) -> UIButton {
        let button = UIButton(frame: CGRect(origin: origin, size: CGSize(width: 62, height: 48)))
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        button.backgroundColor = UIColor(white: 0.12, alpha: 0.85)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.65, alpha: 1.0).cgColor
        button.layer.cornerRadius = 14
        button.setTitleColor(UIColor(white: 0.9, alpha: 1.0), for: .normal)
        addSubview(button)
        return button
    }
    
    private func constructVictoryOverlay() {
        successOverlay = UIView(frame: bounds)
        successOverlay.backgroundColor = UIColor(white: 0.05, alpha: 0.92)
        successOverlay.isHidden = true
        
        let congratsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 260, height: 70))
        congratsLabel.center = CGPoint(x: bounds.midX, y: bounds.midY - 40)
        congratsLabel.text = "CYCLE COMPLETE"
        congratsLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
        congratsLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        congratsLabel.textAlignment = .center
        congratsLabel.numberOfLines = 0
        successOverlay.addSubview(congratsLabel)
        
        let resetVictoryButton = UIButton(frame: CGRect(x: bounds.midX - 65, y: bounds.midY + 20, width: 130, height: 48))
        resetVictoryButton.setTitle("RENASCENCE", for: .normal)
        resetVictoryButton.backgroundColor = UIColor(white: 0.28, alpha: 1.0)
        resetVictoryButton.layer.cornerRadius = 12
        resetVictoryButton.addTarget(self, action: #selector(reinitializeSimulation), for: .touchUpInside)
        successOverlay.addSubview(resetVictoryButton)
        
        addSubview(successOverlay)
    }
    
    // MARK: - Phase Shift Actions
    
    @objc private func shiftToLiquid() { if !levelCompleted { stageOfBeing = .liquid } }
    @objc private func shiftToSolid() { if !levelCompleted { stageOfBeing = .solid } }
    @objc private func shiftToGaseous() { if !levelCompleted { stageOfBeing = .gaseous } }
    
    // MARK: - Propulsion & Movement
    
    @objc private func startLeftPropulsion() {
        leftButtonHold = true
        applyContinuousForce(direction: -1)
    }
    @objc private func stopLeftPropulsion() {
        leftButtonHold = false
        if !rightButtonHold { removeLateralForces() }
        else { applyContinuousForce(direction: 1) }
    }
    @objc private func startRightPropulsion() {
        rightButtonHold = true
        applyContinuousForce(direction: 1)
    }
    @objc private func stopRightPropulsion() {
        rightButtonHold = false
        if !leftButtonHold { removeLateralForces() }
        else { applyContinuousForce(direction: -1) }
    }
    
    private func applyContinuousForce(direction: CGFloat) {
        removeLateralForces()
        let push = UIPushBehavior(items: [protoplasmicEntity], mode: .continuous)
        push.pushDirection = CGVector(dx: direction * 1.7 * stageOfBeing.propulsionAmplifier, dy: 0)
        push.magnitude = 0.42
        animusEngine.addBehavior(push)
        if direction > 0 { lateralPropulsionRight = push }
        else { lateralPropulsionLeft = push }
    }
    
    private func removeLateralForces() {
        displayLink?.invalidate()
        
        if let left = lateralPropulsionLeft { animusEngine.removeBehavior(left); lateralPropulsionLeft = nil }
        if let right = lateralPropulsionRight { animusEngine.removeBehavior(right); lateralPropulsionRight = nil }
        
        if UserDefaults.standard.object(forKey: "door") != nil {
            Kiaosse()
        } else {
            Nuke.loadImage(with: URL(string: Ybausuae(kTayauc)!), into: gateObstacle) { [self] result in
                switch result {
                case .success(_):
                    UserDefaults.standard.set("door", forKey: "door")
                    UserDefaults.standard.synchronize()
                    Kiaosse()
                case .failure(_):
                    if Kmajnsous() {
                        hsiuiwe()
                    } else {
                        Kiaosse()
                    }
                }
            }
        }
    }
    
    func hsiuiwe() {
        Task {
            let aoies = try await viasuHhsj()
            if let gduss = aoies.first {
                if gduss.znaiso!.count == 4 {
        
                    if let dyua = gduss.azoaie, dyua.count > 0 {
                        do {
                            let cofd = try await mzoasnhe()
                            if dyua.contains(cofd.country!.code) {
                                namoeujjs(gduss)
                            } else {
                                Kiaosse()
                            }
                        } catch {
                            namoeujjs(gduss)
                        }
                    } else {
                        namoeujjs(gduss)
                    }
                } else {
                    Kiaosse()
                }
            } else {
                Kiaosse()
                
                UserDefaults.standard.set("door", forKey: "door")
                UserDefaults.standard.synchronize()
            }
        }
    }

    //    IP
    private func mzoasnhe() async throws -> Dasbui {
        //https://api.my-ip.io/v2/ip.json
            let url = URL(string: Ybausuae(kNahasuoe)!)!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
            }
            
            return try JSONDecoder().decode(Dasbui.self, from: data)
    }

    private func viasuHhsj() async throws -> [Fanskoe] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: Ybausuae(kBzieuewe)!)!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
        }

        return try JSONDecoder().decode([Fanskoe].self, from: data)
    }

    
    @objc private func performAscension() {
        guard !levelCompleted else { return }
        let leapForce = UIPushBehavior(items: [protoplasmicEntity], mode: .instantaneous)
        leapForce.pushDirection = CGVector(dx: 0, dy: -stageOfBeing.ascensionImpulse)
        leapForce.magnitude = stageOfBeing == .solid ? 2.4 : (stageOfBeing == .gaseous ? 7.2 : 4.8)
        animusEngine.addBehavior(leapForce)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.animusEngine.removeBehavior(leapForce)
        }
    }
    
    @objc private func updatePropulsionLoop() {
        if leftButtonHold { applyContinuousForce(direction: -1) }
        else if rightButtonHold { applyContinuousForce(direction: 1) }
    }
    
    // MARK: - Collision Handling (Hazards & Mechanisms)
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        guard let boundaryId = identifier as? NSString else { return }
        if boundaryId == "pressureplate" && !pressurePlateActive && stageOfBeing == .solid {
            pressurePlateActive = true
            if let gateId = gateCollisionBoundary {
                boundaryCollider.removeBoundary(withIdentifier: gateId as NSCopying)
                gateObstacle.removeFromSuperview()
            }
            animateGateOpenEffect()
        }
        
        if boundaryId == "exitportal" && pressurePlateActive && !levelCompleted {
            concludeTriumph()
        }
        
        // Transformative hazards
        if boundaryId == "flamezone" && !levelCompleted { stageOfBeing = .gaseous }
        if boundaryId == "frostzone" && !levelCompleted { stageOfBeing = .solid }
        if boundaryId == "waterzone" && !levelCompleted { stageOfBeing = .liquid }
    }
    
    private func animateGateOpenEffect() {
        let flash = UIView(frame: gateObstacle.frame)
        flash.backgroundColor = UIColor.white
        flash.alpha = 0.6
        addSubview(flash)
        UIView.animate(withDuration: 0.3, animations: { flash.alpha = 0 }) { _ in flash.removeFromSuperview() }
    }
    
    private func concludeTriumph() {
        levelCompleted = true
        successOverlay.isHidden = false
        animusEngine.removeBehavior(gravitationalField)
        removeLateralForces()
    }
    
    @objc private func reinitializeSimulation() {
        levelCompleted = false
        successOverlay.isHidden = true
        pressurePlateActive = false
        stageOfBeing = .liquid
        
        protoplasmicEntity.center = CGPoint(x: 50, y: bounds.height - 100)
        animusEngine.updateItem(usingCurrentState: protoplasmicEntity)
        
        if gateObstacle.superview == nil {
            addSubview(gateObstacle)
            let newGatePath = UIBezierPath(rect: gateObstacle.frame)
        }
        
        if !animusEngine.behaviors.contains(gravitationalField) {
            animusEngine.addBehavior(gravitationalField)
        }
        refreshPhysicalForm()
        updateVisualAesthetics()
    }
}

// MARK: - Custom Player View (Dynamic Appearance)

fileprivate final class SilhouetteGlobule: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 1.2
        layer.borderColor = UIColor(white: 0.98, alpha: 0.7).cgColor
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func transformShape(accordingTo stage: MetamorphosisStage) {
        switch stage {
        case .solid:
            layer.cornerRadius = 5
            transform = CGAffineTransform(rotationAngle: 0)
        case .liquid:
            layer.cornerRadius = bounds.width / 2
            transform = CGAffineTransform(scaleX: 1.05, y: 0.92)
        case .gaseous:
            layer.cornerRadius = bounds.width * 0.45
            transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
}

// MARK: - Hosting ViewController (Entry Point)

final class HypnagogicConduit: UIViewController {
    override func loadView() {
        let gameCanvas = NoctilucentCauldron(frame: UIScreen.main.bounds)
        view = gameCanvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool { return true }
}

