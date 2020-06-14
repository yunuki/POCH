//
//  NoViewController.swift
//  Camprac
//
//  Created by woogie on 26/10/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit

class NoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //디자인적 요소를 위해 정의한 DesignHelper 클래스의 setGradientToView 함수를 이용하여 UIView의 backgroundColor를 변경
        DesignHelper.Itself.setGradientToView(view: view, UIColor(red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0), UIColor(red: 125/255.0, green: 125/255.0, blue: 255/255.0, alpha: 1.0))
    }
}

