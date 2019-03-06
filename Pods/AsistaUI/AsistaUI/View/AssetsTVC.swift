//
//  AssetsTVC.swift
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
class AssetsTVC: UITableViewController {
    var assetCount : Int = 0
    var assetOffset : Int = 20
    var assetList = [AssetPayload]()
    
    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Assets"
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AssetCell")
        fetchAssetList()
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        closeViewController()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath)
        cell.textLabel?.text = assetList[indexPath.row].item
        cell.detailTextLabel?.text = assetList[indexPath.row].state
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == assetList.count - 1  && assetList.count < assetCount {
            fetchAssetList(from: assetOffset, to: assetOffset + 20)
            assetOffset += 20
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AssetDetailTVC()
        vc.assetId = assetList[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
        
    /// Fetching asset list from Asista Api
    ///
    /// - Parameters:
    ///   - from: Range staring from
    ///   - to: Range ending to
    private func fetchAssetList(from: Int? = 0, to: Int? = 20) {
        try! AsistaCore.getInstance().getAssetService().fetchAssetList(from: from, to: to) { (result) in
            switch result {
            case .success(let asset):
                self.assetList += asset.payload
                self.assetCount = asset.assetCount!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
}
