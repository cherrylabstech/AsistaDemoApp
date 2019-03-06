//
//  AssetDetailsTVC.swift
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


import Foundation
import AsistaCore

@available(iOS 9.0, *)
class AssetDetailTVC: UITableViewController {
    
    var assetId : Int?
    var labelText = [String]()
    var labelValue = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = assetId {
            tableView.register(SubtitleCell.self, forCellReuseIdentifier: "SubtitleCell")
            fetchAssetDetails(assetId: id)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelText.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.identifier, for: indexPath) as! SubtitleCell
        cell.titleLabel.text = labelText[indexPath.row]
        cell.detailTextView.text = labelValue[indexPath.row] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    /// Fetch asset details from Asista Core SDK using `assetId`
    ///
    private func fetchAssetDetails(assetId: Int) {
        try! AsistaCore.getInstance().getAssetService().fetchAssetDetails(assetId: assetId) { (result) in
            switch result {
            case .success(let assetDetails):
                self.populateTable(assetDetail: assetDetails)
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
    
    
    /// Parsing `assetDetail` data into tableview's datasource
    ///
    /// - Parameter assetDetail: Model object return by assetdetails Api
    private func populateTable(assetDetail: AssetDetail) {
        let label = assetDetail.header
        let itemLabel = label.item
        let statelabel = label.state
        let startDateLabel = label.startDate
        let endDateLabel = label.endDate
        let categoryLabel = label.category
        let teamLabel = label.team
        let modelLabel = label.model
        
        let payload = assetDetail.payload
        let item = payload.item
        let state = payload.state
        let startDate = payload.startDate.timestampToDate(as: "dd MMM yyyy")
        let endDate = payload.endDate.timestampToDate(as: "dd MMM yyyy")
        let category = payload.category
        let team = payload.team
        let model = payload.model
        
        self.title = item
        self.labelText = [itemLabel, statelabel, startDateLabel, endDateLabel, categoryLabel, teamLabel, modelLabel]
        self.labelValue = [item, state, startDate, endDate, category, team, model]
        
        for customField in assetDetail.payload.customFields {
            self.labelText.append(customField.label)
            
            switch customField.type {
            case "date":
                let dateStamp = Double(customField.data)
                let date = (dateStamp! + AsistaCore.timeZoneOffset) / 1000
                self.labelValue.append(date.timestampToDate(as: "dd MMM yyyy"))
            case "textarea":
                let text = customField.data.withoutHtmlTags
                self.labelValue.append(text)
            default:
                self.labelValue.append(customField.data)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
