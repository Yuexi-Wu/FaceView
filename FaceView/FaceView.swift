//
//  FaceView.swift
//  FaceView
//
//  Created by 悦溪 on 2018/4/27.
//  Copyright © 2018年 图图. All rights reserved.
//

import UIKit

class FaceView: UIView {
    var eyeOpen : Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var scale:CGFloat = 0.9{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var lineWidth:CGFloat=5.0//5个像素
    
    var color:UIColor=UIColor.brown

    var mouthCurvature = 0.8{
        didSet{
            setNeedsDisplay()
        }
    }//正的是笑脸，负的是哭脸
    
    private var skullCenter: CGPoint{ //包含x，y坐标，类型是CGFloat
        return CGPoint(x:bounds.midX,y:bounds.midY)
    }
    
    private var skullRadius: CGFloat{
        return min(bounds.size.width,bounds.size.height)/2*scale
    }
    
    private enum Eye{
        case left
        case right
    }
    
    @objc func changeScale(byReactingTo pinchRecgnizer:UIPinchGestureRecognizer){
        switch pinchRecgnizer.state {
        case .changed, .ended:
            scale*=pinchRecgnizer.scale
            pinchRecgnizer.scale = 1
        default:
            break
        }
    }
    
    private func centerOfEye( eye:Eye)->CGPoint{
        let eyeOffset = skullRadius/Ratios.skullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        eyeCenter.x+=((eye == .left) ? -1 : 1)*eyeOffset
        return eyeCenter
    }
    
    private func pathForEye(eye:Eye)->UIBezierPath{
        
        let eyeRadius = skullRadius/Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye: eye)
        let path: UIBezierPath
        
        if eyeOpen{
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        }else{
            path=UIBezierPath()
            path.move(to:CGPoint(x:eyeCenter.x-eyeRadius,y:eyeCenter.y))
            path.addLine(to:CGPoint(x: eyeCenter.x+eyeRadius, y: eyeCenter.y))
        }
       
        
        return path
    }
    
    private func pathForSkull()->UIBezierPath{
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius-40.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        
        return path
    }
    
    private func pathForMouth() -> UIBezierPath{

        let mouthWidth = skullRadius/Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius/Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius/Ratios.skullRadiusToMouseOffset
        
        let mouthRect = CGRect(x:skullCenter.x-mouthWidth/2,
                               y:skullCenter.y+mouthOffset,
                               width:mouthWidth,
                               height:mouthHeight
                               )//嘴的矩形
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)//嘴的起点
        let end = CGPoint(x: mouthRect.maxX, y:mouthRect.midY)//mid是为了可以完成笑脸和哭脸
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature,1)))*mouthRect.height//得到一个不小于-1，不大于1的曲率,是笑的弧度
//        let smileOffset = (0)*mouthRect.height
        
        let cp1 = CGPoint(x: start.x+mouthRect.width/3, y: start.y+smileOffset)
        
        let cp2 = CGPoint(x: end.x-mouthRect.width/3, y: start.y+smileOffset)
        
//        let cp3 = CGPoint(x: start.x+mouthRect.width/3, y: start.y+smileOffset)
        
        let path = UIBezierPath()
        
        path.move(to: start)
        
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = lineWidth
        return path
    }
    
    private struct Ratios{
        static let skullRadiusToEyeOffset:CGFloat = 5
        static let skullRadiusToEyeRadius:CGFloat = 20//圆半径和脸半径比例是十分之一
        static let skullRadiusToMouthWidth:CGFloat = 1.25
        static let skullRadiusToMouthHeight:CGFloat = 4.5
        static let skullRadiusToMouseOffset:CGFloat = 6
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.black.set()
        color.set()//把当前线条都设置为蓝色
        pathForSkull().stroke()
        UIColor.red.set()
        pathForMouth().stroke()
        UIColor.brown.set()
        pathForEye(eye: .left).stroke()
        pathForEye(eye: .right).stroke()
    }

    

}
