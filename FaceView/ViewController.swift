//
//  ViewController.swift
//  FaceView
//
//  Created by 悦溪 on 2018/4/27.
//  Copyright © 2018年 图图. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer:Timer? = nil
    var count:Int = 0
    
    var expression = FacialExpression(eyes: .open, mouth: .neutral){
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        switch expression.eyes {
        case .open:
            
            UIView.animate(withDuration: 3.0, animations: {
                self.faceView?.eyeOpen=true
                
            }, completion: nil)
        case .closed:
            faceView.eyeOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
    }

    private let mouthCurvature = [FacialExpression.Mouth.frown:-1.0, .smirk:-0.5, .neutral:0.0, .grin:0.5, .smile:1.0]
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            
            faceView.addGestureRecognizer(tapRecognizer)
            
            let swipeUpRecgnizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHapiness))
            swipeUpRecgnizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecgnizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHapiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            let pinchRecgnizer = UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(byReactingTo:)))
            faceView.addGestureRecognizer(pinchRecgnizer)
        }
    }
    
    @objc func increaseHapiness(){
        expression = expression.happier
    }
    
    @objc func decreaseHapiness(){
        expression = expression.sadder
    }
    
    @objc func toggleEyes(byReactingTo tapRecognizer:UITapGestureRecognizer){
        if tapRecognizer.state == .ended{
            let eyes:FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes:eyes, mouth: expression.mouth)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block:
            { (param) in
                self.count+=1
                let tmp:Double = Double(self.count)/100.0
                self.faceView.mouthCurvature = tmp
                self.faceView.setNeedsDisplay()
                
                if self.count==100{
                    param.invalidate()
                }
        } )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

