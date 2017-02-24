//
//  InvisionProjectSpaceCollectionViewController.swift
//  WAInvisionProjectSpaceExample
//
//  Created by Wendy Abrantes on 22/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

struct ProjectData {
  var mainImage: UIImage
  var logoImage: UIImage
  var title: String
  var nbProjects: Int
}

class InvisionProjectSpaceCollectionViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {

    let margin: CGFloat = 35
    
    var listCellSize = CGSize.zero
    var detailCellSize = CGSize.zero
    var selectedCell: UICollectionViewCell?
  
    override var prefersStatusBarHidden: Bool {
      return true
    }
  
    private var stubbs = [
      ProjectData(mainImage: UIImage(named:"relate")!, logoImage: UIImage(named:"relate_logo")!, title: "Related UI Kit", nbProjects: 10),
      ProjectData(mainImage: UIImage(named:"craft")!, logoImage: UIImage(named:"craft_logo")!, title: "InVision Craft", nbProjects: 7),
      ProjectData(mainImage: UIImage(named:"nike")!, logoImage: UIImage(named:"nike_plus_logo")!, title: "Nike Running", nbProjects: 5)
    ]
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
      super.init(collectionViewLayout: layout)
    }
  
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      if let collectionView = collectionView as UICollectionView?,
        let layout = collectionView.collectionViewLayout as? InvisionCollectionViewLayout {
        layout.minimumLineSpacing = 20.0
        layout.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin - layout.minimumLineSpacing)
        layout.itemSize = CGSize(width: view.frame.width - (2*margin), height: 400)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(InvisionProjectSpaceViewCell.classForCoder(), forCellWithReuseIdentifier: InvisionProjectSpaceViewCell.reuseIdentifier)
        collectionView.layer.masksToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
      }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvisionProjectSpaceViewCell.reuseIdentifier, for: indexPath)
      
      if let cell = cell as? InvisionProjectSpaceViewCell {
        let item = stubbs[indexPath.row]
        cell.updateWithImage(mainImage: item.mainImage,
                             logoImage:  item.logoImage,
                             title: item.title,
                             nbProject: item.nbProjects)
      }
      return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return stubbs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //present the Detail View Controller
      let project = stubbs[indexPath.row]
      let detailViewController = InvisionProjectDetailViewController(project: project)
      selectedCell = collectionView.cellForItem(at: indexPath)
      
      detailViewController.transitioningDelegate = self
      detailViewController.modalPresentationStyle = .custom
      present(detailViewController, animated: true, completion: nil)
    }
  
  var transition:InvisionProjectSpaceTranstion?
}

extension InvisionProjectSpaceCollectionViewController {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return InvisionProjectSpaceTranstion(isBeingDismissed: false)
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return InvisionProjectSpaceTranstion(isBeingDismissed: true)
  }
}

