//
//  MypageViewController.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit


class MypageViewController: UIViewController{
    
    
    @IBOutlet weak var partStudy: UIView!
    @IBOutlet weak var likeStudy: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            partStudy.alpha = 1
            likeStudy.alpha = 0
        } else {
            partStudy.alpha = 0
            likeStudy.alpha = 1
        }
        
        
    }
}
