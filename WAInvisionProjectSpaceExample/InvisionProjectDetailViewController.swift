//
//  InvisionDetailViewController.swift
//  WAInvisionSpaceExample
//
//  Created by Wendy Abrantes on 21/02/2017.
//  Copyright © 2017 Wendy Abrantes. All rights reserved.
//

import UIKit

class InvisionProjectDetailViewController: UIViewController {
  
  private var project: ProjectData
  
  var cardView = CardView(frame: .zero)
  
  init(project: ProjectData) {
    self.project = project
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardView.frame.size = view.bounds.size
    cardView.isFullScreen = true
    cardView.cornerRadius = 0.0
    cardView.imageHeightRatio = 0.5
    cardView.logoCenterYRatio = 0.3
    cardView.offset = 0
    cardView.mainImageView.image = project.mainImage
    cardView.logoImageView.image = project.logoImage

    view.addSubview(cardView)
    
    cardView.updateFrames()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    //topImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    dismiss(animated: true, completion: nil)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
