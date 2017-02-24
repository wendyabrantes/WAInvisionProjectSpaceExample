//
//  InvisionCollectionViewLayout.swift
//  WAInvisionSpaceExample
//
//  Created by Wendy Abrantes on 20/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class InvisionCollectionViewLayout: UICollectionViewLayout {
  
  var parallaxOffset: CGPoint?
  var itemSize: CGSize = .zero
  var minimumLineSpacing: CGFloat = 20.0
  var baseLayoutAttributes = [InvisionCollectionViewLayoutAttributes]()
  var contentInset: UIEdgeInsets = .zero
  
  override class var layoutAttributesClass: AnyClass {
    return InvisionCollectionViewLayoutAttributes.self
  }
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepare() {
    super.prepare()
    
    baseLayoutAttributes = [InvisionCollectionViewLayoutAttributes]()
    let nbItems = collectionView?.numberOfItems(inSection: 0) ?? 0
    
    for item in 0..<nbItems {
      let indexPath = IndexPath(item: item, section: 0)
      let yPosition = (collectionView!.frame.height - itemSize.height)/2.0
      let position = CGPoint( x: contentInset.left + ((itemSize.width+minimumLineSpacing) * CGFloat(item)), y:yPosition)
      let frame = CGRect(origin: position, size: itemSize)
      let attributes = InvisionCollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      baseLayoutAttributes.append(attributes)
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let layoutAttributes = baseLayoutAttributes.filter { $0.frame.intersects(rect) }
    
    guard let collectionView = collectionView else { return layoutAttributes }
    
    for attribute in layoutAttributes {
      let offset = (attribute.frame.minX + contentInset.left) - collectionView.contentOffset.x
      let parallaxValue = offset / collectionView.bounds.width
      attribute.parallaxValue = parallaxValue
    }
    return layoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return baseLayoutAttributes[indexPath.row]
  }
  
  
  override var collectionViewContentSize: CGSize {
    get {
      let totalWidth = CGFloat(baseLayoutAttributes.count) * (itemSize.width + self.minimumLineSpacing) + (contentInset.left + contentInset.right)
      return CGSize(width: totalWidth, height: itemSize.height)
    }
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }  
}
