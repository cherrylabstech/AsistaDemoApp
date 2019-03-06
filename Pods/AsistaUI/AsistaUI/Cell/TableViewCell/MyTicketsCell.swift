//
//  MyTicketsCell.swift
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

@available(iOS 9.0, *)
class MyTicketsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    private func configureView() {
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(ticketSourceImage)
        ticketSourceImage.translatesAutoresizingMaskIntoConstraints = false
        ticketSourceImage.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        ticketSourceImage.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        ticketSourceImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        ticketSourceImage.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
        
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: ticketSourceImage.trailingAnchor, constant: 10.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var ticketSourceImage: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        return imageView
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerStackView, subjectLabel, footerStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ticketNoLabel, dateLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.isOpaque = false
        return stackView
    } ()
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priorityLabel, technicianLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.isOpaque = false
        return stackView
    } ()
  
    private lazy var ticketNoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(red: 0.596, green: 0.596, blue: 0.604, alpha: 1)
        return label
    } ()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .right
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        label.font = .systemFont(ofSize: 9)
        label.textColor = UIColor(white: 0.333, alpha: 1)
        label.isOpaque = false
        return label
    } ()
    
    private lazy var subjectLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    } ()
    
    private lazy var priorityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.contentMode = .left
        label.isOpaque = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        label.font = .systemFont(ofSize: 12)
        return label
    } ()
    
    private lazy var technicianLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.contentMode = .left
        label.isOpaque = false
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 300), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11)
        return label
    } ()
    
    func populate(with ticket: TicketPayload) {
        let ticketIcon = Helper.ticketIcon(condition: ticket.source)
        
        ticketSourceImage.image = Helper.loadImage(name: ticketIcon)
        ticketNoLabel.text = ticket.requestNo
        
        let dateInTimeStamp = Double(ticket.modifiedTime) + AsistaCore.timeZoneOffset
        dateLabel.text = "Updated : " + dateInTimeStamp.timestampToDate(as: "h:mm a, dd MMM yy")
        
        subjectLabel.text = ticket.subject
        technicianLabel.text = " | Agent : " + ticket.tech
        priorityLabel.text = ticket.state + " | " + ticket.priority
    }
}
