//
//  BottomSheetViewController.swift
//  BottomSheetController
//
//

import UIKit

open class BottomSheetViewController: UIViewController {
  
  enum Actions {
    case add
    case move
    case remove
  }
  
  // MARK: Public Properties
  
  public var initialAnchorPointOffset: CGFloat = 0
  public var darkView: UIView?
  
  // MARK: Private properties
  
  private var topConstraint: NSLayoutConstraint?
  private var bottomConstraint: NSLayoutConstraint?
  private var leftConstraint: NSLayoutConstraint?
  private var rightConstraint: NSLayoutConstraint?
  private var widthConstraint: NSLayoutConstraint?
  private var heightConstraint: NSLayoutConstraint?
  
  private var sheetType: SheetType = .hiding
  private var panGesture: UIPanGestureRecognizer?
  private var scrollView: UIScrollView?
  private var height: CGFloat = 0
  private var previousAnchorPointIndex: Int?
  private var initialScrollViewContentOffset: CGPoint = .zero
  private var downView: UIView?
  
  private var defaultHeight: CGFloat {
    let topOffset = parentViewSize.height - initialAnchorPointOffset
    return parentViewSize.height - topOffset
  }
  
  private var parentView: UIView? {
    return parent?.view
  }
  
  private var parentViewSize: CGSize {
    return parentView?.frame.size ?? CGSize(width: 0, height: 0)
  }
  
  private var currentPointIndex: Int {
    guard let topConstraint = topConstraint?.constant else { return 0 }
    let anchorPoint = parentViewSize.height - topConstraint
    let anchorPointsLessCurrentPosition = allAnchorPoints.map { abs($0 - anchorPoint) }
    guard let minimumAnchorPointDifference = anchorPointsLessCurrentPosition.min() else { return 0 }
    return anchorPointsLessCurrentPosition.index(of: minimumAnchorPointDifference) ?? 0
  }
  
  private var currentPointOffset: CGFloat {
    return parentViewSize.height - (topConstraint?.constant ?? 0)
  }
  
  private var skipPointVerticalVelocity: CGFloat {
    return parentViewSize.height / 4
  }
  
  private var allAnchorPoints: [CGFloat] {
    var allAnchorPoints = [initialAnchorPointOffset].compactMap { $0 }
    
    if sheetType == .hiding {
      allAnchorPoints.append(0)
    }
    
    allAnchorPoints.append(contentsOf: middleAnchorPoints)
    return allAnchorPoints.sorted()
  }
  
  private var viewSize: CGSize {
    return CGSize(width: parentViewSize.width, height: height)
  }
  
  // MARK: Callbacks
  
  var onDidRemoveBottomSheetViewController: (() -> Void)?
  
