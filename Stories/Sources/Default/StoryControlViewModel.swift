//
//  StoryControlViewModel.swift
//  Stories
//

import UIKit

public class StoryControlViewModel: StoryControlViewModelProtocol {
  public var closeIcon: UIImage? = nil
  public var controlsTintColor: UIColor
  public var progressViewConstraints: ViewConstraintsContainer
  public var closeButtonConstraints: ViewConstraintsContainer
  public var likeButtonConstraints: ViewConstraintsContainer?
  
  public init(colorMode: FrameControlsColorMode) {
    switch colorMode {
    case .light:
      controlsTintColor = .white
    case .dark:
      controlsTintColor = .black
    }
    progressViewConstraints = ViewConstraintsContainer(topOffset: 0, leadingOffset: 16, trailingOffset: -16, height: 3)
    closeButtonConstraints = ViewConstraintsContainer(topOffset: 18, bottomOffset: 0, trailingOffset: -16, width: 40, height: 40)
    likeButtonConstraints = ViewConstraintsContainer(topOffset: 18, leadingOffset: 16, width: 40, height: 40)
  }
}
