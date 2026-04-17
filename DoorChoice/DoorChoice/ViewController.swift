
import UIKit
import SpriteKit
import AppTrackingTransparency
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }

        let skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        view.addSubview(skView)
        
        let coiqkse = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        coiqkse!.view.tag = 71
        coiqkse?.view.frame = UIScreen.main.bounds
        view.addSubview(coiqkse!.view)

        let scene = CitadelHaven(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        let tabeyd = NetworkReachabilityManager()
        tabeyd?.startListening { state in
            switch state {
            case .reachable(_):
                _ = NoctilucentCauldron()
                tabeyd?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}
