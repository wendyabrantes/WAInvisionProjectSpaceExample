//
//  InvisionProjectSpaceCellView.swift
//  WAInvisionProjectSpaceExample
//
//  Created by Wendy Abrantes on 22/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class InvisionProjectSpaceViewCell : UICollectionViewCell {
  static let reuseIdentifier = "InvisionProjectSpaceViewCell"
 
  var cardView: CardView
  
  var parallaxValue: CGFloat = 0 {
    didSet {
      let width = self.frame.width
      let maxOffset = -width/3 - (width/3)
      var frame = cardView.mainImageView.frame
      frame.origin.x = maxOffset * parallaxValue;
      cardView.mainImageView.frame.origin.x = frame.origin.x
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override init(frame: CGRect) {
    cardView = CardView(frame: CGRect(origin: .zero, size: frame.size))
    super.init(frame: frame)

    contentView.addSubview(cardView)
  }

  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    guard let layoutAttributes = layoutAttributes as? InvisionCollectionViewLayoutAttributes else { return }
    parallaxValue = layoutAttributes.parallaxValue
  }

  public func updateWithImage(mainImage: UIImage, logoImage:UIImage, title: String, nbProject: Int){
    cardView.updateWithImage(mainImage: mainImage, logoImage:logoImage, title: title, nbProject: nbProject)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    cardView.updateFrames()
  }
}

