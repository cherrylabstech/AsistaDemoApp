//
//  AttachmentCollectionViewCell.swift
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
protocol AttachmentCellActions: class {
    func removeItem(cell: AttachmentCell)
}

@available(iOS 9.0, *)
class AttachmentCell: UICollectionViewCell {
    
    weak var delegate: AttachmentCellActions?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(attachmentImage)
        attachmentImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        attachmentImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        attachmentImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        attachmentImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        
        contentView.addSubview(removeButton)
        removeButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 18.0).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
    }
    
    private lazy var attachmentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        return imageView
    } ()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isOpaque = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Helper.loadImage(name: "close"), for: .normal)
        button.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        return button
    } ()
  
    func populate(icon: UIImage?) {
        attachmentImage.image = icon
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        delegate?.removeItem(cell: self)
    }
}

extension UIImage {
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
