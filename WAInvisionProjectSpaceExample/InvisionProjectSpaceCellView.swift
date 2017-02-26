//
//  InvisionProjectSpaceCellView.swift
//  WAInvisionProjectSpaceExample
//
//  Created by Wendy Abrantes on 22/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class InvisionProjectSpaceViewCell : UICollectionViewCell, CardViewProtocol, NSCopying {
  static let reuseIdentifier = "InvisionProjectSpaceViewCell"
 
  var isFullScreen: Bool = false {
    didSet {
      cardView.isFullScreen = isFullScreen
    }
  }
  
  var cardView = CardView(frame: .zero)
  
  var parallaxValue: CGFloat = 0 {
    didSet {
      cardView.parallax = parallaxValue
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override init(frame: CGRect) {
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
    cardView.frame = CGRect(origin: .zero, size: frame.size)
    cardView.layoutSubviews()
  }
  
  func copy(with zone: NSZone? = nil) -> Any {
    let cardView = self.cardView.copy() as! CardView
    let instance = InvisionProjectSpaceViewCell(frame: self.frame)
    instance.cardView.removeFromSuperview()
    instance.cardView = cardView
    instance.contentView.addSubview(cardView)
    return instance
  }

}

