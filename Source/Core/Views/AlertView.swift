//
//  AlertView.swift
//  Redbeard
//
//  Created by Nick Bolton on 4/8/19.
//  Copyright © 2019 Playboy Enterprises International, Inc. All rights reserved.
//

import UIKit

public enum AlertActionType {
  case dismiss
  case noInternet
  case retryInternetRequest(handler: DefaultHandler)
  case retry(handler: DefaultHandler)
  case custom(action: String, handler: DefaultHandler)
}

public class AlertView: NiblessView {
  
  private let backgroundContainer: UIView = {
    let view = UIView()
    view.alpha = 0.0
    view.backgroundColor = UIColor.black.color(withAlpha: 0.3)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
    return view
  }()
  
  private let cardContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 14.0
    view.layer.applySketchShadow(color: .black,
                                 opacity: 0.5,
                                 x: 0.0,
                                 y: 2.0,
                                 blur: 6.0,
                                 spread: 0.0)
    return view
  }()
  
  private let centeringContainer = UIView()
  
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  private let actionButton: UIButton = {
    let button = UIButton()
    button.alpha = 0.5
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(UIColor.black.color(withAlpha: 0.5), for: .highlighted)
    button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let interactionGuard = InteractionGuard()
  
  private (set) public var actionType = AlertActionType.dismiss
  public var dismissHandler: DefaultHandler?
  private (set) public var message = ""
  
  private let dismissedRotationAngle: CGFloat = -5.0 * CGFloat.pi / 180.0 // -5 degrees in radians
  
  private var isActionButtonVisible: Bool {
    switch actionType {
    case .noInternet:
      return false
    default:
      return true
    }
  }
  
  private var isDismissable: Bool {
    switch actionType {
    case .noInternet, .retry(_), .retryInternetRequest(_):
      return false
    default:
      return true
    }
  }
  
  private var messageBaselineToActionButtonConstraint: NSLayoutConstraint?
  private var messageBaselineConstraint: NSLayoutConstraint?
  
  // MARK: Text Styles
  
  private func messageStyle(message: String) -> TextStyle {
    let font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    let descriptor = TextDescriptor(text: message, font: font, textColor: .black, lineHeight: 17.0, textAlignment: .center)
    return TextStyle(textDescriptors: [descriptor])
  }
  
  private func actionStyle(message: String) -> TextStyle {
    let font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    let descriptor = TextDescriptor(text: message, font: font, textColor: .black, textAlignment: .center)
    return TextStyle(textDescriptors: [descriptor])
  }
  
  // MARK: View Hierarchy Construction
  
  override public func constructHierarchy() {
    super.constructHierarchy()
    addSubview(backgroundContainer)
    addSubview(cardContainer)
    cardContainer.addSubview(centeringContainer)
    centeringContainer.addSubview(messageLabel)
    centeringContainer.addSubview(actionButton)
  }
  
  override public func activateConstraints() {
    super.activateConstraints()
    constrainBackgroundContainer()
    constrainCardContainer()
    constrainCenteringContainer()
    constrainMessageLabel()
    constrainActionButton()
  }
  
  private func constrainBackgroundContainer() {
    backgroundContainer.expand()
  }

  private func constrainCardContainer() {
    let width: CGFloat = 270.0
    cardContainer.centerView()
    cardContainer.layout(width: width)
  }
  
  private func constrainCenteringContainer() {
    let topSpace: CGFloat = 35.0
    let bottomSpace: CGFloat = 17.0
    centeringContainer.expandWidth()
    centeringContainer.alignTop(offset: topSpace)
    centeringContainer.alignBottom(offset: -bottomSpace)
  }
  
  private func constrainMessageLabel() {
    let sideMargins: CGFloat = 27.0
    let baselineOffset: CGFloat = 17.5
    let style = messageStyle(message: "Dummy Text")
    messageLabel.alignTop(for: style)
    messageLabel.alignLeft(offset: sideMargins)
    messageLabel.alignRight(offset: -sideMargins)
    messageBaselineConstraint = messageLabel.alignBaseline(offset: -baselineOffset)
    messageBaselineConstraint?.isActive = false
  }
  
  private func constrainActionButton() {
    let topSpace: CGFloat = 37.5
    actionButton.layout(height: UIButton.minTappableDimension)
    actionButton.alignBottom()
    actionButton.expandWidth()
    messageBaselineToActionButtonConstraint = actionButton.alignTop(for: actionStyle(message: "Dummy"), toBaselineOf: messageLabel, offset: topSpace)
    messageBaselineToActionButtonConstraint?.isActive = false
  }
    
  // MARK: Actions
  
  @objc private func actionButtonTapped() {
    interactionGuard.perform { handleAction() }
  }
  
  // MARK: Gestures
  
  @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
    guard gesture.state == .ended else { return }
    guard isDismissable else { return }
    interactionGuard.perform { dismiss() }
  }
  
  // MARK: Helpers
  
  private var cardTranslationY: CGFloat {
    // add a little extra so the card is completely
    return (bounds.height + cardContainer.bounds.height) / 2.0 + 20.0
  }
  
  public func show(message: String = "", type: AlertActionType = .dismiss, in view: UIView, onDismiss: DefaultHandler? = nil, onComplete: DefaultHandler? = nil) {
    dismissHandler = onDismiss
    configure(message: message, type: type, container: view)
    cardContainer.transform = CGAffineTransform(translationX: 0.0, y: cardTranslationY).rotated(by: dismissedRotationAngle)
    cardContainer.alpha = 0.0
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.96, easing: Easing.defaultEasing, animations: {
      self.backgroundContainer.alpha = 1.0
      self.cardContainer.alpha = 1.0
      self.cardContainer.transform = .identity
    }) { _ in
      onComplete?()
    }
  }
  
  public func dismiss(_ onComplete: DefaultHandler? = nil) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.96, easing: Easing.defaultEasing, animations: {
      self.backgroundContainer.alpha = 0.0
      self.cardContainer.alpha = 0.0
      self.cardContainer.transform = CGAffineTransform(translationX: 0.0, y: self.cardTranslationY).rotated(by: self.dismissedRotationAngle)
    }) { _ in
      self.dismissHandler?()
      self.dismissHandler = nil
      self.removeFromSuperview()
      onComplete?()
    }
  }
  
  private func configure(message msg: String, type: AlertActionType, container: UIView) {
    message = msg
    actionType = type
    configure(in: container)
    configureActionButton()
    configureMessage()
    layoutIfNeeded()
  }
  
  private func configure(in container: UIView) {
    container.addSubview(self)
    expand()
  }
  
  private func configureActionButton() {
    switch actionType {
    case .dismiss:
      actionButton.setTitle("alert.view.dismiss.title".localized(), for: .normal)
    case .retryInternetRequest(_):
      actionButton.setTitle("alert.view.retry.title".localized(), for: .normal)
    case .retry(_):
      actionButton.setTitle("alert.view.retry.title".localized(), for: .normal)
    case .custom(let action, _):
      actionButton.setTitle(action, for: .normal)
    case .noInternet:
      break
    }
    actionButton.isHidden = !isActionButtonVisible
  }
  
  private func configureMessage() {
    switch actionType {
    case .noInternet:
      message = "alert.view.no.internet.message".localized()
    case .retryInternetRequest(_):
      message = "alert.view.retry.connection.message".localized()
    default:
      break
    }
    messageLabel.attributedText = messageStyle(message: message).attributedString
    messageBaselineConstraint?.isActive = false
    messageBaselineToActionButtonConstraint?.isActive = false
    messageBaselineConstraint?.isActive = !isActionButtonVisible
    messageBaselineToActionButtonConstraint?.isActive = isActionButtonVisible
  }
  
  private func handleAction() {
    switch actionType {
    case .dismiss:
      dismiss()
    case .retryInternetRequest(let handler):
      dismiss(handler)
    case .retry(let handler):
      dismiss(handler)
    case .custom(_, let handler):
      dismiss(handler)
    case .noInternet:
      break
    }
  }
}
