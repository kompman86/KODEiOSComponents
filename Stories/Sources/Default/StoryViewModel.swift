//
//  StoryViewModel.swift
//  Stories
//

import UIKit

public protocol StoryViewModelDelegate: class {
  func storyViewModel(_ storyViewModel: StoryViewModel, storyContentViewModelFor frame: StoryFrame) -> StoryContentViewModelProtocol?
  func storyViewModel(_ storyViewModel: StoryViewModel, storyControlViewModel frame: StoryFrame) -> StoryControlViewModelProtocol?
}

extension StoryViewModelDelegate {
  func storyViewModel(_ storyViewModel: StoryViewModel, storyContentViewModelFor frame: StoryFrame) -> StoryContentViewModelProtocol? {
    return nil
  }
  
  func storyViewModel(_ storyViewModel: StoryViewModel, storyControlViewModel frame: StoryFrame) -> StoryControlViewModelProtocol? {
    return nil
  }
}

public class StoryViewModel: StoryViewModelProtocol {
  // MARK: - Properties
  
  public weak var delegate: StoryViewModelDelegate?
  
  public var topGradientOffset: CGFloat = 50
  public var bottomGradientOffset: CGFloat = -50
  public var gradientStartColor: UIColor? {
    let alpha = story.frames.element(at: currentFrameIndex)?.content.gradientStartAlpha ?? 0.7
    let color = story.frames.element(at: currentFrameIndex)?.content.gradientColor ?? .black
    return color.withAlphaComponent(alpha)
  }
  public var gradientEndColor: UIColor? {
    let color = story.frames.element(at: currentFrameIndex)?.content.gradientColor ?? .black
    return color.withAlphaComponent(0)
  }
  
  public var activityIndicatorStyle: UIActivityIndicatorView.Style
  public var activityIndicatorColor: UIColor? = nil
  public var storyFrameDuration: TimeInterval = 7
  public var controlsAnimationDuration: TimeInterval = 0.2
  
  public var storyContentViewModel: StoryContentViewModelProtocol? {
    guard let frame = currentFrame else { return nil }
    return delegate?.storyViewModel(self, storyContentViewModelFor: frame) ??
      StoryContentViewModel(frame: frame)
  }
  public var storyControlViewModel: StoryControlViewModelProtocol {
    guard let frame = currentFrame else { return StoryControlViewModel(colorMode: colorMode) }
    return delegate?.storyViewModel(self, storyControlViewModel: frame) ?? StoryControlViewModel(colorMode: colorMode)
  }
  public var storyLoadingErrorViewModel: StoryLoadingErrorViewModelProtocol
  public var shouldShowLoadingError: Bool = true
  
  public var contentViewTrailingLeadingInset: CGFloat = 16
  public var contentViewBottomOffset: CGFloat? = -24
  public var contentViewTopOffset: CGFloat? = 29
  
  public var controlsViewTopOffset: CGFloat = 32
  
  public var loadingErrorViewConstraints = ViewConstraintsContainer(leadingOffset: 16,
                                                                    trailingOffset: -16,
                                                                    centerYOffset: 0)
  
  public var shouldConfigureForIPhone10: Bool = true
  public var iPhone10ImageViewCornerRadius: CGFloat? = 8
  public var iPhone10ImageViewTopOffset: CGFloat? = 116
  public var iPhone10StoryControlViewViewTopOffset: CGFloat? = 52
  public var iPhone10ContentViewTopOffset: CGFloat? = 24
  public var iPhone10TrackColor: UIColor?
  public var iPhone10ProgressColor: UIColor?
  
  public var currentImageURL: URL? { return story.frames.element(at: currentFrameIndex)?.imageURL }
  public var storyPreviewURL: URL? { return story.imageURL }
  public var currentContentPosition: FrameContentPosition? {
    return story.frames.element(at: currentFrameIndex)?.content.position
  }
  public var framesCount: Int { return story.frames.count }
  
  public var likeButtonImage: UIImage? { return story.isLiked ? likedIcon : notLikedIcon }
  public var likedIcon: UIImage? = nil
  public var notLikedIcon: UIImage? = nil
  public var frameActionURL: String { return currentFrame?.content.action?.urlString ?? "" }
  
