//
//  StoryFrame.swift
//  Stories
//

import UIKit

public enum FrameControlsColorMode: String {
  case light
  case dark
}

public struct FrameAction {
  public let text: String
  public let urlString: String
  
  public init(text: String, urlString: String) {
    self.text = text
    self.urlString = urlString
  }
}

public struct StoryFrameContent {
  public let position: FrameContentPosition
  public let textColor: UIColor
  public let gradientColor: UIColor?
  public let gradientStartAlpha: CGFloat
  public let header1: String?
  public let header2: String?
  public let paragraphs: [String]
  public let action: FrameAction?
  public let controlsColorMode: FrameControlsColorMode
  public let gradient: StoryFrameGradient
  
  public init(position: FrameContentPosition,
              textColor: UIColor,
              header1: String?,
              header2: String?,
              paragraphs: [String],
              action: FrameAction?,
              controlsColorMode: FrameControlsColorMode,
              gradient: StoryFrameGradient,
              gradientColor: UIColor? = nil,
              gradientStartAlpha: CGFloat = 0.7) {
    self.position = position
    self.textColor = textColor
    self.header1 = header1
    self.header2 = header2
    self.paragraphs = paragraphs
    self.action = action
    self.controlsColorMode = controlsColorMode
    self.gradient = gradient
    self.gradientColor = gradientColor
    self.gradientStartAlpha = gradientStartAlpha
  }
}

public struct StoryFrame {
  public let content: StoryFrameContent
  public let imageURL: URL?
  
  public var isAlreadyShown: Bool
  
  public init(content: StoryFrameContent, imageURL: URL?, isAlreadyShown: Bool) {
    self.content = content
    self.imageURL = imageURL
    self.isAlreadyShown = isAlreadyShown
  }
}
