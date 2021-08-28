//
//  StoriesListCellViewModel.swift
//  Stories
//

import UIKit

public class StoriesListCellViewModel: StoriesListCellViewModelProtocol {
  public var onDidSelect: (() -> Void)?
  
  public var titleProperties: LabelPropertiesContainer
  public var titleLabelConstraints: ViewConstraintsContainer
  
  public var contentViewBackgroundColor: UIColor = .black
  public var contentViewCornerRadius: CGFloat = 2
  public var contentViewAlpha: CGFloat
  
  public var activityIndicatorStyle: UIActivityIndicatorView.Style = .gray
  public var activityIndicatorColor: UIColor? = nil
  public var shadowColor: UIColor? = .black
  public var shadowOffset: CGSize = CGSize(width: 0, height: 2)
  public var shadowOpacity: Float = 0.1
  public var shadowRadius: CGFloat = 2
  
  public let imageURL: URL?
  
  public init(story: Story) {
    imageURL = story.imageURL
    
    titleProperties = LabelPropertiesContainer(text: story.title,
                                               lineHeightMultiple: 1.2,
                                               font: .boldSystemFont(ofSize: 14),
                                               textColor: .white,
                                               textAlignment: .natural,
                                               numberOfLines: 0)
    titleLabelConstraints = ViewConstraintsContainer(topOffset: 12, leadingOffset: 8, trailingOffset: -7)
    
    contentViewAlpha = story.hasNotShownFrames ? 1 : 0.7
  }
}
