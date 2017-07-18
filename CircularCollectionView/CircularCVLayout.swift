//
//  CircularCVLayout.swift
//  CircularCollectionView
//
//  Created by Dwayne Langley on 7/17/17.
//  Copyright © 2017 Rounak Jain. All rights reserved.
//

import UIKit

class CircularCVLayout: UICollectionViewLayout {
  let itemSize = CGSize(width: 133, height: 173)
  
  var angleAtExtreme: CGFloat {
    return collectionView!.numberOfItems(inSection: 0) > 0 ?
      -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
  }
  
  var angle: CGFloat {
    return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width -
      collectionView!.bounds.width)
  }
  
  var radius: CGFloat = 500 {
    didSet {
      invalidateLayout()
    }
  }
  
  var anglePerItem: CGFloat {
    return atan(itemSize.width / radius)
  }
  
  var attributesList = [CircularCollectionViewLayoutAttributes]()
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,
                  height: collectionView!.bounds.height)
  }
  
  override class var layoutAttributesClass: AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }
  
  override func prepare() {
    super.prepare()
    
    let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
    let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
    attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i)
      -> CircularCollectionViewLayoutAttributes in
      // 1
      let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
      attributes.size = self.itemSize
      // 2
      attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
      // 3
      attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      return attributes
    }
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}


class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  // 1 The rotation happens around a point that isn’t the center.
  var anchorPoint = CGPoint(x: 0.5, y: 0.5)
  var angle: CGFloat = 0 {
    // 2
    didSet {
      zIndex = Int(angle * 1000000)
      transform = CGAffineTransform(rotationAngle: angle)
    }
  }
  
  // 3
  override func copy(with zone: NSZone? = nil) -> Any {
    let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
    copiedAttributes.anchorPoint = self.anchorPoint
    copiedAttributes.angle = self.angle
    return copiedAttributes
  }
}
