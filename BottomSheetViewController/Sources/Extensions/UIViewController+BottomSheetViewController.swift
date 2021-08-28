//
//  UIViewController+BottomSheetViewController.swift
//  BottomSheetController
//
//

import UIKit

private struct Constants {
  static let downViewHeight: CGFloat = 20
}

extension UIViewController {
  
  fileprivate func makeDownView() -> UIView {
    let downViewFrame = CGRect(x: 0,
                               y: view.frame.height - Constants.downViewHeight,
                               width: view.frame.width,
                               height: Constants.downViewHeight)
    return UIView(frame: downViewFrame)
  }
  
  fileprivate func addBackgroundView(for viewController: BottomSheetViewController, sheetType: SheetType) {
    let backgroundView = BottomSheetBackgroundView(frame: view.frame, sheetType: sheetType)
    view.addSubview(backgroundView)
    
    viewController.darkView = backgroundView
    
    let downView = makeDownView()
    downView.backgroundColor = viewController.backgroundColor
    viewController.updateDownView(downView)
    view.addSubview(downView)
    
    backgroundView.onViewDidReceiveTap = { [weak viewController] in
      downView.removeFromSuperview()
      viewController?.moveDown(completion: { [weak viewController] in
        viewController?.remove()
      })
    }
    
    viewController.onDidRemoveBottomSheetViewController = {
      downView.removeFromSuperview()
      backgroundView.remove(completion: { [weak backgroundView] in
        guard let backgroundView = backgroundView else { return }
        backgroundView.removeFromSuperview()
      })
    }
    
    UIView.animate(withDuration: 0.3) {
      backgroundView.alpha = 1.0
    }
  }
  
  public func addBottomSheetViewController(withDarkView: Bool,
                                           viewController: BottomSheetViewController,
                                           initialAnchorPointOffset: CGFloat, height: CGFloat? = nil,
                                           animated: Bool, sheetType: SheetType = .hiding) {
    if withDarkView {
      addBackgroundView(for: viewController, sheetType: sheetType)
    }
    
    addChild(viewController)
    viewController.setup(superView: view, initialAnchorPointOffset: initialAnchorPointOffset, height: height, sheetType: sheetType)
    viewController.moveToPointWithAnimation(action: .add, duration: animated ? 0.3 : 0, animations: { [weak self] in
      self?.view.layoutIfNeeded()
      }, completion: nil)
  }
}
