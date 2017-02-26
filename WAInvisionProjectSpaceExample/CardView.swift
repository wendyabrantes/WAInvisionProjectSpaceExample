
//
//  CardView.swift
//  WAInvisionProjectSpaceExample
//
//  Created by Wendy Abrantes on 24/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

protocol CardViewTemplateProtocol {
  var imageSizeRatio: CGSize { get }
  var logoCenterYRatio: CGFloat { get }
  
  func drawRect(rect: CGRect, mainImageView: UIView, logoView: UIView, bottomContainerView: UIView, parallaxValue: CGFloat)
}

struct CardViewTemplate: CardViewTemplateProtocol {
  var logoCenterYRatio: CGFloat = 0.5
  var imageSizeRatio: CGSize = CGSize(width: 1.3, height: 0.7)
  
  func drawRect(rect: CGRect, mainImageView: UIView, logoView: UIView, bottomContainerView: UIView, parallaxValue: CGFloat) {
    
    let maxOffset = -rect.width/3 - (rect.width/3)
    let positionX = maxOffset * parallaxValue
    
    mainImageView.frame = CGRect(x: positionX, y: 0, width: rect.width * imageSizeRatio.width, height: rect.height * imageSizeRatio.height)
    logoView.center = CGPoint(x: rect.width/2, y: mainImageView.frame.height * logoCenterYRatio)
    
    bottomContainerView.frame = CGRect(origin: CGPoint(x: 0, y:mainImageView.frame.height),
                                       size: CGSize(width: rect.width, height: rect.height*(1-imageSizeRatio.height)))
    
    bottomContainerView.alpha = 1
  }
}

struct FullScreenTemplate: CardViewTemplateProtocol {
  var logoCenterYRatio: CGFloat = 0.2
  var imageSizeRatio: CGSize = CGSize(width: 1.0, height: 0.5)
  func drawRect(rect: CGRect, mainImageView: UIView, logoView: UIView, bottomContainerView: UIView, parallaxValue: CGFloat = 0) {
    mainImageView.frame = CGRect(x: 0, y: 0, width: rect.width * imageSizeRatio.width, height: rect.height * imageSizeRatio.height)
    logoView.center = CGPoint(x: rect.width/2, y: mainImageView.frame.height * logoCenterYRatio)
    bottomContainerView.frame = CGRect(origin: CGPoint(x: 0, y:mainImageView.frame.height),
                                       size: CGSize(width: rect.width, height: rect.height*(1-imageSizeRatio.height)))
    bottomContainerView.alpha = 0
  }
}


protocol CardViewProtocol {
  var isFullScreen: Bool { get set }
}

class CardView: UIView, CardViewProtocol, NSCopying {
  
  var contentView = UIView()
  var mainImageView = UIImageView()
  var logoImageView = UIImageView()
  var bottomContainerView = UIView()
  private var titleLabel = UILabel()
  private var nbOfProjectsLabel = UILabel()
  
  var cornerRadius: CGFloat = 10.0
  var offset : CGFloat = 2*35
  let verticalPadding: CGFloat = 3
  let paddingLeft: CGFloat = 20
  
  private let logoSize = CGSize(width: 70, height: 70)
  
  var imageHeightRatio: CGFloat = 0.7
  var logoCenterYRatio: CGFloat = 0.5
  
  var parallax: CGFloat = 0 {
    didSet {
      layoutSubviews()
    }
  }

  var isFullScreen: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
    
    layer.shouldRasterize = false
    layer.cornerRadius = cornerRadius
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 10
    layer.shadowOffset = CGSize(width:0, height:10)
    layer.shadowOpacity = 0.1
    layer.masksToBounds = false
    
    contentView.frame = CGRect(origin: .zero, size: frame.size)
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = cornerRadius
    
    mainImageView.frame = CGRect(x: 0, y: 0, width: bounds.width + offset, height: 0)
    mainImageView.contentMode = .scaleAspectFill
    mainImageView.layer.masksToBounds = true
    
    logoImageView.contentMode = .scaleAspectFill
    logoImageView.layer.cornerRadius = 12
    logoImageView.layer.masksToBounds = true
    logoImageView.frame.size = logoSize
    
    bottomContainerView.layer.masksToBounds = true
    
    titleLabel.textColor = UIColor.gray
    titleLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
    nbOfProjectsLabel.textColor = UIColor.gray
    nbOfProjectsLabel.font = UIFont(name: "Helvetica", size: 14)
    
    contentView.addSubview(mainImageView)
    contentView.addSubview(logoImageView)
    contentView.addSubview(bottomContainerView)
    bottomContainerView.addSubview(titleLabel)
    bottomContainerView.addSubview(nbOfProjectsLabel)
    
    addSubview(contentView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func updateWithImage(mainImage: UIImage, logoImage:UIImage, title: String, nbProject: Int){
    mainImageView.image = mainImage
    logoImageView.image = logoImage
    titleLabel.text = title
    nbOfProjectsLabel.text = "\(nbProject) Projects"
    
    titleLabel.sizeToFit()
    nbOfProjectsLabel.sizeToFit()
    
    layoutSubviews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius  = cornerRadius
    contentView.layer.cornerRadius = cornerRadius
    contentView.frame = bounds

    if isFullScreen {
      let template = FullScreenTemplate()
      template.drawRect(rect: self.frame, mainImageView: mainImageView, logoView: logoImageView, bottomContainerView: bottomContainerView)
    } else {
      let template = CardViewTemplate()
      template.drawRect(rect: self.frame, mainImageView: mainImageView, logoView: logoImageView, bottomContainerView: bottomContainerView,parallaxValue: parallax)
    }
    
    titleLabel.frame.origin = CGPoint(x: paddingLeft, y: bottomContainerView.frame.height/2 - (titleLabel.frame.height + verticalPadding))
    nbOfProjectsLabel.frame.origin = CGPoint(x: paddingLeft, y: bottomContainerView.frame.height/2 + verticalPadding)
  }
  
  func copyCardView() -> CardView {
    return self.copy() as! CardView
  }
  
  func copy(with zone: NSZone? = nil) -> Any {
    let instance = CardView(frame: self.frame)
    
    instance.contentView.frame = self.contentView.frame
    
    if let mainImage = self.mainImageView.image, let copyMain = mainImage.cgImage?.copy() {
      let newMainImage = UIImage(cgImage: copyMain, scale: mainImage.scale, orientation: mainImage.imageOrientation)
      instance.mainImageView.frame = self.mainImageView.frame
      instance.mainImageView.image = newMainImage
    }
    
    if let logoImage = self.logoImageView.image, let copyLogo = logoImage.cgImage?.copy() {
      let newLogoImage = UIImage(cgImage: copyLogo, scale: logoImage.scale, orientation: logoImage.imageOrientation)
      instance.logoImageView.image = newLogoImage
      instance.logoImageView.frame = self.logoImageView.frame
    }
    
    instance.bottomContainerView.frame = self.bottomContainerView.frame
    
    instance.titleLabel.text = self.titleLabel.text
    instance.titleLabel.frame = self.titleLabel.frame
    
    instance.nbOfProjectsLabel.text = self.nbOfProjectsLabel.text
    instance.nbOfProjectsLabel.frame = self.nbOfProjectsLabel.frame
    
    instance.parallax = parallax
    return instance

  }
  
}
