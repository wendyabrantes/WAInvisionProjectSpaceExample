//
//  CardView.swift
//  WAInvisionProjectSpaceExample
//
//  Created by Wendy Abrantes on 24/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class CardView: UIView {
  
  var contentView = UIView()
  var mainImageView = UIImageView()
  var logoImageView = UIImageView()
  var containerBottomView = UIView()
  private var titleLabel = UILabel()
  private var nbOfProjectsLabel = UILabel()
  
  var cornerRadius: CGFloat = 10.0
  var offset : CGFloat = 2*35
  let verticalPadding: CGFloat = 3
  let paddingLeft: CGFloat = 20
  
  private let logoSize = CGSize(width: 70, height: 70)
  
  var imageHeightRatio: CGFloat = 0.7
  var logoCenterYRatio: CGFloat = 0.5
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
    
    layer.cornerRadius = cornerRadius
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width:0, height:10)
    layer.shadowRadius = 10
    layer.shadowOpacity = 0.1
    layer.masksToBounds = false
    
    contentView.frame = CGRect(origin: .zero, size: frame.size)
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = cornerRadius
    
    mainImageView.contentMode = .scaleAspectFill
    mainImageView.layer.masksToBounds = true
    
    logoImageView.contentMode = .scaleAspectFill
    logoImageView.layer.cornerRadius = 12
    logoImageView.layer.masksToBounds = true
    logoImageView.frame.size = logoSize
    logoImageView.layer.shadowColor = UIColor.black.cgColor
    logoImageView.layer.shadowOffset = CGSize(width:0, height:2)
    logoImageView.layer.shadowRadius = 5
    logoImageView.layer.shadowOpacity = 0.3
    
    containerBottomView.layer.masksToBounds = true
    
    titleLabel.textColor = UIColor.gray
    titleLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
    nbOfProjectsLabel.textColor = UIColor.gray
    nbOfProjectsLabel.font = UIFont(name: "Helvetica", size: 14)
    
    contentView.addSubview(mainImageView)
    contentView.addSubview(logoImageView)
    contentView.addSubview(containerBottomView)
    containerBottomView.addSubview(titleLabel)
    containerBottomView.addSubview(nbOfProjectsLabel)
    
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
    updateFrames()
  }
  
  var isMainImageAnimationEnable: Bool = true
  
  func updateFrames() {
    layer.cornerRadius  = cornerRadius
    contentView.layer.cornerRadius = cornerRadius
    contentView.frame = bounds
    
    let imageHeight = contentView.frame.height*imageHeightRatio
    
    if isMainImageAnimationEnable {
      var mainFrame = mainImageView.frame
      mainFrame.size = CGSize(width: bounds.width + offset, height: imageHeight)
      mainImageView.frame = mainFrame
    }
    
    logoImageView.center = CGPoint(x: contentView.frame.width/2, y: imageHeight*logoCenterYRatio )
    containerBottomView.frame = CGRect(origin: CGPoint(x: 0, y:imageHeight),
                                       size: CGSize(width: contentView.frame.width, height: contentView.frame.height*(1-imageHeightRatio)))
    
    titleLabel.frame.origin = CGPoint(x: paddingLeft, y: containerBottomView.frame.height/2 - (titleLabel.frame.height + verticalPadding))
    nbOfProjectsLabel.frame.origin = CGPoint(x: paddingLeft, y: containerBottomView.frame.height/2 + verticalPadding)
  }
  
  override func copy() -> Any {
    let instance =  CardView(frame: self.frame)
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
    
    instance.containerBottomView.frame = self.containerBottomView.frame
    
    instance.titleLabel.text = self.titleLabel.text
    instance.titleLabel.frame = self.titleLabel.frame
    
    instance.nbOfProjectsLabel.text = self.nbOfProjectsLabel.text
    instance.nbOfProjectsLabel.frame = self.nbOfProjectsLabel.frame
    
    return instance
  }
}
