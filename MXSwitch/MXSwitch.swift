//
//  MXSwitch.swift
//  MXSwitch
//
//  Created by mx on 2017/3/15.
//  Copyright © 2017年 mengx. All rights reserved.
//

import UIKit

private let HEIGHT : CGFloat = 22.0

class MXSwitch: UIView {
    
    weak var backgroundView : UIView!
    
    weak var switchBubtton : MXSwitchButton!
    
    var delegate : MXSwitchDelegate!
    
    init(frame: CGRect,delegate : MXSwitchDelegate) {
        super.init(frame: frame)
        
        self.delegate = delegate
        
        //初始化
        self.initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initSubViews(){
        //设置
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height / 2.0 - HEIGHT / 2.0, width: self.frame.size.width, height: HEIGHT))
        
        self.backgroundView = view
        
        self.backgroundView.layer.cornerRadius = 6
        
        self.backgroundView.layer.masksToBounds = true
        
        self.backgroundView.backgroundColor = disableColor
        
        self.addSubview(self.backgroundView)
        
        //按钮
        let button = MXSwitchButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 44, height: self.frame.size.height), delegate: self, superEndPosition: CGPoint.init(x: self.backgroundView.frame.size.width, y: 0))
        
        self.switchBubtton = button
        
        self.addSubview(self.switchBubtton)
    }
}

extension MXSwitch : MXSwitchButtonDelegate{
    func switchButton(button: MXSwitchButton, type: MXSwitchButtonType) {
        //执行动画
        switch type {
        case .disable:
            //背景颜色动画
            UIView.animate(withDuration: 1, animations: { 
                self.backgroundView.backgroundColor = disableColor
            }, completion: { (isSuccess : Bool) in
                //通知代理
                self.delegate.mxswitch(mxswitch: self, type: .disable)
            })
            break
        default:
            //enable
            //背景颜色动画
            UIView.animate(withDuration: 1, animations: {
                self.backgroundView.backgroundColor = enableColor
            }, completion: { (isSuccess : Bool) in
                //通知代理
                self.delegate.mxswitch(mxswitch: self, type: .enable)
            })
            break
        }
    }
}
