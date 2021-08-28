//
//  StoriesListCellViewModelProtocol.swift
//  Stories
//

import UIKit

public protocol StoriesListCellViewModelProtocol {
  var onDidSelect: (() -> Void)? { get set }
  
  var imageURL: URL? { get }
  
  var titleProperties: LabelPropertiesContainer { get set }
  var titleLabelConstraints: ViewConstraintsContainer { get set }
  
  var contentViewBackgroundColor: UIColor { get set }
  var contentViewCornerRadius: CGFloat { get set }
  var contentViewAlpha: CGFloat { get set }
  
  var activityIndicatorStyle: UIActivityIndicatorView.Style { get set }
  var activityIndicatorColor: UIColor? { get set }
  
  var shadowColor: UIColor? { get set }
  var shadowOffset: CGSize { get set }
  var shadowOpacity: Float { get set }
  var shadowRadius: CGFloat { get set }
  
  func select()
}

extension StoriesListCellViewModelProtocol {
  public func select() {
    onDidSelect?()
  }
}
