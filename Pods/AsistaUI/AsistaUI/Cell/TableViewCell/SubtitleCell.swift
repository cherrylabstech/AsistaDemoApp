//
//  SubtitleCell.swift
//
//  Copyright (c) 2019 Cherrylabs Technologies (http://cherrylabs.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit

@available(iOS 9.0, *)
class SubtitleCell: UITableViewCell {
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let marginGuide = contentView.layoutMarginsGuide
    
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailTextView])
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 2
        stackView.isOpaque = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.text = "Label"
        label.contentMode = .left
        label.isOpaque = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(white: 0.333, alpha: 1)
        return label
    } ()
    
    lazy var detailTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .justified
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isMultipleTouchEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.clipsToBounds = true
        textView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .vertical)
        textView.backgroundColor = UIColor(white: 1, alpha: 1)
        textView.font = UIFont(name: ".AppleSystemUIFont", size: 16)
        textView.autocapitalizationType = .sentences
        return textView
    } ()
}
