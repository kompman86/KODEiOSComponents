//
//  StoryLoadingErrorViewModel.swift
//  Stories
//

import UIKit

class StoryLoadingErrorViewModel: StoryLoadingErrorViewModelProtocol {
  public var titlePropertiesForOfflineError: LabelPropertiesContainer
  public var titlePropertiesForServerError: LabelPropertiesContainer
  public var titleConstraints: ViewConstraintsContainer
  
  public var subtitlePropertiesForOfflineError: LabelPropertiesContainer?
  public var subtitlePropertiesForServerError: LabelPropertiesContainer?
  public var subtitleConstraints: ViewConstraintsContainer?
  
  public var refreshButtonProperties: ButtonPropertiesContainer
  public var refreshButtonConstraints: ViewConstraintsContainer
  
  public init(offlineTitle: String?, offlineSubtitle: String?,
              serverErrorTitle: String?, serverErrorSubtitle: String?,
              refreshButtonTitle: String?) {
    titlePropertiesForOfflineError = LabelPropertiesContainer(text: offlineTitle,
                                                              lineHeightMultiple: 1.3,
                                                              font: .systemFont(ofSize: 20),
                                                              textColor: .red,
                                                              textAlignment: .center,
                                                              numberOfLines: 0)
    titlePropertiesForServerError = LabelPropertiesContainer(text: serverErrorTitle,
                                                             lineHeightMultiple: 1.3,
                                                             font: .systemFont(ofSize: 20),
                                                             textColor: .red,
                                                             textAlignment: .center,
                                                             numberOfLines: 0)
    titleConstraints = ViewConstraintsContainer(topOffset: 0, leadingOffset: 0, trailingOffset: 0)
    
    if let offlineSubtitle = offlineSubtitle {
      subtitlePropertiesForOfflineError = LabelPropertiesContainer(text: offlineSubtitle,
                                                                   lineHeightMultiple: 1.4,
                                                                   font: .systemFont(ofSize: 17),
                                                                   textColor: .red,
                                                                   textAlignment: .center,
                                                                   numberOfLines: 0)
    }
    if let serverErrorSubtitle = serverErrorSubtitle {
      subtitlePropertiesForServerError = LabelPropertiesContainer(text: serverErrorSubtitle,
                                                                  lineHeightMultiple: 1.4,
                                                                  font: .systemFont(ofSize: 17),
                                                                  textColor: .red,
                                                                  textAlignment: .center,
                                                                  numberOfLines: 0)
    }
    if offlineSubtitle != nil || serverErrorSubtitle != nil {
      subtitleConstraints = ViewConstraintsContainer(topOffset: 8,leadingOffset: 0, trailingOffset: 0)
    }
    
    refreshButtonProperties = ButtonPropertiesContainer(backgroundColor: .red,
                                                        titleColor: .black,
                                                        title: refreshButtonTitle,
                                                        font: .systemFont(ofSize: 16),
                                                        image: nil)
    refreshButtonConstraints = ViewConstraintsContainer(topOffset: 40, bottomOffset: 0, centerXOffset: 0)
  }
}
