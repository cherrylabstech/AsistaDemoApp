//
//  MyTicketsVC.swift
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
class MyTicketsVC: UITableViewController {

    private var ticketPayload = TicketList().payload
    private var filterList = TicketList().payload
    private var isSearching: Bool = false
    private var ticketCount: Int = 0
    private var countOffset: Int = 20

    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Tickets"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.searchController = searchController
        self.refreshControl = refresher
        tableView.register(MyTicketsCell.self, forCellReuseIdentifier: "MyTicketsCell")
        fetchTicketList()
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        closeViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IHProgressHUD.set(defaultMaskType: .none)
        IHProgressHUD.set(backgroundColor: .clear)
        IHProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: tableView.frame.height / 2))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        IHProgressHUD.set(defaultStyle: .light)
        IHProgressHUD.set(defaultMaskType: .black)
        IHProgressHUD.resetOffsetFromCenter()
        IHProgressHUD.dismiss()
    }

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder =  "Search in Tickets.."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        return searchController
    } ()

    // UI Refresh Control for pull-down refresh
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(hex: 0x3FB7D8)
        refreshControl.attributedTitle = NSAttributedString(string: "Search in Tickets..")
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return refreshControl
    } ()
    
    @objc func refreshTable() {
        self.ticketPayload.removeAll()
        fetchTicketList()
        refresher.endRefreshing()
    }
    

    /// Fetching Ticket list from Asista
    ///
    /// - Parameters:
    ///   - from: Range starting from
    ///   - to: Range ending to
    private func fetchTicketList(from: Int? = 0, to: Int? = 20) {
        try! AsistaCore.getInstance().getTicketService().fetchTicketList(from: from, to: to) { (result) in
            switch result {
            case .success(let ticket):
                self.ticketCount = ticket.ticketCount!
                self.ticketPayload += ticket.payload

                DispatchQueue.main.async {
                    IHProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            case .failed( _):
                IHProgressHUD.dismiss()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? self.filterList.count : ticketPayload.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketsCell.identifier, for: indexPath) as! MyTicketsCell
        if ticketPayload.count > 0 {
            let sourceArray = isSearching ? filterList[indexPath.row] : ticketPayload[indexPath.row]
            cell.populate(with: sourceArray)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ticketPayload.count - 1  && ticketPayload.count < ticketCount {
            IHProgressHUD.show()
            fetchTicketList(from: countOffset, to: countOffset + 20)
            countOffset += 20
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sourceArray = isSearching ? filterList : ticketPayload
        let vc = TicketDetailsVC()
        if sourceArray.indices.contains(indexPath.row) {
            vc.requestId = sourceArray[indexPath.row].requestId
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


// MARK: - UISearchBarDelegate, UISearchResultsUpdating

@available(iOS 11.0, *)
extension MyTicketsVC:  UISearchBarDelegate, UISearchResultsUpdating {


    /// Calls the function when User taps on the `Cancel` Button on side of the searchBar.
    /// Reset the datasource of the tableview to
    ///
    /// - Parameter searchBar: Instance of `UISearchBar`
    private func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterList = TicketList().payload
    }


    /// Calls the function when User taps on the `Seach` Button on side of the keyboard.
    ///
    /// - Parameter searchBar: Instance of `UISearchBar`
    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            isSearching = true
            searchTicket(with: text)
        }
    }

    /// Calls the function when User types on the Seach box.
    ///
    /// - Parameter searchController:  Instance of `UISearchController`
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count >= 3  {
            isSearching = true
            searchTicket(with: text)
        }
        else {
            isSearching = false
            filterList = TicketList().payload
        }
        self.tableView.reloadData()
    }

    /// Performs Search on the list of tickets. Performs call to Asista SDK
    ///
    /// - Parameter searchText: The `query text` used to seach in the Ticket list
    private func searchTicket(with searchText: String) {
        try! AsistaCore.getInstance().getTicketService().searchTicket(query: searchText) { (result) in
            if case .success(let payload) = result {
                self.filterList.removeAll()
                self.filterList = payload
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

