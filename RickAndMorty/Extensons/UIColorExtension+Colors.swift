//
//  UIColorExtension+Colors.swift
//  RickAndMorty
//
//  Created by Filip Varda on 28.01.2023..
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

struct RMColors {
    static let green1 = UIColor(rgb: 0x69AD53)
    static let green2 = UIColor(rgb: 0x314E1C)
}
