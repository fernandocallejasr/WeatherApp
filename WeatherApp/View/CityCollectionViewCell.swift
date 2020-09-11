//
//  CityCollectionViewCell.swift
//  WeatherApp
//
//  Created by user177767 on 9/9/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    static let identifier = "CityCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = cellView.frame.height / 5
    
        cellView.backgroundColor = UIColor(red: 0.85, green: 0.78, blue: 0.75, alpha: 1.00)
        
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowRadius = 4.0
        cellView.layer.shadowOffset = CGSize(width: 10.2, height: 10.2)
        cellView.layer.shadowOpacity = 0.4
        cellView.layer.masksToBounds = true
        
    }
    
    func setTitle(with title: String) {
        cellLabel.text = title
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CityCollectionViewCell", bundle: nil)
    }

}
