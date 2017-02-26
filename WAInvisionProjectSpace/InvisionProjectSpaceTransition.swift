//
//  InvisionProjectSpaceTransition.swift
//  WAInvisionProjectSpaceExample
//
//  Created by Wendy Abrantes on 23/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class InvisionProjectSpaceTransition: NSObject, UIViewControllerAnimatedTransitioning {
  
  private var isDismissed = false
  
  init(isDismissed: Bool) {
    self.isDismissed = isDismissed
    super.init()
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.4
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if(isDismissed){
      dimissController(transitionContext: transitionContext)
    } else {
      presentController(transitionContext: transitionContext)
    }
  }
  
  func copyVisibleCells(visibleCells: [UICollectionViewCell], currentSelected: InvisionProjectSpaceViewCell?) -> (cells:[InvisionProjectSpaceViewCell], selectedCell: InvisionProjectSpaceViewCell?) {
    
    var cells = [InvisionProjectSpaceViewCell]()
    var selectedCell: InvisionProjectSpaceViewCell?
    
    guard let visibleCells = visibleCells as? [InvisionProjectSpaceViewCell] else { return (cells, selectedCell) }
    
    for cell in visibleCells {
      let copyCell = cell.copy() as! InvisionProjectSpaceViewCell
      cells.append(copyCell)
      
      if cell == currentSelected {
        selectedCell = copyCell
      }
    }
    return (cells, selectedCell)
  }
  
  func presentController(transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) as? InvisionProjectSpaceCollectionViewController else { return }
    guard let toVC = transitionContext.viewController(forKey: .to) else { return }
    let duration = transitionDuration(using: transitionContext)
    let containerView = transitionContext.containerView
    containerView.backgroundColor = UIColor.white
    
    let finalFrame = transitionContext.finalFrame(for: toVC)
    toVC.view.frame = finalFrame
    
    //1. clone visible cells and get a reference to the selected cell
    let copyCells = copyVisibleCells(visibleCells: fromVC.collectionView!.visibleCells, currentSelected: fromVC.selectedCell)
    
    for cell in copyCells.cells {
      if let globalFrame = fromVC.collectionView?.convert(cell.frame, to: nil) {
        cell.frame = globalFrame
      }
      //2. add the cell to the temporary container view
      containerView.addSubview(cell)
    }
    
    //3. hide the current collection view
    fromVC.view.isHidden = true
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration,
                                                   delay: 0.0,
                                                   options: [.curveEaseOut, .layoutSubviews],
                                                   animations: {
                                                    
                                                    //4. set the template to be fullscreen and animate the frame
                                                    if let selectedCell = copyCells.selectedCell {
                                                      selectedCell.isFullScreen = true
                                                      selectedCell.frame = finalFrame
                                                    }
                                                    
                                                    //5. We slide all other cells off the screen
                                                    for cell in copyCells.cells {
                                                      if cell != copyCells.selectedCell {
                                                        let instersection = finalFrame.intersection(cell.frame)
                                                        var translateX = instersection.width+20
                                                        if cell.frame.minX < copyCells.selectedCell!.frame.minX {
                                                          translateX = -translateX
                                                        }
                                                        cell.transform = CGAffineTransform(translationX: translateX, y: 0)
                                                      }
                                                    }
    }) { (position) in
      for cell in copyCells.cells {
        cell.removeFromSuperview()
      }
      fromVC.view.isHidden = false
      containerView.addSubview(toVC.view)
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  func dimissController(transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
    guard let toVC = transitionContext.viewController(forKey: .to) as? InvisionProjectSpaceCollectionViewController else { return }
    
    let duration = transitionDuration(using: transitionContext)
    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: toVC)
    toVC.view.frame = finalFrame
    
    let copyCells = copyVisibleCells(visibleCells: toVC.collectionView!.visibleCells, currentSelected: toVC.selectedCell)
    
    var selectedOriginalFrame: CGRect = .zero
    if let selectedCell = copyCells.selectedCell {
      selectedOriginalFrame = toVC.collectionView?.convert(selectedCell.frame, to: nil) ?? .zero
      //1. we set the current selected cell to full screen template
      selectedCell.isFullScreen = true
      selectedCell.frame = fromVC.view.frame
    }
    
    for cell in copyCells.cells {
      //2. all other cell need to be slide of the screen
      if cell != copyCells.selectedCell {
        if let globalFrame = toVC.collectionView?.convert(cell.frame, to: nil) {
          cell.frame = globalFrame
        }
        
        let instersection = finalFrame.intersection(cell.frame)
        var translateX = instersection.width+20
        if cell.frame.minX < selectedOriginalFrame.minX {
          translateX = -translateX
        }
        cell.transform = CGAffineTransform(translationX: translateX, y: 0)
      }
      containerView.addSubview(cell)
    }
    
    fromVC.view.removeFromSuperview()
    toVC.view.isHidden = true
    //3. layout the selected cell for Full screen state
    copyCells.selectedCell?.layoutSubviews()
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration,
                                                   delay: 0.0,
                                                   options: [.curveEaseOut, .layoutSubviews],
                                                   animations: {

                                                    //3. set the card view template and animate the frame
                                                    if let selectedCell = copyCells.selectedCell {
                                                      selectedCell.isFullScreen = false
                                                      selectedCell.frame = selectedOriginalFrame
                                                    }
                                                    
                                                    for cell in copyCells.cells {
                                                      if cell != copyCells.selectedCell {
                                                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                                                      }
                                                    }
    }) { (position) in
      for cell in copyCells.cells {
        cell.removeFromSuperview()
      }
      toVC.view.isHidden = false
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}





