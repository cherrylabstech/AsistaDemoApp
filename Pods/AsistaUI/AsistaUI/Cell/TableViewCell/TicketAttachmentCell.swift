//
//  TicketAttachmentCell.swift
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
class TicketAttachmentCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var previewItem: URL!
    var attachmentList = [ShowAttachment]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        contentView.addSubview(collectionView)
        
        let marginGuide = contentView.layoutMarginsGuide
        collectionView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func populate(with attachment: [ShowAttachment]) {
        attachmentList = attachment
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
                print(error.localizedDescription)
            }
            IHProgressHUD.dismiss()
            collectionView.reloadData()
        }
    }
}


@available(iOS 9.0, *)
extension TicketAttachmentCell: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
}
