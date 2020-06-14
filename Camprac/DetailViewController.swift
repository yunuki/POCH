//
//  DetailViewController.swift
//  Camprac
//
//  Created by woogie on 26/10/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    var ingre: Ingredient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DesignHelper.Itself.setGradientToView(view: view, UIColor(red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0), UIColor(red: 125/255.0, green: 125/255.0, blue: 255/255.0, alpha: 1.0))
        if let ingre = ingre {
            nameLabel.text = ingre.name
            descTextView.attributedText = DesignHelper.Itself.attributeStringMaker(string: ingre.description)
        }
    }

}