  // MARK: Lifecycle
  
  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    makeRoundedCorners()
  }
  
  // MARK: Open Properties
  
  open var middleAnchorPoints: [CGFloat] {
    return []
  }
  
  open var cornerRadius: CGFloat {
    return 0
  }
  
  open var backgroundColor: UIColor {
    return .white
  }
  
  open var disableGestureView: UIView? {
    return nil
  }
  
  // MARK: Open Methods for observe
  
  open func didMove(to point: CGFloat) {
    if point == 0 {
      removeBottomViewControllerWithGesture()
    }
  }
  
  open func willMove(to point: CGFloat) { }
  open func didDrag(to point: CGFloat) { }
  
  // MARK: Setup
  
  func setup(superView: UIView, initialAnchorPointOffset: CGFloat = 0,
             height: CGFloat? = nil, sheetType: SheetType = .hiding) {
    self.initialAnchorPointOffset = initialAnchorPointOffset
    self.height = height ?? defaultHeight
    self.sheetType = sheetType
    
    view.translatesAutoresizingMaskIntoConstraints = false
    superView.addSubview(view)
    view.frame = CGRect(x: view.frame.origin.x,
                        y: superView.bounds.height,
                        width: superView.frame.width,
                        height: self.height)
    setupPanGestureRecognizer()
    setupConstraints()
    updageConstraints(parentViewSize: superView.frame.size,
                      customTopOffset: superView.frame.height - initialAnchorPointOffset)
  }
  
  private func setupPanGestureRecognizer() {
    scrollView?.panGestureRecognizer.addTarget(self, action: #selector(handleScrollViewGestureRecognizer(_ :)))
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_ :)))
    panGesture?.minimumNumberOfTouches = 1
    panGesture?.maximumNumberOfTouches = 1
    panGesture?.delegate = self
    
    guard let panGesture = panGesture else { return }
    view.addGestureRecognizer(panGesture)
  }
  
  private func setupConstraints() {
    guard let parentView = parentView else { return }
    
    topConstraint = view.topAnchor.constraint(equalTo: parentView.topAnchor)
    leftConstraint = view.leftAnchor.constraint(equalTo: parentView.leftAnchor)
    widthConstraint = view.widthAnchor.constraint(equalToConstant: parentViewSize.width)
    heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
    heightConstraint?.priority = .defaultHigh
    bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    bottomConstraint?.priority = .defaultLow
    
    let constraintsToActivate = [topConstraint,
                                 leftConstraint,
                                 widthConstraint,
                                 heightConstraint,
                                 bottomConstraint].compactMap { $0 }
    NSLayoutConstraint.activate(constraintsToActivate)
  }
  
  // MARK: Private functions
  
  private func updageConstraints(parentViewSize: CGSize, customTopOffset: CGFloat? = nil) {
    topConstraint?.constant = customTopOffset ?? anchorPointY(yVelocity: 0)
    leftConstraint?.constant = (parentViewSize.width - min(parentViewSize.width, parentViewSize.width)) / 2
    widthConstraint?.constant = viewSize.width
    heightConstraint?.constant = viewSize.height
    bottomConstraint?.constant = 0
  }
  
  private func anchorPointY(yVelocity: CGFloat) -> CGFloat {
    var currentPointIndex = self.currentPointIndex
    if abs(yVelocity) > skipPointVerticalVelocity {
      currentPointIndex = yVelocity > 0 ? max(currentPointIndex - 1, 0) : min(currentPointIndex + 1, allAnchorPoints.count - 1)
    }
    return parentViewSize.height - allAnchorPoints[currentPointIndex]
  }
  
  private func goToAnchorPoint(verticalVelocity: CGFloat) {
    guard let topConstraint = topConstraint else { return }
    
    let targetTopOffset = anchorPointY(yVelocity: verticalVelocity)
    let distanceToCover = topConstraint.constant - targetTopOffset
    let timeInterval = TimeInterval(abs(distanceToCover / verticalVelocity))
    let animationDuration = max(0.08, min(0.3, timeInterval))
    setTopOffset(targetTopOffset, animationDuration: animationDuration)
  }
  
  private func setTopOffset(_ value: CGFloat, animationDuration: TimeInterval? = nil, allowBounce: Bool = false) {
    let valueForBounce = getValueForBounce(allowBounce: allowBounce, value: value)
    let targetPoint = parentViewSize.height - valueForBounce
    updateDownViewAlpha(with: targetPoint)
    
    let shouldNotifyObserver = animationDuration != nil
    topConstraint?.constant = valueForBounce
    didDrag(to: targetPoint)
    
    if shouldNotifyObserver {
      didMove(to: targetPoint)
    }
    
    moveToPointWithAnimation(action: .move, duration: animationDuration ?? 0, animations: { [weak self] in
      self?.parentView?.layoutIfNeeded()
      }, completion: { [weak self] _ in
        guard let self = self else { return }
        
        if shouldNotifyObserver {
          self.didMove(to: targetPoint)
        }
    })
  }
  
  private func updateDownViewAlpha(with targetPoint: CGFloat) {
    guard let downView = downView else { return }
    if targetPoint < downView.frame.size.height {
      downView.alpha = 0
    } else {
      downView.alpha = 1
    }
  }
  
  private func getValueForBounce(allowBounce: Bool, value: CGFloat) -> CGFloat {
    guard let firsAnchorPoint = allAnchorPoints.first,
      let lastAnchorPoint = allAnchorPoints.last else { return 0 }
    
    let minValue = parentViewSize.height - lastAnchorPoint
    let maxValue = parentViewSize.height - firsAnchorPoint
    return max(min(value, maxValue), minValue)
  }
  
  private func updateFrameIfNeeded(animated: Bool) {
    let customTopOffset = parentViewSize.height - (allAnchorPoints.first ?? 0)
    updageConstraints(parentViewSize: parentViewSize, customTopOffset: customTopOffset)
    
    moveToPointWithAnimation(action: .move, duration: animated ? 0.3 : 0, animations: { [weak self] in
      self?.view.layoutIfNeeded()
      }, completion: nil)
  }
  
  private func makeRoundedCorners() {
    let size = CGSize(width: cornerRadius, height: cornerRadius)
    let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: size)
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    view.layer.mask = maskLayer
  }
  
  // MARK: Public functions
  
  public func moveTo(pointAtIndex index: Int, animated: Bool, completion: (() -> Void)?) {
    let visiblePoint = allAnchorPoints[index]
    topConstraint?.constant = parentViewSize.height - visiblePoint
    willMove(to: visiblePoint)
    
    moveToPointWithAnimation(action: .move, duration: animated ? 0.3 : 0, animations: { [weak self] in
      self?.parentView?.layoutIfNeeded()
      }, completion: { [weak self] _ in
        self?.willMove(to: visiblePoint)
        completion?()
    })
  }
  
  func moveDown(completion: (() -> Void)?) {
    let point = parentViewSize.height
    topConstraint?.constant = point
    willMove(to: point)
    onDidRemoveBottomSheetViewController?()
    
    moveToPointWithAnimation(action: .move, duration: 0.3, animations: { [weak self] in
      self?.parentView?.layoutIfNeeded()
      }, completion: { [weak self] _ in
        self?.willMove(to: point)
        completion?()
    })
  }
  
  func moveToPointWithAnimation(action: BottomSheetViewController.Actions,
                                duration: TimeInterval,
                                animations: @escaping () -> Void,
                                completion: ((Bool) -> Void)?) {
    
    switch action {
    case .move, .add:
      UIView.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 0.8,
                     initialSpringVelocity: 0.2,
                     options: .curveEaseInOut,
                     animations: animations,
                     completion: completion)
    default:
      UIView.animate(withDuration: 0.3,
                     animations: animations,
                     completion: completion)
    }
  }
  
  func hide() {
    guard let parentViewHeight = parentView?.frame.height else { return }
    topConstraint?.constant = parentViewHeight
  }
  
  func updateScrollView(scrollView: UIScrollView? = nil) {
    self.scrollView = scrollView
  }
  
  func updateDownView(_ view: UIView?) {
    self.downView = view
  }
  
  // MARK: Parent Methods
  
  override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    var targetAnchorPoint: CGFloat?
    previousAnchorPointIndex = currentPointIndex
    targetAnchorPoint = allAnchorPoints[previousAnchorPointIndex ?? 0]
    previousAnchorPointIndex = nil
    
    coordinator.animate(alongsideTransition: { [weak self] _ in
      self?.updageConstraints(parentViewSize: size)
      if let targetAnchorPoint = targetAnchorPoint {
        self?.moveTo(pointAtIndex: Int(targetAnchorPoint), animated: true, completion: nil)
      }
    })
  }
}

