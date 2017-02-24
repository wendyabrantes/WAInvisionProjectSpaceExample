//
//  InvisionCollectionViewLayoutAttributes.swift
//  WAInvisionSpaceExample
//
//  Created by Wendy Abrantes on 20/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class InvisionCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var parallaxValue: CGFloat = 0
  
  override func copy(with zone: NSZone? = nil) -> Any {
    let attribute = super.copy(with: zone) as! InvisionCollectionViewLayoutAttributes
    attribute.parallaxValue = self.parallaxValue
    return attribute
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    guard let object = object as? InvisionCollectionViewLayoutAttributes else { return false }
    guard object.parallaxValue == parallaxValue else{ return false }
    return super.isEqual(object)
  }
}
