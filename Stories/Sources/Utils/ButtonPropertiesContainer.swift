//
//  ButtonPropertiesContainer.swift
//  Stories
//

import UIKit

public struct ButtonPropertiesContainer {
  public var backgroundColor: UIColor
  public var cornerRadius: CGFloat
  public var titleColor: UIColor
  public var highlightedColor: UIColor?
  public var title: String?
  public var font: UIFont
  public var image: UIImage?
  public var highlightedImage: UIImage?
  public var imageEdgeInsets: UIEdgeInsets
  public var titleEdgeInsets: UIEdgeInsets
  public var contentEdgeInsets: UIEdgeInsets
  
  public init(backgroundColor: UIColor,
       cornerRadius: CGFloat = 0,
       titleColor: UIColor,
       highlightedColor: UIColor? = nil,
       title: String?,
       font: UIFont,
       image: UIImage?,
       highlightedImage: UIImage? = nil,
       imageEdgeInsets: UIEdgeInsets = .zero,
       titleEdgeInsets: UIEdgeInsets = .zero,
       contentEdgeInsets: UIEdgeInsets = .zero) {
    self.backgroundColor = backgroundColor
    self.cornerRadius = cornerRadius
    self.titleColor = titleColor
    self.highlightedColor = highlightedColor
    self.title = title
    self.font = font
    self.image = image
    self.highlightedImage = highlightedImage
    self.imageEdgeInsets = imageEdgeInsets
    self.titleEdgeInsets = titleEdgeInsets
    self.contentEdgeInsets = contentEdgeInsets
  }
}
