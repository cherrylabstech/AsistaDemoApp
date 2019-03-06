//
//  LeftCommentCell.swift
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
import QuickLook
import AsistaCore
import IHProgressHUD

@available(iOS 9.0, *)
class LeftCommentCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var previewItem: URL!
    var attachmentList = [ShowAttachment]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .init(hex: 0xEFEBE7)
        self.selectionStyle = .none
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(chatHeadImage)
        chatHeadImage.translatesAutoresizingMaskIntoConstraints = false
        chatHeadImage.clipsToBounds = true
        chatHeadImage.layer.cornerRadius = chatHeadImage.frame.size.width / 2
        chatHeadImage.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        chatHeadImage.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        chatHeadImage.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        chatHeadImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: chatHeadImage.trailingAnchor, constant: 5).isActive = true
        containerView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var chatHeadImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        imageView.clipsToBounds = true
        return imageView
    } ()
    
    private lazy var containerView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .white
        uiView.layer.cornerRadius = 5
        
        uiView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -5).isActive = true
        return uiView
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerStackView, commentTextView, collectionView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        collectionView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.isOpaque = false
        return stackView
    } ()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        label.font = UIFont(name: "Helvetica-Bold", size: 15)
        label.textColor = .init(hex: 0x008F00)
        return label
    } ()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .right
        label.isOpaque = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(white: 0.667, alpha: 1)
        return label
    } ()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.isPagingEnabled = true
        textView.isMultipleTouchEnabled = true
        textView.clipsToBounds = true
        textView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        textView.autocapitalizationType = .sentences
        textView.font = UIFont(name: "Helvetica", size: 19)
        textView.dataDetectorTypes = [.phoneNumber, .link]
        return textView
    } ()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 30, height: 30)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        collectionView.isMultipleTouchEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(AttachmentViewCell.self, forCellWithReuseIdentifier: "AttachmentViewCell")
        return collectionView
    } ()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachmentViewCell.identifier, for: indexPath) as! AttachmentViewCell
        cell.attachmentImage.image = attachmentList[indexPath.row].fileIcon
        return cell
    }
    
    func populate(with comment: Note) {
        guard let imageUrl = comment.image else {
            self.chatHeadImage.image = Helper.loadImage(name: "user")
            return
        }
        try! AsistaCore.getInstance().getAttachmentService().fetchImage(url: imageUrl) { (result) in
            switch result {
            case .success(let imageData):
                self.chatHeadImage.image = UIImage(data: imageData)
            case .failed( _):
                self.chatHeadImage.image = Helper.loadImage(name: "user")
            }
        }

        let createTime = Double(comment.createTime)! + AsistaCore.timeZoneOffset
        dateLabel.text =  createTime.timestampToDate(as: "dd MMM yyyy | hh:mm a")
        nameLabel.text = comment.technicianId
        commentTextView.attributedText = comment.subject.htmlToAttributedString
   
        guard comment.attachment.count > 0 else {
            collectionView.isHidden = true
            return
        }
        attachmentList.removeAll()
        for item in comment.attachment {
            let urlPath = URL(string: item.url)
            let fileExt = urlPath!.pathExtension

            let imgName = Helper.attachmentIcon(for: fileExt)
            let img = Helper.loadImage(name: imgName)
            let item = ShowAttachment(fileUrl: urlPath, fileIcon: img)
            attachmentList.append(item)
        }
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        IHProgressHUD.show()
        let fileUrl = attachmentList[indexPath.row].fileUrl!.absoluteString
        try! AsistaCore.getInstance().getAttachmentService().downloadFile(fileUrl: fileUrl) { (result) in
            switch result {
            case .success(let destinationURL):
                let previewController = QLPreviewController()
                previewController.dataSource = self

                self.previewItem = destinationURL
                UIApplication.topViewController()?.present(previewController, animated: true, completion: nil)
            case .failed(let error):
                UIAlertController.presentAlert(title: "Alert", message: error.localizedDescription)
            }
            IHProgressHUD.dismiss()
            collectionView.reloadData()
        }
    }
}


@available(iOS 9.0, *)
extension LeftCommentCell: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
}
