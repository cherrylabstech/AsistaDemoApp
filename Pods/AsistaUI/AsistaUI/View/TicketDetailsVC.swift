//
//  TicketDetailsVC.swift
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
import AsistaCore
import IHProgressHUD

@available(iOS 11.0, *)
class TicketDetailsVC: UIViewController {
    
    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
    var requestId: Int = 0
    private var selectedMenuIndex = 0
    private var selectedState: String = ""
    private var selectedPriority: String = ""
    private var iconList     = [UIImage]()
    private var ticketAttachmentList  = [ShowAttachment]()
    private var commentAttachmentList = [UploadAttachment]()
    private var ticket: TicketDetail?
    private var commentList  = [Note]()
    private var stateList    = [State]()
    private var priorityList = [Priority]()
    
    private var labelText    = [String]()
    private var labelValue   = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        fetchTicketDetails(requestId: requestId)
        menuTabbar.selectedItem = menuTabbar.items![0] as UITabBarItem
    }
  
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        closeViewController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        }
        else {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subjectLabel, stateLabel, dateStackView])
        stackView.isOpaque = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var subjectLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 800), for: .vertical)
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    } ()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.667, alpha: 1)
        return label
    } ()

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, attachmentLabel])
        stackView.isOpaque = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.667, alpha: 1)
        return label
    } ()

    private lazy var attachmentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.font = .systemFont(ofSize: 14)
        return label
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, menuTabbar, tableView, footerStackView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        
        headerView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        menuTabbar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        commentInputView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
 
    private lazy var headerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .init(hex: 0xEFEFF4)
        
        uiView.addSubview(ticketSourceImage)
        ticketSourceImage.translatesAutoresizingMaskIntoConstraints = false
        ticketSourceImage.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        ticketSourceImage.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        ticketSourceImage.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 8).isActive = true
        ticketSourceImage.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 8).isActive = true
        
        uiView.addSubview(labelsStackView)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.leadingAnchor.constraint(equalTo: ticketSourceImage.trailingAnchor, constant: 8).isActive = true
        labelsStackView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -8).isActive = true
        labelsStackView.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 0).isActive = true
        labelsStackView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -8).isActive = true
        
        return uiView
    } ()
    
    private lazy var ticketSourceImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        return imageView
    } ()
    
    private lazy var menuTabbar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.delegate = self
        tabBar.contentMode = .scaleAspectFit
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = UIColor.groupTableViewBackground
        tabBar.itemPositioning = .centered
        
        let commentItem = UITabBarItem(title: "Comments", image: Helper.loadImage(name: "comment"), tag: 0)
        let stateItem = UITabBarItem(title: "State", image: Helper.loadImage(name: "state"), tag: 1)
        let priorityItem = UITabBarItem(title: "Priority", image: Helper.loadImage(name: "priority"), tag: 2)
        let infoItem = UITabBarItem(title: "Info", image: Helper.loadImage(name: "ticketinfo"), tag: 3)
        
        tabBar.setItems([commentItem, stateItem, priorityItem, infoItem], animated: false)
        return tabBar
    } ()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = -1
        tableView.sectionHeaderHeight = 28
        tableView.sectionFooterHeight = 28
        tableView.bouncesZoom = false
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor(red: 0.937, green: 0.922, blue: 0.906, alpha: 1)
        
        tableView.register(LeftCommentCell.self, forCellReuseIdentifier: "LeftCommentCell")
        tableView.register(RightCommentCell.self, forCellReuseIdentifier: "RightCommentCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StateCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PriorityCell")
        tableView.register(TicketAttachmentCell.self, forCellReuseIdentifier: "TicketAttachmentCell")
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: "SubtitleCell")
        return tableView
    } ()

    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView, commentInputView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        
        collectionView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        commentInputView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        collectionView.isMultipleTouchEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(AttachmentCell.self, forCellWithReuseIdentifier: "AttachmentCell")
        return collectionView
    } ()
    
    private lazy var commentInputView: UIView = {
        let uiView = UIView()
        uiView.addSubview(addAttachmentButton)
        uiView.addSubview(commentText)
        uiView.addSubview(replyButton)
        
        addAttachmentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addAttachmentButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addAttachmentButton.centerYAnchor.constraint(equalTo: uiView.centerYAnchor).isActive = true
        addAttachmentButton.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 5).isActive = true

        commentText.leadingAnchor.constraint(equalTo: addAttachmentButton.trailingAnchor, constant: 5).isActive = true
        commentText.centerYAnchor.constraint(equalTo: uiView.centerYAnchor).isActive = true
        commentText.trailingAnchor.constraint(equalTo: replyButton.leadingAnchor, constant: -5).isActive = true
        
        replyButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        replyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        replyButton.centerYAnchor.constraint(equalTo: uiView.centerYAnchor, constant: 2).isActive = true
        replyButton.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: 0).isActive = true

        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .init(hex: 0xF9F9F9)
        return uiView
    } ()
    
    private lazy var addAttachmentButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
        button.isOpaque = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        button.setImage(Helper.loadImage(name: "add"), for: .normal)
        button.addTarget(self, action: #selector(attachmentButtonTapped(_:)), for: .touchUpInside)
        return button
    } ()
    
    private lazy var commentText: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .natural
        textField.borderStyle = .roundedRect
        textField.minimumFontSize = 17
        textField.placeholder = "Write a comment"
        textField.contentHorizontalAlignment = .left
        textField.isOpaque = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(UILayoutPriority(rawValue: 750), for: .horizontal)
        textField.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        textField.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        textField.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .webSearch
        textField.addTarget(self, action: #selector(commentTextEditingDidEnd), for: .editingChanged)
        return textField
    } ()

    private lazy var replyButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
        button.contentMode = .scaleAspectFit
        button.isOpaque = false
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 5)
        button.setImage(Helper.loadImage(name: "send"), for: .normal)
        button.addTarget(self, action: #selector(replyButtonTapped(_:)), for: .touchUpInside)
        return button
    } ()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IHProgressHUD.dismiss()
    }
    
    @objc func commentTextEditingDidEnd(_ textField: UITextField) {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            replyButton.isEnabled = false
            return
        }
        replyButton.isEnabled = true
    }
    
    
    /********************************************* USER DEFINED FUNCTIONS *******************************************************/
    
    
    /// Fetching ticket details from Asista SDK
    ///
    /// - Parameter requestId: Unique id for each ticket.
    private func fetchTicketDetails(requestId: Int) {
        IHProgressHUD.show()
        try! AsistaCore.getInstance().getTicketService().fetchTicketDetails(requestId: requestId) { (result) in
            switch result {
            case .success(let ticket):
                IHProgressHUD.dismiss()
                self.populateLabels(with: ticket)
                self.populateComment(with: ticket.payload.notes)
                self.populateInfo(with: ticket)
                self.loadState(requestId: requestId)
                self.loadPriority()
            case .failed(let error):
                IHProgressHUD.dismiss()
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { ( _) in self.closeViewController() })
                UIAlertController.presentAlertWithAction(title: "Alert", message: error.localizedDescription, actions: [okAction])
            }
        }
    }
    
    private func populateLabels(with ticket: TicketDetail) {
        let payload = ticket.payload

        let ticketIcon = Helper.ticketIcon(condition: payload.source)
        ticketSourceImage.image = Helper.loadImage(name: ticketIcon)
        
        navigationItem.title = payload.requestNo
        subjectLabel.text = payload.subject
        selectedState = payload.userStateLabel
        selectedPriority = payload.priority
        stateLabel.text = selectedState + " | " + selectedPriority
        
        let createTime = Double(payload.createTime) + AsistaCore.timeZoneOffset
        dateLabel.text = "Created : " + createTime.timestampToDate(as: "hh:mm a, dd MMM yy")
        
        menuTabbar.items![1].title = ticket.header.state
        menuTabbar.items![2].title = ticket.header.priority
    }
    
    private func populateComment(with note: [Note]) {
        commentList = note
        DispatchQueue.main.async {
            self.tableView.reloadData()
            guard self.commentList.count > 0, self.selectedMenuIndex == 0 else { return }
            let indexPath = IndexPath(row: self.commentList.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
        }
    }
    
    /// Parsing `TicketDetail` data into tableview's datasource
    ///
    /// - Parameter ticket: Model object return by `TicketDetails` Api
    private func populateInfo(with ticket: TicketDetail) {
        let label = ticket.header
        let requestNoLabel =  label.requestNo
        let companyLabel = label.company
        let subjectLabel = label.subject
        let createTimeLabel = label.createdTime
        let modifiedTimeLabel = label.modifiedTime
        let assetsLabel = label.assets
        let technicianLabel = label.technician

        let payload = ticket.payload
        let requestNo = payload.requestNo
        let subject = payload.subject
        let description = payload.description.withoutHtmlTags
        let company = payload.company ?? "nil"
        let category = payload.category
        let item = payload.item
        let team = payload.team
        let tech = payload.tech
        let createTime = Double(payload.createTime) + AsistaCore.timeZoneOffset
        let createTimeText = createTime.timestampToDate(as: "dd MMM yyyy | hh:mm a")

        let modifiedTime = Double(payload.modifiedTime) + AsistaCore.timeZoneOffset
        let modifiedTimeText = modifiedTime.timestampToDate(as: "dd MMM yyyy | hh:mm a")

        self.labelText = [requestNoLabel, subjectLabel, "Description", companyLabel, "Category", assetsLabel, "Team", technicianLabel, createTimeLabel, modifiedTimeLabel]
        self.labelValue = [requestNo, subject, description, company, category, item, team, tech, createTimeText, modifiedTimeText]

        for customField in payload.customFields {
            self.labelText.append(customField.name!)
            if customField.type == "textarea" {
                let text = (customField.data!).withoutHtmlTags
                self.labelValue.append(text)
            }
            else {
                self.labelValue.append(customField.data ?? "nil")
            }
        }

        self.ticketAttachmentList.removeAll()
        for urlItem in payload.attachment {
            let url = URL(string: urlItem.url)!
            let ext = url.pathExtension

            let imageName = Helper.attachmentIcon(for: ext)
            let icon = Helper.loadImage(name: imageName)

            let imageItem = ShowAttachment(fileUrl: url, fileIcon: icon)
            self.ticketAttachmentList.append(imageItem)
        }
        if self.ticketAttachmentList.count > 0 {
            self.attachmentLabel.text = " | \u{1F4CE}"
            self.labelText.insert("nil", at: 0)
            self.labelValue.insert("nil", at: 0)
        }
    }
    
    
    /// Fetching workflow states of a ticket
    ///
    /// - Parameter requestId: id of the ticket.
    private func loadState(requestId: Int) {
        stateList.removeAll()
        try! AsistaCore.getInstance().getStateService().fetchWorkflowStates(requestId: requestId) { (result) in
            switch result {
            case .success(let states):
                self.stateList = states
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
    
    
    /// Fetching priority list from asista SDK
    private func loadPriority() {
        priorityList.removeAll()
        try! AsistaCore.getInstance().getPriorityService().fetchPriorityList { (result) in
            switch result {
            case .success(let priority):
                self.priorityList = priority
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
}

/********************************************* TABLE VIEW *******************************************************/
@available(iOS 11.0, *)
extension TicketDetailsVC:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedMenuIndex {
        case 0:
            tableView.dataSource(commentList.count, text: "No comments")
            return commentList.count
        case 1:
            tableView.dataSource(stateList.count, text: "No states")
            return stateList.count
        case 2:
            tableView.dataSource(priorityList.count)
            return priorityList.count
        case 3:
            tableView.dataSource(labelText.count)
            return labelText.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedMenuIndex {
        case 0:
            tableView.separatorStyle = .none
            if commentList.count > 0 && commentList.indices.contains(indexPath.row) {
                if commentList[indexPath.row].userId == AsistaCore.userId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: RightCommentCell.identifier, for: indexPath) as! RightCommentCell
                    cell.populate(with: commentList[indexPath.row])
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LeftCommentCell.identifier, for: indexPath) as! LeftCommentCell
                    cell.populate(with: commentList[indexPath.row])
                    return cell
                }
            }
            return UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath)
            if stateList.count > 0 && stateList.indices.contains(indexPath.row) {
                let state = stateList[indexPath.row]
                cell.textLabel?.text = state.stateType
                cell.accessoryType = (state.stateType == selectedState) ? .checkmark : .none
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell", for: indexPath)
            if priorityList.count > 0 && priorityList.indices.contains(indexPath.row) {
                let priority = priorityList[indexPath.row]
                cell.textLabel?.text = priority.priorityState
                cell.accessoryType = (priority.priorityState == selectedPriority) ? .checkmark : .none
            }
            return cell
        case 3:
            if ticketAttachmentList.count > 0 && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TicketAttachmentCell.identifier, for: indexPath) as! TicketAttachmentCell
                cell.populate(with: ticketAttachmentList)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.identifier, for: indexPath) as! SubtitleCell
                if  labelText.count > 0 && labelText.indices.contains(indexPath.row) {
                    cell.titleLabel.text = labelText[indexPath.row]
                    cell.detailTextView.text = labelValue[indexPath.row] as? String ?? "nil"
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedMenuIndex {
        case 1:
            let state = stateList[indexPath.row]
            guard state.stateType != selectedState else { return }
            if state.noteStatus == true {
                let alert = UIAlertController(title: "Add Comment", message: "", preferredStyle: .alert)
                alert.addTextField { (commentText) -> Void in
                    commentText.placeholder = "Enter your comment here"
                    commentText.borderStyle = .none
                    commentText.clearButtonMode = .whileEditing
                    
                }
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [unowned self] Void in
                    guard let comment = alert.textFields![0].text, !comment.isEmpty  else {
                        UIAlertController.presentAlert(title: "Alert", message: "Please enter comment.")
                        return
                    }
                    self.updateTicketState(to: state, subject: comment)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(cancelAction)
                alert.addAction(saveAction)
                alert.preferredAction = saveAction
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let okAction = UIAlertAction(title: "YES", style: .default) { (_) in
                    self.updateTicketState(to: state)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                UIAlertController.presentAlertWithAction(title: "Alert", message: "Do you want to change the state?", actions: [okAction, cancelAction])
            }
        case 2:
            let priority = self.priorityList[indexPath.row]
            guard priority.priorityState != selectedPriority else { return }
            let okAction = UIAlertAction(title: "YES", style: .default) { (_) in
                self.updateTicketPriority(with: priority)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            UIAlertController.presentAlertWithAction(title: "Alert", message: "Do you want to change the priority?", actions: [okAction, cancelAction])
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    /// Updating state of ticket
    ///
    /// - Parameters:
    ///   - state: Object of `State` model which represents the next state.
    ///   - subject: Optional comment added to the state change.
    private func updateTicketState(to state: State, subject: String? = nil) {
        let stateBody: [String: Any] = ["contentType": "text/plain",
                                        "is_private": "false",
                                        "requestId": self.requestId,
                                        "role": 1,
                                        "status": state.id,
                                        "subject": subject as Any]
        
        try! AsistaCore.getInstance().getStateService().updateTicketState(parameters: stateBody) { (result) in
            switch result {
            case .success( _):
                self.selectedState = state.stateType
                self.fetchTicketDetails(requestId: self.requestId)
            case .failed(let error):
                UIAlertController.presentAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }
    
    
    /// Updating priority of ticket
    ///
    /// - Parameter priority: Object of `Priority` model.
    private func updateTicketPriority(with priority: Priority) {
        let parameters: [String: Int] = ["requestId": requestId, "priorityId": priority.priorityID]
        try! AsistaCore.getInstance().getPriorityService().updateTicketPriority(parameters: parameters) { (result) in
            switch result {
            case .success( _):
                self.selectedPriority = priority.priorityState
                self.fetchTicketDetails(requestId: self.requestId)
            case .failed(let error):
                UIAlertController.presentAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }
}

/********************************************** COLLECTION VIEW *************************************************/
@available(iOS 11.0, *)

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TicketDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.isHidden = iconList.count == 0 ? true : false
        return iconList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachmentCell.identifier, for: indexPath) as! AttachmentCell
        if iconList.count > 0 {
            cell.populate(icon: iconList[indexPath.row])
            cell.delegate = self
        }
        return cell
    }
}

/***************************************************************************************************************/

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, AttachmentCellActions

@available(iOS 11.0, *)
extension TicketDetailsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, AttachmentCellActions {
    func removeItem(cell: AttachmentCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            iconList.remove(at: indexPath.row)
            commentAttachmentList.remove(at: indexPath.row)
            collectionView.reloadData()
        }
    }
    
    @objc func replyButtonTapped(_ sender: UIButton) {
        guard let commentText = commentText.text, !commentText.isEmpty else { return }
        replyButton.isEnabled = false
        
        var attachmentDictionary: [[String: Any]] = []
        for item in commentAttachmentList {
            let attachItem: [String: Any] = ["id": item.id, "url": item.url]
            attachmentDictionary.append(attachItem)
        }
        
        let commentBody: [String : Any] = ["attachmentId": attachmentDictionary,
                                    "contentType": "text/plain",
                                    "description": "No description",
                                    "requestId": requestId,
                                    "subject": commentText]
        try! AsistaCore.getInstance().getTicketService().addComment(with: commentBody) { (result) in
            switch result {
            case .success( _):
                self.view.endEditing(true)
                self.commentText.text = ""
                self.fetchTicketDetails(requestId: self.requestId)
                self.iconList.removeAll()
                self.commentAttachmentList.removeAll()
                self.collectionView.reloadData()
                
            case .failed(let error):
                UIAlertController.presentAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }
    
    
    @objc func attachmentButtonTapped(_ sender: UIButton) {
        let fileSize = AsistaCore.attachmentSize / 1000000
        let fileProperties = "Upload supported formats (\(AsistaCore.attachmentTypes.joined(separator: ", "))). Maximum size = \(fileSize) MB"
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { [unowned self] Void in
            Helper.isCameraPermissionAuthorized(completionHandler: { (status) in
                if status {
                    let camera = UIImagePickerController()
                    camera.delegate = self
                    camera.sourceType = .camera
                    DispatchQueue.main.async {
                        self.present(camera, animated: true)
                    }
                }
                else {
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    })
                    UIAlertController.presentAlertWithAction(title: "Asista does not have access to your camera. To enable access, tap Settings and turn on Camera.", message: "", actions: [settingsAction, cancelAction])
                }
            })
            
        })
        let imageButton = UIAlertAction(title: "Photo Library", style: .default, handler: { [unowned self] Void in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .photoLibrary
            DispatchQueue.main.async {
                self.present(image, animated: true)
            }
        })
        let docButton = UIAlertAction(title: "Document", style: .default, handler: { [unowned self] Void in
            let importMenu = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
            importMenu.delegate = self
            DispatchQueue.main.async {
                self.present(importMenu, animated: true)
            }
        })
        UIAlertController.presentActionSheet(title: "Upload File", message: fileProperties, actions: [cameraButton, imageButton, docButton])
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    
        let fileData = try! Data(contentsOf: url.absoluteURL)
        let fileSize = Int(fileData.count)
        let fileExt = url.pathExtension

        guard AsistaCore.attachmentTypes.contains(where: {
            $0.range(of: fileExt, options: .caseInsensitive) != nil
        }) else {
            UIAlertController.presentAlert(title: "Alert", message: "Sorry, the file type is not supported.")
            return
        }
        
        guard fileSize < AsistaCore.attachmentSize else {
            UIAlertController.presentAlert(title: "Alert", message: "The file you are attaching is bigger than server allows.")
            return
        }
        let imgName = Helper.attachmentIcon(for: fileExt)
        let icon = Helper.loadImage(name: imgName)

        uploadDocument(url: url, fileIcon: icon!)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let imageData = image.jpegData(compressionQuality: 0.8)
            let imageSize = Int(imageData!.count)
            
            guard imageSize < AsistaCore.attachmentSize else {
                UIAlertController.presentAlert(title: "Error", message: "The file you are attaching is bigger than server allows.")
                return
            }
            uploadImage(data: imageData!, name: "image.jpg", mimeType: "image/jpg", fileIcon: image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func uploadImage(data: Data, name: String, mimeType: String, fileIcon: UIImage) {
        IHProgressHUD.show()
        try! AsistaCore.getInstance().getTicketService().uploadAttachment(data: data, name: name, mimeType: mimeType) { (result) in
            switch result {
            case .success(let response):
                let attachmentItem = UploadAttachment(id: response.id, url: response.url)
                self.commentAttachmentList.append(attachmentItem)
                self.iconList.append(fileIcon)
                DispatchQueue.main.async {
                    IHProgressHUD.dismiss()
                    self.collectionView.reloadData()
                }
            case .failed(let error):
                IHProgressHUD.dismiss()
                UIAlertController.presentAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }
    
    private func uploadDocument(url: URL, fileIcon: UIImage) {
        IHProgressHUD.show()
        try! AsistaCore.getInstance().getTicketService().uploadAttachment(url: url) { (result) in
            switch result {
            case .success(let response):
                let attachmentItem = UploadAttachment(id: response.id, url: response.url)
                self.commentAttachmentList.append(attachmentItem)
                self.iconList.append(fileIcon)
                DispatchQueue.main.async {
                    IHProgressHUD.dismiss()
                    self.collectionView.reloadData()
                }
            case .failed(let error):
                IHProgressHUD.dismiss()
                UIAlertController.presentAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }
}


@available(iOS 11.0, *)
extension TicketDetailsVC: UITabBarDelegate {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabItemTag = tabBar.selectedItem?.tag, tabItemTag != selectedMenuIndex else { return }
        selectedMenuIndex = tabItemTag
        
        commentInputView.isHidden = (selectedMenuIndex == 0) ? false : true
        tableView.backgroundColor = (selectedMenuIndex == 0) ? .init(hex: 0xEFEBE7) : .white
        
        if selectedMenuIndex == 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                guard self.commentList.count > 0 else { return }
                let indexPath = IndexPath(row: self.commentList.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
        else if selectedMenuIndex == 1 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                guard self.stateList.count > 0 else { return }
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        else if selectedMenuIndex == 2 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                guard self.priorityList.count > 0 else { return }
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        else if selectedMenuIndex == 3 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                guard self.labelText.count > 0 else { return }
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
}
