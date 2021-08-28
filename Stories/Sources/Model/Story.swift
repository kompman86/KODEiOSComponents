//
//  Story.swift
//  Stories
//

import UIKit

public struct Story {
  public var title: String
  public var imageURL: URL?
  public var frames: [StoryFrame]
  public var isLiked: Bool
  
  public var hasNotShownFrames: Bool {
    return frames.contains { !$0.isAlreadyShown }
  }
  
  public init(title: String, imageURL: URL?, frames: [StoryFrame], isLiked: Bool) {
    self.title = title
    self.imageURL = imageURL
    self.frames = frames
    self.isLiked = isLiked
  }
}
