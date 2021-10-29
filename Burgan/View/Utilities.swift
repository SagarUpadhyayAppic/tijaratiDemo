//
//  Utilities.swift
//  Burgan
//
//  Created by Malti Maurya on 17/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
extension UIFont {
    
    public enum Urdu: String{
        
          case regular = "-Regular"
    }

    public enum Frutiger: String {
        case bold = "Bold"
        case light = "Light"
         case roman = "Roman"

    }

    static func Frutig(_ type: Frutiger = .roman, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Frutiger\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}
extension CGFloat{
    struct CornerRadius{
        struct button
        {
            static let radius : CGFloat = 8
        }
        struct popup {
            static let radius : CGFloat = 10
        }
        struct cardview {
            static let radius : CGFloat = 8
        }
    }
}

extension UIColor {
    struct BurganColor {
        struct brandWhite {
            
            static let white = UIColor.init(netHex: 0xFFFFFF)
            static let white2 = UIColor(netHex: 0xF8F9F9)
            static let white3 = UIColor(netHex: 0xDFE6EB)

            

        }
        
        struct brandGray {
            
            static let dark = UIColor.init(netHex: 0x707070)
            static let medium = UIColor.init(netHex: 0x7A8890)
            static let headlines = UIColor.init(netHex: 0x263238)
            static let black = UIColor.init(netHex: 0x000000)
            static let lgiht = UIColor.init(netHex: 0xBCC3C7)
            static let light = UIColor.init(netHex: 0xBFCEDB)
            static let disable = UIColor.init(netHex: 0x7F9DB8)

            

        }
        
        struct brandBlue {
            static let verydark = UIColor.init(netHex: 0x003b71)
            static let dark = UIColor.init(netHex: 0x005499)
            static let medium = UIColor.init(netHex: 0x0065A6)
            static let black = UIColor.init(netHex: 0x000000)
            static let light = UIColor.init(netHex: 0x7CB0C8)
            static let veryLight = UIColor.init(netHex: 0xB0DAEA)
            static let purple = UIColor.init(netHex: 0x3758BF)






        }
        
        struct brandYellow {
            static let veryLight = UIColor.init(netHex: 0xF7F2E0)
            static let light = UIColor.init(netHex: 0xF5E2BF)
            static let medium = UIColor.init(netHex: 0xf3c474)
            static let dark = UIColor.init(netHex: 0xFFAA00)





        }
        
        struct brandRed {
            static let red = UIColor.init(netHex: 0xFF4D2A)
            static let lightRed = UIColor.init(netHex: 0xF7D3CC)

        }
        
        struct brandOrange {
            static let orange = UIColor.init(netHex: 0xEE7910)
            static let lightOrange = UIColor.init(netHex: 0xF4DCC7)

        }
        
        struct brandGreen {
            static let green = UIColor.init(netHex: 0x16B091)
            static let lightGreen = UIColor.init(hexString: "16B091", alpha: 0.2)

        }
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
