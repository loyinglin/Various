//
//  TranslateViewController.swift
//  Various
//
//  Created by 林伟池 on 16/4/7.
//  Copyright © 2016年 林伟池. All rights reserved.
//

import Foundation


class SwiftTranslateViewController: UIViewController {
    
    @IBOutlet var mySwitch:UISwitch?
    @IBOutlet var myDesc:UILabel?
    @IBOutlet var mySource:UITextView?
    @IBOutlet var myDest:UITextView?
    var myViewModel:TranslateViewModel?
    
    func UIColorFromRGB(value:Int) -> UIColor {
//        return UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let rgbValue = value
        
        return UIColor(colorLiteralRed: ((Float)((rgbValue & 0xFF00) >> 16)) / 255.0,
        green: ((Float)((rgbValue & 0xFF00) >> 8)) / 255.0,
        blue: ((Float)(rgbValue & 0xFF)) / 255.0,
        alpha: 1.0)

    }
}