  public var imageViewBackgroundColor: UIColor
  public var imageViewErrorBackgroundColor: UIColor = .black
  
  public var backgroundColor: UIColor = .black
  
  public var trackColor: UIColor {
    guard let frame = currentFrame else { return UIColor.white.withAlphaComponent(0.2) }
    switch frame.content.controlsColorMode {
    case .dark:
      return UIColor.black.withAlphaComponent(0.2)
    case .light:
      return UIColor.white.withAlphaComponent(0.2)
    }
  }
  
  public var progressColor: UIColor {
    guard let frame = currentFrame else { return UIColor.white.withAlphaComponent(0.7) }
    switch frame.content.controlsColorMode {
    case .dark:
      return UIColor.black.withAlphaComponent(0.7)
    case .light:
      return UIColor.white.withAlphaComponent(0.7)
    }
  }
  
  public var progressViewSpacing: CGFloat = 11
  
  public var onDidReachEndOfStory: (() -> Void)?
  public var onDidReachBeginOfStory: (() -> Void)?
  public var onDidChangeFrameIndex: (() -> Void)?
  public var onDidSetFrameShown: (() -> Void)?
  public var onDidLikeStory: ((Bool) -> Void)?
  
  public var gradient: StoryFrameGradient? { return currentFrame?.content.gradient }
  public var borderOfChangeStoryInPercent: CGFloat = 30
  public var currentFrameIndex: Int = 0
  
  private var story: Story
  private var currentFrame: StoryFrame? { return story.frames.element(at: currentFrameIndex) }
  private var colorMode: FrameControlsColorMode { return currentFrame?.content.controlsColorMode ?? .light }
  
  // MARK: - Init
  
  public init(story: Story) {
    self.story = story
    
    let currentFrame = story.frames.element(at: currentFrameIndex)
    let colorMode = currentFrame?.content.controlsColorMode ?? .light
    storyLoadingErrorViewModel = StoryLoadingErrorViewModel(offlineTitle: "Error",
                                                            offlineSubtitle: "Error occurred",
                                                            serverErrorTitle: "Error",
                                                            serverErrorSubtitle: "Error occurred",
                                                            refreshButtonTitle: "Refresh")
    
    let lightModeColor: UIColor = .white
    let darkModeColor: UIColor = .black
    let trackAlpha: CGFloat = 0.2
    let progressAlpha: CGFloat = 0.7
    let lightModeTrackColor = lightModeColor.withAlphaComponent(trackAlpha)
    let lightModeProgressColor = lightModeColor.withAlphaComponent(progressAlpha)
    let darkModeTrackColor = darkModeColor.withAlphaComponent(trackAlpha)
    let darkModeProgressColor = darkModeColor.withAlphaComponent(progressAlpha)
    
    iPhone10TrackColor = lightModeTrackColor
    iPhone10ProgressColor = lightModeProgressColor
    
    switch colorMode {
    case .dark:
      activityIndicatorStyle = .white
      imageViewBackgroundColor = .white
    case .light:
      activityIndicatorStyle = .gray
      imageViewBackgroundColor = .black
    }
  }
  
  // MARK: - Methods
  
  public func toggleLike() {
    story.isLiked.toggle()
    onDidLikeStory?(story.isLiked)
  }
  
  public func setFrameShown() {
    guard currentFrameIndex >= 0, currentFrameIndex < story.frames.count else { return }
    story.frames[currentFrameIndex].isAlreadyShown = true
    onDidSetFrameShown?()
  }
  
  private func progressBarColor(for colorMode: FrameControlsColorMode) -> UIColor {
    switch colorMode {
    case .dark:
      return .black
    case .light:
      return .white
    }
  }
  
  private func progressColor(for colorMode: FrameControlsColorMode) -> UIColor {
    return progressBarColor(for: colorMode).withAlphaComponent(0.7)
  }
  
  private func trackColor(for colorMode: FrameControlsColorMode) -> UIColor {
    return progressBarColor(for: colorMode).withAlphaComponent(0.2)
  }
}
