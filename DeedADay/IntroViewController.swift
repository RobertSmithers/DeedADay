//
//  ViewController.swift
//  DeedADay
//
//  Created by RJ Smithers on 4/21/20.
//  Copyright © 2020 RJ Smithers. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beginAnimation()
    }
    
    @IBAction func userTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ShowMain", sender: nil)
    }
    
    
    func prepAnimations() {
        titleLabel.center.y = view.frame.height + titleLabel.frame.height/2
        titleLabel.center.x = view.frame.width/2
        
        subtitleLabel.alpha = 0
        subtitleLabel.center.x = view.frame.width/2
        subtitleLabel.center.y = view.frame.height * 4/6
        
    }
    
    func beginAnimation() {
        animateLogo()
        animateText()
    }
    
    func animateText() {
        UIView.animate(withDuration: 2, delay: 0.0, options: [], animations: {
            self.titleLabel.center.x = self.view.bounds.width/2
            self.titleLabel.center.y = self.view.bounds.height*2/5
        }, completion: nil)
        
        let timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(animateSubtitle), userInfo: nil, repeats: false)
    }
    
    @objc func animateSubtitle() {
        subtitleLabel.alpha = 0.25
        UIView.animate(withDuration: 2, delay: 0.0, options: [.autoreverse, .curveLinear, .repeat], animations: {
            self.subtitleLabel.alpha = 1
        }, completion: nil)
    }
    
    func animateLogo() {
        let logoY = 0 - (logoImage.image!.size.width * logoImage.image!.scale)
        wingFlap()
        
        UIView.animate(withDuration: 2, delay: 0.0, options: [], animations: {
            self.logoImage.center.y = logoY
            
        }, completion: nil)
        logoImage.image = UIImage(named: "animatedLogo6")
    }
    
    func wingFlap() {
        logoImage.animationDuration = 0.5
        logoImage.animationImages = (0...6).map { UIImage(named: "animatedLogo\($0)")!}
        logoImage.animationRepeatCount = 1
        logoImage.startAnimating()
    }


}

