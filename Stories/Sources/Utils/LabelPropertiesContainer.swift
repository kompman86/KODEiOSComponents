//
//  LabelPropertiesContainer.swift
//  Stories
//

import UIKit

public struct LabelPropertiesContainer {
  public var text: String?
  public var lineHeightMultiple: CGFloat
  public var font: UIFont
  public var textColor: UIColor
  public var textAlignment: NSTextAlignment
  public var numberOfLines: Int
  public var spacingAfterLabel: CGFloat?
  
  public init(text: String?,
              lineHeightMultiple: CGFloat,
              font: UIFont,
              textColor: UIColor,
              textAlignment: NSTextAlignment,
              numberOfLines: Int,
              spacingAfterLabel: CGFloat? = nil) {
    self.text = text
    self.lineHeightMultiple = lineHeightMultiple
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.numberOfLines = numberOfLines
    self.spacingAfterLabel = spacingAfterLabel
  }
}
