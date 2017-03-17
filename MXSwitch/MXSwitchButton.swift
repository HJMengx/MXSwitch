//
//  MXSwitchButton.swift
//  MXSwitch
//
//  Created by mx on 2017/3/15.
//  Copyright © 2017年 mengx. All rights reserved.
//

import UIKit

func colorWith(red : CGFloat,green : CGFloat,blue : CGFloat)->UIColor{
    return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
}

let disableColor = colorWith(red: 231.0, green: 231.0, blue: 231.0)

let enableColor = colorWith(red: 210.0, green: 252.0, blue: 222.0)

enum MXSwitchButtonType {
    case disable
    case enable
}

protocol MXSwitchButtonDelegate {
    func switchButton(button : MXSwitchButton,type : MXSwitchButtonType)
}

class MXSwitchButton: UIView {
    
    var delegate : MXSwitchButtonDelegate!
    
    var superviewEndPosition : CGPoint!
    
    fileprivate var isEnable : Bool = false
    
    fileprivate var leftEyeLayer : CAShapeLayer!
    
    fileprivate var rightEyeLayer : CAShapeLayer!
    
    fileprivate var mouthLayer : CAShapeLayer!
    
    fileprivate var EyesAnimation : CAAnimationGroup!
    
    fileprivate var enableMouthAnimation : CAAnimationGroup!
    
    fileprivate var disableMouthAnimation : CAAnimationGroup!
    
    fileprivate var EyesAfterMoveAnimation : CABasicAnimation!
    
    fileprivate var MouthAfterMoveAnimation : CABasicAnimation!
    
