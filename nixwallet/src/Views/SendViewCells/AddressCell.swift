//
//  AddressCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-12-16.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

class AddressCell : UIView {

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    var address: String? {
        return contentLabel.text
    }

    var didBeginEditing: (() -> Void)?
    var didReceivePaymentRequest: ((PaymentRequest) -> Void)?

    func setContent(_ content: String?) {
        contentLabel.text = content
        textField.text = content
    }

    var isEditable = false {
        didSet {
            gr.isEnabled = isEditable
        }
    }

    let textField = UITextField()
    let paste = ShadowButton(title: S.Send.pasteLabel, type: .tertiary)
    let scan = ShadowButton(title: S.Send.scanLabel, type: .tertiary)
    let ghost = ShadowButton(title: S.Send.ghostLabel, type: .tertiary)
    fileprivate let contentLabel = UILabel(font: .customBody(size: 14.0), color: .darkText)
    private let label = UILabel(font: .customBody(size: 16.0))
    fileprivate let gr = UITapGestureRecognizer()
    fileprivate let tapView = UIView()
    private let border = UIView(color: .secondaryShadow)

    private func setupViews() {
        addSubviews()
        addConstraints()
        setInitialData()
    }

    private func addSubviews() {
        addSubview(label)
        addSubview(contentLabel)
        addSubview(textField)
        addSubview(tapView)
        addSubview(border)
        addSubview(paste)
        addSubview(scan)
        addSubview(ghost)
    }

    private func addConstraints() {
        label.constrain([
            label.constraint(.centerY, toView: self),
            label.constraint(.leading, toView: self, constant: C.padding[2]) ])
        contentLabel.constrain([
            contentLabel.constraint(.leading, toView: label),
            contentLabel.constraint(toBottom: label, constant: 0.0),
            contentLabel.trailingAnchor.constraint(equalTo: paste.leadingAnchor, constant: -C.padding[1]) ])
        textField.constrain([
            textField.constraint(.leading, toView: label),
            textField.constraint(toBottom: label, constant: 0.0),
            textField.trailingAnchor.constraint(equalTo: paste.leadingAnchor, constant: -C.padding[1]) ])
        tapView.constrain([
            tapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tapView.topAnchor.constraint(equalTo: topAnchor),
            tapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tapView.trailingAnchor.constraint(equalTo: paste.leadingAnchor) ])
        
        ghost.constrain([
            ghost.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.padding[2]),
            ghost.centerYAnchor.constraint(equalTo: centerYAnchor) ])
        scan.constrain([
            scan.centerYAnchor.constraint(equalTo: centerYAnchor),
            scan.trailingAnchor.constraint(equalTo: ghost.leadingAnchor, constant: -C.padding[1]) ])
        paste.constrain([
            paste.centerYAnchor.constraint(equalTo: centerYAnchor),
            paste.trailingAnchor.constraint(equalTo: scan.leadingAnchor, constant: -C.padding[0]) ])
        
        border.constrain([
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1.0) ])
    }

    private func setInitialData() {
        label.text = S.Send.toLabel
        textField.font = contentLabel.font
        textField.textColor = contentLabel.textColor
        textField.isHidden = true
        textField.returnKeyType = .done
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        label.textColor = .grayTextTint
        contentLabel.lineBreakMode = .byTruncatingMiddle

        textField.editingChanged = strongify(self) { myself in
            myself.contentLabel.text = myself.textField.text
        }

        //GR to start editing label
        gr.addTarget(self, action: #selector(didTap))
        tapView.addGestureRecognizer(gr)
    }

    @objc private func didTap() {
        textField.becomeFirstResponder()
        contentLabel.isHidden = true
        textField.isHidden = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
        contentLabel.isHidden = true
        gr.isEnabled = false
        tapView.isUserInteractionEnabled = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        contentLabel.isHidden = false
        textField.isHidden = true
        gr.isEnabled = true
        tapView.isUserInteractionEnabled = true
        contentLabel.text = textField.text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let request = PaymentRequest(string: string) {
            didReceivePaymentRequest?(request)
            return false
        } else {
            return true
        }
    }
}
