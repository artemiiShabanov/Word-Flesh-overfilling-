//
//  CardView.swift
//  WordFlash
//
//  Created by xcode on 06.12.2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import UIKit

protocol StarPressedDelegate {
    func starPressed(for word:String)
}

class CardView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var definitionLabel: UILabel!
    
    var delegate:StarPressedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = Color.dolphin
        contentView.layer.borderColor = (UIColor.white).cgColor
        
        let doubletap = UITapGestureRecognizer(target: self, action: #selector (self.tapped (_:)))
        doubletap.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(doubletap)
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: definitionLabel.bottomAnchor).isActive = true
    }
    
    public func construct(for word:Word) {
        wordLabel.text = word.word
        starButton.setImage( word.isFavorite ? #imageLiteral(resourceName: "smallorstar") : #imageLiteral(resourceName: "smallstar"), for: .normal)
        definitionLabel.text = word.definition
    }
    
    @IBAction func starPressed(_ sender: Any ) {
        starButton.setImage(starButton.currentImage == #imageLiteral(resourceName: "smallorstar") ? #imageLiteral(resourceName: "smallstar") : #imageLiteral(resourceName: "smallorstar"), for: .normal)
        delegate?.starPressed(for: wordLabel.text!)
    }
    
    @objc func flip() {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
            self.definitionLabel.isHidden = !self.definitionLabel.isHidden
        })
    }
    
    @objc func tapped(_ sender:UITapGestureRecognizer) {
        flip()
    }
}

