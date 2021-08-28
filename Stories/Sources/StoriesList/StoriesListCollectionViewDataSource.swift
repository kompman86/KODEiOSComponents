//
//  StoriesListCollectionViewDataSource.swift
//  Stories
//

import UIKit

public class StoriesListCollectionViewDataSource: NSObject {
  public var onDidSelect: ((IndexPath) -> Void)?
  
  private weak var collectionView: UICollectionView?
  private var cellViewModels: [StoriesListCellViewModelProtocol] = []
  private var itemInset: CGFloat = 0
  private var storySize: CGSize = .zero
  private var contentInsets: UIEdgeInsets = .zero
  
  public func configure(collectionView: UICollectionView,
                        itemInset: CGFloat,
                        storySize: CGSize,
                        contentInsets: UIEdgeInsets) {
    self.collectionView = collectionView
    self.itemInset = itemInset
    self.storySize = storySize
    self.contentInsets = contentInsets
    self.collectionView?.delegate = self
    self.collectionView?.dataSource = self
    self.collectionView?.register(StoriesListCollectionViewCell.self,
                                  forCellWithReuseIdentifier: StoriesListCollectionViewCell.reuseIdentifier)
  }
  
  public func updateViewModels(_ viewModels: [StoriesListCellViewModelProtocol]) {
    self.cellViewModels = viewModels
  }
}

// MARK: - UICollectionViewDataSource

extension StoriesListCollectionViewDataSource: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellViewModels.count
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard var cellViewModel = cellViewModels.element(at: indexPath.row),
      let cell =
      collectionView.dequeueReusableCell(withReuseIdentifier: StoriesListCollectionViewCell.reuseIdentifier,
                                         for: indexPath) as? StoriesListCollectionViewCell else {
                                          return UICollectionViewCell()
    }
    
    cellViewModel.onDidSelect = { [unowned self] in
      self.onDidSelect?(indexPath)
    }
    cell.update(with: cellViewModel)
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension StoriesListCollectionViewDataSource: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cellViewModel = cellViewModels.element(at: indexPath.row) else { return }
    cellViewModel.select()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StoriesListCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
    return storySize
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return itemInset
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             insetForSectionAt section: Int) -> UIEdgeInsets {
    return contentInsets
  }
}
