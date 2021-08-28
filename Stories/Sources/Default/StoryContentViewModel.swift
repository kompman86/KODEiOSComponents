//
//  StoryContentViewModel.swift
//  Stories
//

import UIKit

public class StoryContentViewModel: StoryContentViewModelProtocol {
  public var contentAlignment: UIStackView.Alignment? = .leading
  public var spacing: CGFloat? = 16
  public var header1Properties: LabelPropertiesContainer?
  public var header2Properties: LabelPropertiesContainer?
  public var actionButtonProperties: ButtonPropertiesContainer?
  public var actionButtonHeight: CGFloat = 56
  public var paragraphsProperties: [LabelPropertiesContainer]
  
  public init(frame: StoryFrame) {
    header1Properties = LabelPropertiesContainer(text: frame.content.header1,
                                                 lineHeightMultiple: 1.2,
                                                 font: .systemFont(ofSize: 32),
                                                 textColor: frame.content.textColor,
                                                 textAlignment: .natural,
                                                 numberOfLines: 0)
    header2Properties = LabelPropertiesContainer(text: frame.content.header2,
                                                 lineHeightMultiple: 1.4,
                                                 font: .systemFont(ofSize: 23),
                                                 textColor: frame.content.textColor,
                                                 textAlignment: .natural,
                                                 numberOfLines: 0)
    if (frame.content.action?.text).isEmptyOrNil {
      actionButtonProperties = nil
    } else {
      actionButtonProperties = ButtonPropertiesContainer(backgroundColor: .green,
                                                         cornerRadius: 2,
                                                         titleColor: .black,
                                                         title: frame.content.action?.text,
                                                         font: .systemFont(ofSize: 16),
                                                         image: nil)
    }
    
    paragraphsProperties = frame.content.paragraphs.map {
      LabelPropertiesContainer(text: $0,
                               lineHeightMultiple: 1.5,
                               font: .systemFont(ofSize: 16),
                               textColor: .black,
                               textAlignment: .natural,
                               numberOfLines: 0)
    }
  }
}
