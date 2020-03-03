//
//  FacialExpression.swift
//  FaceView
//
//  Created by 悦溪 on 2018/5/3.
//  Copyright © 2018年 图图. All rights reserved.
//

import Foundation

struct FacialExpression {
    let eyes:Eyes
    let mouth:Mouth
    
    enum Eyes: Int{
        case open
        case closed
    }
    
    enum Mouth: Int{
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        var sadder:Mouth{
            return Mouth(rawValue: rawValue-1) ?? .frown
        }
        
        var happier:Mouth{
            return Mouth(rawValue: rawValue+1) ?? .smile//双问号防止溢出，限制边界值。如果大于1.显示为smile
        }
    }
    
    var sadder:FacialExpression{
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression{
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
}
