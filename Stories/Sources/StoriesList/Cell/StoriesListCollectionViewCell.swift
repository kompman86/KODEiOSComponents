//
//  StoriesListCollectionViewCell.swift
//  Stories
//

import UIKit

public class StoriesListCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
  // MARK: - Properties
  
  private var imageURL: URL?
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let activityIndicatorView = UIActivityIndicatorView()
  
  // MARK: - Init
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Update
  
  public func update(with viewModel: StoriesListCellViewModelProtocol) {
    contentView.alpha = viewModel.contentViewAlpha
    activityIndicatorView.style = viewModel.activityIndicatorStyle
    activityIndicatorView.color = viewModel.activityIndicatorColor
    
    if imageURL != viewModel.imageURL {
      imageURL = viewModel.imageURL
      activityIndicatorView.startAnimating()
      imageView.setImage(with: viewModel.imageURL) { [weak self] image, _ in
        self?.imageView.image = image
        self?.activityIndicatorView.stopAnimating()
      }
    }
    
    titleLabel.configure(with: viewModel.titleProperties)
    
    contentView.layer.cornerRadius = viewModel.contentViewCornerRadius
    contentView.backgroundColor = viewModel.contentViewBackgroundColor
    
    layer.shadowRadius = viewModel.shadowRadius
    layer.shadowColor = viewModel.shadowColor?.cgColor
    layer.shadowOffset = viewModel.shadowOffset
    layer.shadowOpacity = viewModel.shadowOpacity
    
    titleLabel.snp.removeConstraints()
    titleLabel.setEqualToSuperviewConstraints(from: viewModel.titleLabelConstraints)
  }
  
  // MARK: - Setup
  
  private func setup() {
    layer.masksToBounds = false
    contentView.layer.masksToBounds = true
    
    setupImageView()
    contentView.addSubview(titleLabel)
    setupActivityIndicatorView()
  }
  
  private func setupImageView() {
    contentView.addSubview(imageView)
    imageView.contentMode = .scaleAspectFill
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupActivityIndicatorView() {
    contentView.addSubview(activityIndicatorView)
    activityIndicatorView.hidesWhenStopped = true
    activityIndicatorView.isHidden = true
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
