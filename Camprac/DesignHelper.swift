//
//  DesignHelper.swift
//  
//
//  Created by woogie on 28/10/2019.
//

import UIKit

class DesignHelper {
    static let Itself = DesignHelper()
    
    func setGradientToView(view: UIView, _ topColor:UIColor, _ bottomColor:UIColor) {
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientToTableView(tableView: UITableView, _ topColor:UIColor, _ bottomColor:UIColor) {
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func attributeStringMaker(string: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 18.5
        let fontSize = UIFont.systemFont(ofSize: 18)
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttributes([NSAttributedString.Key.font : fontSize], range: NSMakeRange(0, string.count))
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, string.count))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, string.count))
        return attributeString
    }
}

