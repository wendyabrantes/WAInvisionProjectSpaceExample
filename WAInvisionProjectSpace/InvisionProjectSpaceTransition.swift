//
//  InvisionProjectSpaceTransition.swift
//  WAInvisionProjectSpaceExample
//
//  Created by Wendy Abrantes on 23/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class InvisionProjectSpaceTranstion: NSObject, UIViewControllerAnimatedTransitioning {
  
  private var isBeingDismissed = false
  
  init(isBeingDismissed: Bool) {
    self.isBeingDismissed = isBeingDismissed
    super.init()
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if(isBeingDismissed){
      dimissController(transitionContext: transitionContext)
    } else {
      presentController(transitionContext: transitionContext)
    }
  }
  
  func cloneVisibleCardViews(collectionViewController: UICollectionViewController, visibleCells: [InvisionProjectSpaceViewCell]) -> [CardView]{
    var cards = [CardView]()
    
    for cell in visibleCells {
      let copyOfCardView = cell.cardView.copy() as! CardView
      if let globalFrame = collectionViewController.collectionView?.convert(cell.frame, to: nil) {
        copyOfCardView.frame = globalFrame
      }
      cards.append(copyOfCardView)
    }
    return cards
  }
  
  func presentController(transitionContext: UIViewControllerContextTransitioning){
    guard let fromVC = transitionContext.viewController(forKey: .from) as? InvisionProjectSpaceCollectionViewController else { return }
    guard let toVC = transitionContext.viewController(forKey: .to) else { return }
    
    let duration = transitionDuration(using: transitionContext)
    let containerView = transitionContext.containerView
    containerView.backgroundColor = UIColor.white
    
    let finalFrame = transitionContext.finalFrame(for: toVC)
    toVC.view.frame = finalFrame
    
    //we get all the visibles cell and clone them
    var cards = [CardView]()
    var selectedCard: CardView?
    
    if let visibleCells = fromVC.collectionView?.visibleCells as? [InvisionProjectSpaceViewCell] {
      cards = cloneVisibleCardViews(collectionViewController: fromVC, visibleCells: visibleCells)
      if let currentCell = fromVC.selectedCell as? InvisionProjectSpaceViewCell, let indexCard = visibleCells.index(of: currentCell) {
        selectedCard = cards[indexCard]
      }
    }
    
    //add all the card view to the screen
    for card in cards {
      containerView.addSubview(card)
    }
    
    //WE PRESET THE CARD SETTING FOR FULL SCREEN MODE
    if let selectedCard = selectedCard {
      selectedCard.isMainImageAnimationEnable = false
      selectedCard.imageHeightRatio = 0.5
      selectedCard.logoCenterYRatio = 0.3
    }
    
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration,
                                                   delay: 0.0,
                                                   options: [.curveEaseOut, .layoutSubviews],
                                                   animations: {
                                                    
                                                    if let selectedCard = selectedCard {
                                                      selectedCard.frame = finalFrame
                                                      selectedCard.mainImageView.frame = CGRect(origin: .zero, size: CGSize(width:finalFrame.width, height:finalFrame.height*selectedCard.imageHeightRatio))
                                                      selectedCard.containerBottomView.alpha = 0
                                                    }
                                                    
                                                    for card in cards {
                                                      if card != selectedCard {
                                                        let instersection = card.frame.intersection(finalFrame)
                                                        var translateX = instersection.width+20
                                                        if card.frame.minX < selectedCard!.frame.minX {
                                                          translateX = -translateX
                                                        }
                                                        card.transform = CGAffineTransform(translationX: translateX, y: 0)
                                                      }
                                                    }
    }) { (position) in
      for card in cards {
        card.removeFromSuperview()
      }
      fromVC.collectionView?.alpha = 1.0
      containerView.addSubview(toVC.view)
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  func dimissController(transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
    guard let toVC = transitionContext.viewController(forKey: .to) as? InvisionProjectSpaceCollectionViewController  else { return }
    
    let duration = transitionDuration(using: transitionContext)
    let containerView = transitionContext.containerView
    
    let finalFrame = transitionContext.finalFrame(for: toVC)
    toVC.view.frame = finalFrame
    
    //we need to get all the visible cell and clone them
    var cards = [CardView]()
    var selectedCard: CardView?
    
    var finalCardFrame = CGRect.zero
    var finalImageFrame = CGRect.zero
    
    if let visibleCells = toVC.collectionView?.visibleCells as? [InvisionProjectSpaceViewCell] {
      cards = cloneVisibleCardViews(collectionViewController: toVC, visibleCells: visibleCells)
      
      if let currentCell = toVC.selectedCell as? InvisionProjectSpaceViewCell,
        let indexCard = visibleCells.index(of: currentCell) {

        selectedCard = cards[indexCard]
          
        finalCardFrame = selectedCard!.frame
        finalImageFrame = selectedCard!.mainImageView.frame
        
        //set the current card view to show full screen
        selectedCard!.imageHeightRatio = 0.5
        selectedCard!.logoCenterYRatio = 0.3
        selectedCard!.isMainImageAnimationEnable = false
        selectedCard!.frame = fromVC.view.frame
        selectedCard!.mainImageView.frame = CGRect(origin: .zero, size: CGSize(width:fromVC.view.frame.width, height:fromVC.view.frame.height*selectedCard!.imageHeightRatio))
        selectedCard!.containerBottomView.alpha = 0
        selectedCard!.layoutSubviews() //re layout the subviews
      }
    }
    
    for card in cards {
      if card != selectedCard {
        let instersection = card.frame.intersection(finalFrame)
        var translateX = instersection.width+20
        if card.frame.minX < finalCardFrame.minX {
          translateX = -translateX
        }
        card.transform = CGAffineTransform(translationX: translateX, y: 0)
      }
      containerView.addSubview(card)
    }
    
    fromVC.view.removeFromSuperview()
    //we preset the setting for the
    selectedCard!.imageHeightRatio = 0.7
    selectedCard!.logoCenterYRatio = 0.5
    
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration,
                                                   delay: 0.0,
                                                   options: [.curveEaseOut, .layoutSubviews],
                                                   animations: {
                                                    
                                                    if let selectedCard = selectedCard {
                                                      selectedCard.frame = finalCardFrame
                                                      selectedCard.mainImageView.frame = finalImageFrame
                                                      selectedCard.containerBottomView.alpha = 1
                                                    }
                                                    for card in cards {
                                                      if card != selectedCard {
                                                        card.transform = CGAffineTransform(translationX: 0, y: 0)
                                                      }
                                                    }
                                                    
    }) { (position) in
      selectedCard!.isMainImageAnimationEnable = true
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}
