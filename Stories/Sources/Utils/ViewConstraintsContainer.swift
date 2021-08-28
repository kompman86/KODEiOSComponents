//
//  ViewConstraintsContainer.swift
//  Stories
//

import UIKit

public struct ViewConstraintsContainer {
  public var topOffset: CGFloat?
  public var bottomOffset: CGFloat?
  public var leadingOffset: CGFloat?
  public var trailingOffset: CGFloat?
  public var centerYOffset: CGFloat?
  public var centerXOffset: CGFloat?
  public var width: CGFloat?
  public var height: CGFloat?
  
  public init(topOffset: CGFloat? = nil,
              bottomOffset: CGFloat? = nil,
              leadingOffset: CGFloat? = nil,
              trailingOffset: CGFloat? = nil,
              centerYOffset: CGFloat? = nil,
              centerXOffset: CGFloat? = nil,
              width: CGFloat? = nil,
              height: CGFloat? = nil) {
    self.topOffset = topOffset
    self.bottomOffset = bottomOffset
    self.leadingOffset = leadingOffset
    self.trailingOffset = trailingOffset
    self.centerYOffset = centerYOffset
    self.centerXOffset = centerXOffset
    self.width = width
    self.height = height
  }
}
