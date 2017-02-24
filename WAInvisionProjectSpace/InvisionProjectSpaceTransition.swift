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
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if(isDismissed){
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
    
    var cards = [CardView]()
    var selectedCard: CardView?
    
    //1. Get all the visibles cell and clone them
    if let visibleCells = fromVC.collectionView?.visibleCells as? [InvisionProjectSpaceViewCell] {
      cards = cloneVisibleCardViews(collectionViewController: fromVC, visibleCells: visibleCells)
      //2. Get a reference on the selected card view
      if let currentCell = fromVC.selectedCell as? InvisionProjectSpaceViewCell, let indexCard = visibleCells.index(of: currentCell) {
        selectedCard = cards[indexCard]
      }
    }
    //3. Add the card view to the container view to reproduce the collection view layout
    for card in cards {
      containerView.addSubview(card)
    }
    
    //4. Preset the selected cell parameter before starting the animation
    //We want the image to animate the height from 70% of the frame to 50%
    //We want the logo to animate from center to top of the image view
    //Because of the parallax effect its easier to tell the card view not to animate on layoutSubview and to do it manually
    if let selectedCard = selectedCard {
      selectedCard.imageHeightRatio = 0.5
      selectedCard.logoCenterYRatio = 0.3
      selectedCard.isMainImageAnimationEnable = false
    }
    
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration,
                                                   delay: 0.0,
                                                   options: [.curveEaseOut, .layoutSubviews],
                                                   animations: {
                                                    
                                                    //5. animate the selected item full screen
                                                    if let selectedCard = selectedCard {
                                                      selectedCard.frame = finalFrame
                                                      selectedCard.mainImageView.frame = CGRect(origin: .zero, size: CGSize(width:finalFrame.width, height:finalFrame.height*selectedCard.imageHeightRatio))
                                                      selectedCard.containerBottomView.alpha = 0
                                                    }
                                                    
                                                    //6. slide off by translating the current visible width amouth left or right
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
