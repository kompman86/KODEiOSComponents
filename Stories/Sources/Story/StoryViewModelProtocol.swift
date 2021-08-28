//
//  StoryViewModelProtocol.swift
//  Stories
//

import UIKit

public protocol StoryViewModelProtocol: class {
  var storyFrameDuration: TimeInterval { get set }
  var controlsAnimationDuration: TimeInterval { get set }
  var borderOfChangeStoryInPercent: CGFloat { get set }
  
  var storyContentViewModel: StoryContentViewModelProtocol? { get }
  var storyControlViewModel: StoryControlViewModelProtocol { get }
  var storyLoadingErrorViewModel: StoryLoadingErrorViewModelProtocol { get set }
  var shouldShowLoadingError: Bool { get set }
  
  var contentViewTrailingLeadingInset: CGFloat { get set }
  var contentViewBottomOffset: CGFloat? { get set }
  var contentViewTopOffset: CGFloat? { get set }
  
  var controlsViewTopOffset: CGFloat { get set }
  
  var loadingErrorViewConstraints: ViewConstraintsContainer { get set }
  
  var shouldConfigureForIPhone10: Bool { get set }
  var iPhone10ImageViewCornerRadius: CGFloat? { get set }
  var iPhone10ImageViewTopOffset: CGFloat? { get set }
  var iPhone10StoryControlViewViewTopOffset: CGFloat? { get set }
  var iPhone10ContentViewTopOffset: CGFloat? { get set }
  var iPhone10TrackColor: UIColor? { get set }
  var iPhone10ProgressColor: UIColor? { get set }
  
  var currentImageURL: URL? { get }
  var storyPreviewURL: URL? { get }
  var currentContentPosition: FrameContentPosition? { get }
  var framesCount: Int { get }
  var likeButtonImage: UIImage? { get }
  var likedIcon: UIImage? { get set }
  var notLikedIcon: UIImage? { get set }
  var frameActionURL: String { get }
  var imageViewBackgroundColor: UIColor { get set }
  var imageViewErrorBackgroundColor: UIColor { get set }
  
  var backgroundColor: UIColor { get set }
  
  var trackColor: UIColor { get }
  var progressColor: UIColor { get }
  var progressViewSpacing: CGFloat { get set }
  
  var onDidReachEndOfStory: (() -> Void)? { get set }
  var onDidReachBeginOfStory: (() -> Void)? { get set }
  var onDidChangeFrameIndex: (() -> Void)? { get set }
  var onDidLikeStory: ((_ isLiked: Bool) -> Void)? { get set }
  var onDidSetFrameShown: (() -> Void)? { get set }
  
  var gradient: StoryFrameGradient? { get }
  
  var topGradientOffset: CGFloat { get set }
  var bottomGradientOffset: CGFloat { get set }
  var gradientStartColor: UIColor? { get }
  var gradientEndColor: UIColor? { get }
  
  var activityIndicatorStyle: UIActivityIndicatorView.Style { get set }
  var activityIndicatorColor: UIColor? { get set }
  
  var currentFrameIndex: Int { get set }
  
  func incrementCurrentFrameIndex()
  func decrementCurrentFrameIndex()
  func toggleLike()
  func setFrameShown()
}

extension StoryViewModelProtocol {
  public var topGradientOffset: CGFloat {
    return 0
  }
  public var bottomGradientOffset: CGFloat {
    return 0
  }
  public var gradientStartColor: UIColor? {
    return nil
  }
  public var gradientEndColor: UIColor? {
    nil
  }
  public var activityIndicatorStyle: UIActivityIndicatorView.Style {
    return .gray
  }
  
  public func incrementCurrentFrameIndex() {
    if currentFrameIndex == framesCount - 1 {
      onDidReachEndOfStory?()
    } else {
      currentFrameIndex += 1
      onDidChangeFrameIndex?()
    }
  }
  
  public func decrementCurrentFrameIndex() {
    if currentFrameIndex == 0 {
      onDidReachBeginOfStory?()
    } else {
      currentFrameIndex -= 1
      onDidChangeFrameIndex?()
    }
  }
}