// MARK: Actions

extension BottomSheetViewController {
  
  @objc private func handleScrollViewGestureRecognizer(_ sender: UIPanGestureRecognizer) {
    guard let scrollView = scrollView,
      let topConstraint = topConstraint,
      let lastAnchorPoint = allAnchorPoints.last else { return }
    
    let isFullOpened = topConstraint.constant <= parentViewSize.height - lastAnchorPoint
    let isScrollingDown = sender.velocity(in: scrollView).y > 0
    let yTranslation = sender.translation(in: scrollView).y
    
    let shouldDragViewDown = isScrollingDown && scrollView.contentOffset.y <= 0
    let shouldDragViewUp = !isScrollingDown && !isFullOpened
    let shouldDragView = shouldDragViewDown || shouldDragViewUp
    
    if shouldDragView {
      scrollView.bounces = false
      scrollView.setContentOffset(.zero, animated: false)
    }
    
    switch sender.state {
    case .began:
      initialScrollViewContentOffset = scrollView.contentOffset
    case .changed:
      guard shouldDragView else { break }
      let topOffset = topConstraint.constant + yTranslation - initialScrollViewContentOffset.y
      setTopOffset(topOffset)
      sender.setTranslation(initialScrollViewContentOffset, in: scrollView)
    case .ended:
      scrollView.bounces = true
      goToAnchorPoint(verticalVelocity: sender.velocity(in: view).y)
    default:
      break
    }
  }
  
  @objc private func handlePanGestureRecognizer(_ sender: UIPanGestureRecognizer) {
    guard let topConstraint = topConstraint else { return }
    let yTranslation = sender.translation(in: view).y
    
    switch sender.state {
    case .changed:
      setTopOffset(topConstraint.constant + yTranslation, allowBounce: true)
      sender.setTranslation(.zero, in: view)
    case .ended:
      goToAnchorPoint(verticalVelocity: sender.velocity(in: view).y)
    default:
      break
    }
  }
}

// MARK: UIGestureRecognizerDelegate

extension BottomSheetViewController: UIGestureRecognizerDelegate {
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    guard let disableGestureView = disableGestureView else { return true }
    if disableGestureView.bounds.contains(touch.location(in: disableGestureView)) {
      return false
    }
    return true
  }
}

extension BottomSheetViewController {
  
  private func removeBottomViewControllerWithGesture() {
    hide()
    onDidRemoveBottomSheetViewController?()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.moveToPointWithAnimation(action: .remove, duration: 0.3, animations: { [weak self] in
        self?.view.layoutIfNeeded()
        }, completion: { _ in
          self.remove()
      })
    }
  }
  
  func remove() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
  public func removeBottomSheetViewController(animated: Bool, completion: (() -> Void)? = nil) {
    downView?.alpha = 0
    onDidRemoveBottomSheetViewController?()
    moveDown(completion: { [weak self] in
      self?.remove()
      completion?()
    })
  }
}
