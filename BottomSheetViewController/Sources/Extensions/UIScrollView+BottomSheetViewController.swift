//
//  UIScrollView+BottomSheetViewController.swift
//  BottomSheetController
//
//

import UIKit

extension UIScrollView {
  
  public func addObserver(to viewController: BottomSheetViewController) {
    viewController.updateScrollView(scrollView: self)
  }
  
  public func removeObserver(from viewController: BottomSheetViewController) {
    viewController.updateScrollView(scrollView: nil)
  }
}