    init(frame: CGRect,delegate : MXSwitchButtonDelegate,superEndPosition : CGPoint) {
        super.init(frame: frame)
        //代理
        self.delegate = delegate
        //View frame
        self.superviewEndPosition = superEndPosition
        
        //背景颜色
        //默认
        self.backgroundColor = disableColor
        //转换后的颜色为 210 252 222
        
        //设置圆角
        self.layer.cornerRadius = 5
        
        self.layer.masksToBounds = true
        //自定义
        self.initSublayers()
        self.initAnimations()
        //增加手势
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(MXSwitchButton.switchClick(gesture:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initSublayers(){
        //左眼
        self.leftEyeLayer = CAShapeLayer()
        
        self.leftEyeLayer.frame = CGRect.init(x: self.frame.size.width / 8, y: self.frame.size.height / 8 + 6, width: 6, height: 6)
        
        let leftEyePath = UIBezierPath.init(arcCenter: CGPoint.init(x: self.leftEyeLayer.frame.size.width / 2, y: self.leftEyeLayer.frame.size.height / 2), radius: self.leftEyeLayer.frame.size.width / 2, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        self.leftEyeLayer.path = leftEyePath.cgPath
        
        self.leftEyeLayer.lineWidth = 1
        
        //self.leftEyeLayer.strokeColor = UIColor.black.cgColor
        
        self.leftEyeLayer.fillColor = UIColor.black.cgColor
        
        self.layer.addSublayer(self.leftEyeLayer)
        
        //右眼
        self.rightEyeLayer = CAShapeLayer()
        
        self.rightEyeLayer.frame = CGRect.init(x: self.frame.size.width / 8 * 7 - self.leftEyeLayer.frame.width, y: self.frame.size.height / 8 + 6, width: 6, height: 6)
        
        let rightEyePath = UIBezierPath.init(arcCenter: CGPoint.init(x: self.rightEyeLayer.frame.size.width / 2, y: self.rightEyeLayer.frame.size.height / 2), radius: self.rightEyeLayer.frame.size.width / 2, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        self.rightEyeLayer.path = rightEyePath.cgPath
        
        self.rightEyeLayer.lineWidth = 1
        
        //self.rightEyeLayer.strokeColor = UIColor.black.cgColor
       
        self.rightEyeLayer.fillColor = UIColor.black.cgColor
        
        self.layer.addSublayer(self.rightEyeLayer)
        
        //嘴巴
        self.mouthLayer = CAShapeLayer()
        //self.frame.height / 4 + self.leftEyeLayer.frame.height
        self.mouthLayer.frame = CGRect.init(x: self.leftEyeLayer.frame.origin.x + self.leftEyeLayer.frame.width + (self.frame.width / 2 - 2 * self.leftEyeLayer.frame.width) / 2, y: self.frame.height / 16 * 7 + self.leftEyeLayer.frame.height / 2, width: self.frame.width / 4 , height: self.frame.height / 4 )
        
        let mouthPath = UIBezierPath.init(arcCenter: CGPoint.init(x: self.mouthLayer.frame.width / 2, y: self.mouthLayer.frame.height / 2), radius: self.mouthLayer.frame.width / 2, startAngle: 0.0, endAngle: CGFloat(M_PI), clockwise: false)
        
        self.mouthLayer.path = mouthPath.cgPath
        
        self.mouthLayer.lineWidth = 1.5
        
        //颜色设定为跟着变化。。
        self.mouthLayer.fillColor = disableColor.cgColor
        
        self.mouthLayer.strokeColor = UIColor.black.cgColor
        
        self.layer.addSublayer(self.mouthLayer)
    }
    //MARK: Animation
    private func initAnimations(){
        //MoveAnimation
        self.EyesAnimation = CAAnimationGroup.init()
        //移动动画
        let enableEyesAnimationMove = CABasicAnimation.init(keyPath: "position.y")
        
        enableEyesAnimationMove.fromValue = self.leftEyeLayer.position.y
        
        enableEyesAnimationMove.toValue = self.mouthLayer.position.y
        
        enableEyesAnimationMove.autoreverses = false
        
        enableEyesAnimationMove.isRemovedOnCompletion = false
        
        enableEyesAnimationMove.duration = 1
        
        enableEyesAnimationMove.fillMode = kCAFillModeForwards
        
        //变行动画
        let enableEyesAnimationScale = CAKeyframeAnimation.init(keyPath: "transform.scale.y")
        
        enableEyesAnimationScale.values = [1,0.2,1]
        
        enableEyesAnimationScale.autoreverses = false
        
        enableEyesAnimationScale.isRemovedOnCompletion = false
        
        enableEyesAnimationScale.duration = 1
        
        enableEyesAnimationScale.fillMode = kCAFillModeForwards
        
        self.EyesAnimation.animations = [enableEyesAnimationMove,enableEyesAnimationScale]
        
        self.EyesAnimation.duration = 1.0
        
        self.EyesAnimation.isRemovedOnCompletion = false
        
        self.EyesAnimation.duration = 1
        
        self.EyesAnimation.fillMode = kCAFillModeForwards
        
        //嘴巴动画
        self.enableMouthAnimation = CAAnimationGroup.init()
        
        //位移动画
        let enableMouthAnimationMove = CABasicAnimation.init(keyPath: "position.y")
        
        enableMouthAnimationMove.toValue = self.leftEyeLayer.position.y
        
        enableMouthAnimationMove.fromValue = self.mouthLayer.position.y
        
        enableMouthAnimationMove.autoreverses = false
        
        enableMouthAnimationMove.isRemovedOnCompletion = false
        
        enableMouthAnimationMove.duration = 1
        
        enableMouthAnimationMove.fillMode = kCAFillModeForwards
        
        //旋转动画
        let enableMouthAnimationRotate = CABasicAnimation.init(keyPath: "transform.rotation.x")
        
        enableMouthAnimationRotate.toValue = M_PI
        
        enableMouthAnimationRotate.fromValue = 0
        
        enableMouthAnimationRotate.autoreverses = false
        
        enableMouthAnimationRotate.isRemovedOnCompletion = false
        
        enableMouthAnimationRotate.duration = 1
        
        enableMouthAnimationRotate.fillMode = kCAFillModeForwards
        
        self.enableMouthAnimation.animations = [enableMouthAnimationMove,enableMouthAnimationRotate]
      
        self.enableMouthAnimation.duration = 1.0
        
        self.enableMouthAnimation.isRemovedOnCompletion = false
        
        self.enableMouthAnimation.duration = 1
        
        self.enableMouthAnimation.fillMode = kCAFillModeForwards
        
        //disable MouthAnimation
        self.disableMouthAnimation = CAAnimationGroup.init()
        
        //位移动画
        let disableMouthAnimationMove = CABasicAnimation.init(keyPath: "position.y")
        
        disableMouthAnimationMove.toValue = self.leftEyeLayer.position.y
        
        disableMouthAnimationMove.fromValue = self.mouthLayer.position.y
        
        disableMouthAnimationMove.autoreverses = false
        
        disableMouthAnimationMove.isRemovedOnCompletion = false
        
        disableMouthAnimationMove.duration = 1
        
        disableMouthAnimationMove.fillMode = kCAFillModeForwards
        
        //旋转动画
        let disableMouthAnimationRotate = CABasicAnimation.init(keyPath: "transform.rotation.x")
        
        disableMouthAnimationRotate.toValue = 0
        
        disableMouthAnimationRotate.fromValue = M_PI
        
        disableMouthAnimationRotate.autoreverses = false
        
        disableMouthAnimationRotate.isRemovedOnCompletion = false
        
        disableMouthAnimationRotate.duration = 1
        
        disableMouthAnimationRotate.fillMode = kCAFillModeForwards
        
        self.disableMouthAnimation.animations = [disableMouthAnimationMove,disableMouthAnimationRotate]
        
        self.disableMouthAnimation.duration = 1.0
        
        self.disableMouthAnimation.isRemovedOnCompletion = false
        
        self.disableMouthAnimation.duration = 1
        
        self.disableMouthAnimation.fillMode = kCAFillModeForwards

        
        //After Animation
        //Eyes
        self.EyesAfterMoveAnimation = CABasicAnimation.init(keyPath: "position.y")
        
        self.EyesAfterMoveAnimation.toValue = self.leftEyeLayer.position.y
        
        self.EyesAfterMoveAnimation.fromValue = self.mouthLayer.position.y
        
        self.EyesAfterMoveAnimation.autoreverses = false
        
        self.EyesAfterMoveAnimation.isRemovedOnCompletion = false
        
        self.EyesAfterMoveAnimation.duration = 1
        
        self.EyesAfterMoveAnimation.fillMode = kCAFillModeForwards
        
        //Mouth
        
        self.MouthAfterMoveAnimation = CABasicAnimation.init(keyPath: "position.y")
        
        self.MouthAfterMoveAnimation.fromValue = self.leftEyeLayer.position.y
        
        self.MouthAfterMoveAnimation.toValue = self.mouthLayer.position.y
        
        self.MouthAfterMoveAnimation.autoreverses = false
        
        self.MouthAfterMoveAnimation.isRemovedOnCompletion = false
        
        self.MouthAfterMoveAnimation.duration = 1
        
        self.MouthAfterMoveAnimation.fillMode = kCAFillModeForwards
        
        //************************************************************
        //设置代理
        self.enableMouthAnimation.delegate = self
        self.enableMouthAnimation.setValue("EnbaleMouthAnimation", forKey: "identifier")
        self.disableMouthAnimation.delegate = self
        self.disableMouthAnimation.setValue("DisableMouthAnimation", forKey: "identifier")
    }
    
    func switchClick(gesture : UITapGestureRecognizer){
        if self.isEnable {
            self.disableAnimation()
            //关闭
            if self.delegate != nil {
                self.delegate.switchButton(button: self, type: .disable)
            }
        }else{
            //打开
            self.enbaleAnimation()
            if self.delegate != nil {
                self.delegate.switchButton(button: self, type: .enable)
            }
        }
        self.isEnable = !self.isEnable
    }
    
    func enbaleAnimation(){
        self.leftEyeLayer.add(self.EyesAnimation, forKey: "LeftEye")
        self.rightEyeLayer.add(self.EyesAnimation, forKey: "RightEye")
        self.mouthLayer.add(self.enableMouthAnimation, forKey: "EnableMouth")
        
        UIView.animate(withDuration: 1, animations: { 
             self.transform = self.transform.translatedBy(x: self.superviewEndPosition.x - self.frame.size.width - self.frame.origin.x, y: 0)
        })
        
    }
    
    func disableAnimation(){
        self.leftEyeLayer.add(self.EyesAnimation, forKey: "LeftEye")
        self.rightEyeLayer.add(self.EyesAnimation, forKey: "RightEye")
        self.mouthLayer.add(self.disableMouthAnimation, forKey: "DisableMouth")
        
        UIView.animate(withDuration: 1) {
            self.transform = CGAffineTransform.identity
        }
    }
}

//动画代理
extension MXSwitchButton : CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        switch anim.value(forKey: "identifier") as! String {
        case "EnbaleMouthAnimation":
            //还原位置动画
            self.leftEyeLayer.add(self.EyesAfterMoveAnimation, forKey: "LeftEyeAfter")
            self.rightEyeLayer.add(self.EyesAfterMoveAnimation, forKey: "RightEyeAfter")
            self.mouthLayer.add(self.MouthAfterMoveAnimation, forKey: "MouthAfter")
            //变换颜色动画
            //enable
            self.mouthLayer.fillColor = enableColor.cgColor
            self.backgroundColor = enableColor
            
            break
        
        case "DisableMouthAnimation":
            //还原位置动画
            self.leftEyeLayer.add(self.EyesAfterMoveAnimation, forKey: "LeftEyeAfter")
            self.rightEyeLayer.add(self.EyesAfterMoveAnimation, forKey: "RightEyeAfter")
            self.mouthLayer.add(self.MouthAfterMoveAnimation, forKey: "MouthAfter")
            //变换颜色动画
            //disable
            self.mouthLayer.fillColor = disableColor.cgColor
            self.backgroundColor = disableColor
//            UIView.animate(withDuration: 0.5, animations: {
//                if self.isEnable {
//                    //enable
//                    self.mouthLayer.fillColor = enableColor.cgColor
//                    self.backgroundColor = enableColor
//                }else{
//                    
//                }
//                
//            })
            break
        default:
            
            break
        }
    }
}
