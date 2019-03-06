//
//  CreateTicketVC.swift
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
import Eureka
import AsistaCore
import IHProgressHUD

@available(iOS 11.0, *)
class CreateTicketVC: FormViewController {
   
    let noneItem = PushRowList(optionId: -1, optionTitle: "None")
    var collectionView: UICollectionView?
    
    private var iconList = [UIImage]()
    private var attachmentList = [UploadAttachment]()
    private var customFieldSet = Set<CustomField>()
    
    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
    lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Ticket"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
        fetchTicketFields()
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        closeViewController()
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        doneButton.isEnabled = false
        var requestCategoryId: Int = 0
        var priorityId: Int = 0
        var assetId: Int = 0
        let formValues = self.form.values()

        for (key, value) in formValues {
            if value != nil {
                if key == "16" {
                    let category = value as! PushRowList
                    if category.optionId != -1 {
                        requestCategoryId = category.optionId
                    }
                }
                else if key == "5" {
                    let priority = value as! PushRowList
                    if priority.optionId != -1 {
                        priorityId = priority.optionId
                    }
                }
                else if key == "4" {
                    let asset = value as! PushRowList
                    if asset.optionId != -1 {
                        assetId = asset.optionId
                    }
                }
            }
        }

        var customFieldDictionary: [[String: Any]] = []
        for item in customFieldSet {
            let customItem: [String: Any] = ["columnId": item.coulmnId, "value": item.columnValue ?? ""]
            customFieldDictionary.append(customItem)
        }

        var attachmentDictionary: [[String: Any]] = []
        for item in attachmentList {
            let attachItem: [String: Any] = ["id": item.id, "url": item.url]
            attachmentDictionary.append(attachItem)
        }

        let requestParameters: [String: Any] = ["attachmentId": attachmentDictionary,
                                                "contentType":"text/plain",
                                                "custom": customFieldDictionary,
                                                "description": formValues["2"] as? String ?? "",
                                                "priority": priorityId,
                                                "requestType": requestCategoryId,
                                                "subject": formValues["1"] as? String ?? "",
                                                "item": assetId]
        
        try! AsistaCore.getInstance().getTicketService().createTicket(with: requestParameters) { (result) in
            switch result {
            case .success( _):
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in self.closeViewController() })
                UIAlertController.presentAlertWithAction(title: "New Ticket Created", message: "", actions: [okAction])
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
    
    
    /// Fetching ticket fields from asista SDK
    private func fetchTicketFields() {
        IHProgressHUD.show()
        try! AsistaCore.getInstance().getTicketService().fetchTicketFields { (result) in
            switch result {
            case .success(let formData):
                IHProgressHUD.dismiss()
                self.groupAssetFields(ticketForm: formData)
            case .failed(let e):
                IHProgressHUD.dismiss()
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
    
    
    /// Grouping asset fields together from the list of ticket fields.
    ///
    /// - Parameter ticketForm: Instance of array of `CreateTicketForm` that holds the list of field for the create ticket form
    /// `assetCTIGroup` is the Dictionary object that holds the list of asset fields with its `fieldTypeId` as the key
    private func groupAssetFields(ticketForm: [CreateTicketForm]) {
        var assetCTIGroup = [Int: CreateTicketForm]()
        for formElement in ticketForm {
            let fieldTypeId = formElement.fieldTypeId
            if fieldTypeId == 4 || fieldTypeId == 101 || fieldTypeId == 107 {
                assetCTIGroup[fieldTypeId] = formElement
            }
        }
        createTicketFields(for: ticketForm, assetGroup: assetCTIGroup)
        createAttachmentRow()
    }
    
    
    /// Looping over `CreateTicketForm` array and generating field by their `fieldTypeId`
    /// The switch cases are executed for `static` fields default will navigate to `custom` fields in the `ticketForm`
    ///
    /// - Parameters:
    ///   - ticketForm: Array of fields object with their properties.
    ///   - assetGroup: Dictionary object that holds the list of asset fields with its `fieldTypeId` as the key
    private func createTicketFields(for ticketForm: [CreateTicketForm], assetGroup: Dictionary<Int, CreateTicketForm>) {
        for ticketElement in ticketForm {
            var fieldLabel = ticketElement.fieldLabel
            let fieldTypeId = ticketElement.fieldTypeId
            let fieldRequired = ticketElement.fieldRequired
            
            switch fieldTypeId {
            case 1:
                createTextField(for: ticketElement)
            case 2:
                createTextArea(for: ticketElement)
            case 4:
                createAssetRow(assetDict: assetGroup)
            case 5:
                
                fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
                form +++ Section(fieldLabel) {
                    $0.tag = fieldLabel
                }
                var priorityRow: PushRow<PushRowList>?
                priorityRow = PushRow<PushRowList>(String(fieldTypeId)) {
                    $0.title = fieldLabel.lowercased()
                    $0.selectorTitle = "Pick " + fieldLabel.lowercased()
                    if fieldRequired {
                        $0.add(rule: RuleNone())
                    }
                    $0.displayValueFor = {
                        guard let priority = $0 else { return nil }
                        return priority.optionTitle
                    }
                    $0.onChange({ [] row in
                        let mandatoryCount = row.section?.form?.validate().count
                        self.doneButton.isEnabled = mandatoryCount == 0 ? true : false
                    })
                    $0.onPresent({ (from, to) in
                        to.enableDeselection = false
                    })
                }
                self.form.sectionBy(tag: fieldLabel)!  <<< priorityRow!
                
                try! AsistaCore.getInstance().getPriorityService().fetchPriorityList { (result) in
                    switch result {
                    case .success(let priorityList):
                        DispatchQueue.main.async {
                            var options = priorityList.map {
                                PushRowList(optionId: $0.priorityID, optionTitle: $0.priorityState)
                            }
                            options.insert(self.noneItem, at: 0)
                            priorityRow?.options = options
                            priorityRow?.value = self.noneItem
                            priorityRow?.reload()
                        }
                    case .failed(let e):
                        UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
                    }
                }
            case 16:
                fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
                form +++ Section(fieldLabel) {
                    $0.tag = fieldLabel
                }
                var categoryRow: PushRow<PushRowList>?
                categoryRow = PushRow<PushRowList>(String(fieldTypeId)) {
                    $0.title = fieldLabel.lowercased()
                    $0.selectorTitle = "Pick " + fieldLabel.lowercased()
                    if fieldRequired {
                        $0.add(rule: RuleNone())
                    }
                    $0.displayValueFor = {
                        guard let category = $0 else { return nil }
                        return category.optionTitle
                    }
                }
                self.form.sectionBy(tag: fieldLabel)!  <<< categoryRow!
                
                try! AsistaCore.getInstance().getTicketService().fetchCategoryList { (result) in
                    switch result {
                    case .success(let categoryList):
                        DispatchQueue.main.async {
                            var options = categoryList.map {
                                PushRowList(optionId: $0.categoryID, optionTitle: $0.categoryName)
                            }
                            options.insert(self.noneItem, at: 0)
                            categoryRow?.options = options
                            categoryRow?.value = self.noneItem
                            categoryRow?.reload()
                        }
                    case .failed(let e):
                        UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
                    }
                }
            default:
                createCustomControls(for: ticketElement)
            }
        }
    }
    
    
    /// Creating custom ticket fields in tableview.
    ///
    /// - Parameter ticketElement: Object of `createTicketForm` model  contains the attributes of TextRow
    private func createCustomControls(for ticketElement: CreateTicketForm) {
        let fieldType = ticketElement.fieldType
        
        switch fieldType {
        case "textfield":
            createTextField(for: ticketElement)
        case "textarea":
            createTextArea(for: ticketElement)
        case "email":
            createEmailField(for: ticketElement)
        case "dropdown", "radio":
            createCustomPushRow(for: ticketElement)
        case "checkbox":
            createCheckBoxRow(for: ticketElement)
        case "date":
            createDateField(for: ticketElement)
        default:
            break
        }
    }
    
    private func addToCustom(set: CustomField) {
        customFieldSet.remove(set)
        customFieldSet.insert(set)
    }
    
    //******************************************* FORM CONTROLLS *********************************************//
    
    /// Creating Textfield Row in tableview.
    ///
    /// - Parameter field: Object of `createTicketForm` model  contains the attributes of TextRow
    private func createTextField(for field: CreateTicketForm) {
        let fieldTypeId = field.fieldTypeId
        var fieldLabel = field.fieldLabel
        let fieldType = field.fieldType
        let fieldPlaceholder = field.fieldPlaceholder
        let fieldRequired = field.fieldRequired
        
        fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
        form +++ Section(fieldLabel)
            <<< TextRow(String(fieldTypeId)) {
                $0.placeholder = fieldPlaceholder
                if fieldRequired {
                    $0.add(rule: RuleRequired())
                }
                $0.cellUpdate { (cell, row) in
                    if fieldRequired {
                        let mandatoryCount = row.section?.form?.validate().count
                        self.doneButton.isEnabled = mandatoryCount == 0 ? true : false
                    }
                    if let value = row.value, fieldType != "static" {
                        let item = CustomField(coulmnId: fieldTypeId, columnValue: value)
                        self.addToCustom(set: item)
                    }
                }
        }
    }
    
    /// Creating TextArea Row in tableview.
    ///
    /// - Parameter field: Object of `createTicketForm` model  contains the attributes of TextAreaRow
    private func createTextArea(for field: CreateTicketForm) {
        let fieldTypeId = field.fieldTypeId
        var fieldLabel = field.fieldLabel
        let fieldType = field.fieldType
        let fieldPlaceholder = field.fieldPlaceholder
        let fieldRequired = field.fieldRequired
        
        fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
        form +++ Section(fieldLabel)
            <<< TextAreaRow(String(fieldTypeId)) {
                $0.placeholder = fieldPlaceholder
                if fieldRequired {
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                $0.cellUpdate { (cell, row) in
                    if fieldRequired {
                        let mandatoryCount = row.section?.form?.validate().count
                        self.doneButton.isEnabled = mandatoryCount == 0 ? true : false
                    }
                    if let value = row.value, fieldType != "static" {
                        let item = CustomField(coulmnId: fieldTypeId, columnValue: value)
                        self.addToCustom(set: item)
                    }
                }
        }
    }
    
    /// Creating PushRow Row in tableview.
    ///
    /// - Parameter field: Object of `createTicketForm` model  contains the attributes of PushRow
    private func createCustomPushRow(for field: CreateTicketForm) {
        let fieldTypeId = field.fieldTypeId
        let fieldType = field.fieldType
        var fieldLabel = field.fieldLabel
        let fieldRequired = field.fieldRequired
        let fieldOptions = field.fieldOptions!
        
        var options = fieldOptions.map {
            PushRowList(optionId: $0.optionId, optionTitle: $0.optionTitle)
        }
        options.insert(self.noneItem, at: 0)
        
        fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
        form +++ Section(fieldLabel)
            <<< PushRow<PushRowList>(String(fieldTypeId)) {
                $0.title = fieldLabel.lowercased()
                $0.selectorTitle = "Pick " + fieldLabel.lowercased()
                $0.options = options
                $0.value = noneItem
                if fieldRequired {
                    $0.add(rule: RuleNone())
                }
                $0.displayValueFor = {
                    guard let row = $0 else { return nil }
                    return row.optionTitle
                }
                }.onChange({ [unowned self] row in
                    if fieldRequired {
                        let mandatoryCount = row.section?.form?.validate().count
                        self.doneButton.isEnabled = mandatoryCount == 0 ? true : false
                    }
                    if let value = row.value, fieldType != "static" {
                        let item = CustomField(coulmnId: fieldTypeId, columnValue: value.optionTitle)
                        self.addToCustom(set: item)
                    }
                })
                .onPresent({ (_, to) in
                    to.enableDeselection = false
                })
    }
    
    /// Creating CheckBox Row in tableview.
    ///
    /// - Parameter field: Object of `createTicketForm` model  contains the attributes of SwitchRow
    private func createCheckBoxRow(for field: CreateTicketForm) {
        let fieldTypeId = field.fieldTypeId
        let fieldType = field.fieldType
        var fieldLabel = field.fieldLabel
        let fieldRequired = field.fieldRequired
        
        fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
        self.form +++ Section(fieldLabel)
            <<< SwitchRow(String(fieldTypeId)) {
                $0.title = fieldLabel
                if fieldRequired {
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                }.onChange({ [unowned self] row in
                    if fieldRequired {
                        let fieldCount = row.section?.form?.validate().count
                        self.doneButton.isEnabled = fieldCount == 0 ? true : false
                    }
                    if let value = row.value, fieldType != "static" {
                        let item = CustomField(coulmnId: fieldTypeId, columnValue: value)
                        self.addToCustom(set: item)
                    }
                })
    }
    
    /// Creating EmailRow Row in tableview.
    ///
    /// - Parameter field: Object of `createTicketForm` model  contains the attributes of EmailRow
    private func createEmailField(for field: CreateTicketForm) {
        let fieldTypeId = field.fieldTypeId
        let fieldType = field.fieldType
        var fieldLabel = field.fieldLabel
        let fieldPlaceholder = field.fieldPlaceholder
        let fieldRequired = field.fieldRequired
        
        fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
        form +++ Section(fieldLabel)
            <<< EmailRow(String(fieldTypeId)) {
                $0.placeholder = fieldPlaceholder
                if fieldRequired {
                    $0.add(rule: RuleRequired())
                    $0.add(rule: RuleEmail())
                    $0.validationOptions = .validatesAlways
                }
                }.cellUpdate { cell, row in
                    if fieldRequired {
                        let fieldCount = row.section?.form?.validate().count
                        self.doneButton.isEnabled = fieldCount == 0 ? true : false
                    }
                    if let value = row.value, fieldType != "static" {
                        let item = CustomField(coulmnId: fieldTypeId, columnValue: value)
                        self.addToCustom(set: item)
                    }
        }
    }
    
    /// Creating DateRow in tableview.
    ///
    /// - Parameter field: Object of `createTicketForm` model  contains the attributes of DateRow
    private func createDateField(for field: CreateTicketForm) {
        let fieldTypeId = field.fieldTypeId
        var fieldLabel = field.fieldLabel
        let fieldRequired = field.fieldRequired
        
        fieldLabel = fieldRequired ? fieldLabel + " *" : fieldLabel
        form +++ Section(fieldLabel)
            <<< DateRow(String(fieldTypeId)) {
                $0.title = fieldLabel
                if fieldRequired {
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesAlways
                }
                }.onCellSelection({ (cell, row) in
                    if row.value == nil {
                        row.value = Date()
                        self.addDateFieldValue(row: row, for: field)
                    }
                })
                .onChange({ (row) in
                    self.addDateFieldValue(row: row, for: field)
                })
    }
    
    
    /// On change event of `DateRow` to populate value to the cell and dataset
    ///
    /// - Parameters:
    ///   - row: Object of `DateRow` contains the row information
    ///   - field: Object of `createTicketForm` model  contains the attributes of DateRow
    private func addDateFieldValue(row: DateRow, for field: CreateTicketForm) {
        let fieldTypeId = field.fieldTypeId
        let fieldRequired = field.fieldRequired
        let fieldType = field.fieldType
        
        if let value = row.value {
            if fieldRequired {
                let mandatoryCount = row.section?.form?.validate().count
                self.doneButton.isEnabled = mandatoryCount == 0 ? true : false
            }
            if fieldType != "static" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.string(from: value)
                
                let item = CustomField(coulmnId: fieldTypeId, columnValue: date)
                self.addToCustom(set: item)
            }
        }
    }
    
    
    //******************************************* ASSET CONTROLLS *********************************************//
    
    /// Performing API call for getting list of Asset categories.
    ///
    /// - Returns: `AssetCategory` array having `category_id` and `categoryName`.
    private func loadAssetCategory(completionHandler: @escaping ([PushRowList]?) -> Void) {
        try! AsistaCore.getInstance().getAssetService().fetchAssetCategories(completionHandler: { (result) in
            switch result {
            case .success(let category):
                var options = category.map {
                    PushRowList(optionId: $0.id, optionTitle: $0.categoryName)
                }
                options.insert(self.noneItem, at: 0)
                completionHandler(options)
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        })
    }
    
    /// Performing API call for getting list of Asset models.
    ///
    /// - Returns: `AssetModel` with `model_id` and `name`.
    private func loadAssetModel(categoryId: Int? = nil, completionHandler: @escaping ([PushRowList]?) -> Void) {
        try! AsistaCore.getInstance().getAssetService().fetchAssetTypes(categoryId: categoryId, completionHandler: { (result) in
            switch result {
            case .success(let type):
                var options = type.map {
                    PushRowList(optionId: $0.id, optionTitle: $0.model)
                }
                options.insert(self.noneItem, at: 0)
                completionHandler(options)
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        })
    }
    
    /// Performing API call for getting list of Asset Names.
    ///
    /// - Returns: Loads `assetArray` with `asset_id` and `name`.
    private func loadAssetList(categoryId: Int? = nil, modelId: Int? = nil, from: Int, to: Int, completionHandler: @escaping ([PushRowList]?) -> Void) {
        try! AsistaCore.getInstance().getAssetService().fetchAssetList(categoryId: categoryId, modelId: modelId, from: from, to: to, completionHandler: { (result) in
            switch result {
            case .success(let asset):
                var options = asset.payload.map {
                    PushRowList(optionId: $0.id, optionTitle: $0.item)
                }
                options.insert(self.noneItem, at: 0)
                completionHandler(options)
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        })
    }
    
    var categoryRow: PushRow<PushRowList>?
    var modelRow: PushRow<PushRowList>?
    var assetRow: PushRow<PushRowList>?
    
    
    /// Creating Asset CTI Row in tableview.
    ///
    /// - Parameter assetDict: Dictionary value contains the information of asset CTI
    private func createAssetRow(assetDict: Dictionary<Int, CreateTicketForm>) {
        var assetField: CreateTicketForm?
        guard assetDict[4] != nil else { return }
        
        if self.form.sectionBy(tag: "asset") == nil {
            form +++ Section("Choose Asset") { sec in
                sec.tag = "asset"
            }
        }
        
        // Creating Asset CategoryRow
        assetField = assetDict[101]
        if assetField!.fieldDisabled == false {
            categoryRow = PushRow<PushRowList>("asset_category") { categoryRow in
                categoryRow.title = "Asset Category"
                categoryRow.selectorTitle = "Pick category"
                
                self.loadAssetCategory(completionHandler: { (assetCat) in
                    if let catNames = assetCat {
                        categoryRow.options = catNames
                    }
                })
                categoryRow.value = self.noneItem
                categoryRow.displayValueFor = {
                    guard let cat = $0 else { return nil }
                    return cat.optionTitle
                }
                
                categoryRow.onChange { [unowned self] row in
                    if let row = row.value {
                        self.loadAssetModel(categoryId: row.optionId, completionHandler: { (assetModel) in
                            if let modelNames = assetModel {
                                self.modelRow?.options = modelNames
                                self.modelRow?.value = self.noneItem
                            }
                            self.modelRow?.reload()
                            self.assetRow?.reload()
                        })
                    }
                }
                categoryRow.onPresent({ (from, to) in
                    to.enableDeselection = false
                })
            }
            self.form.sectionBy(tag: "asset")! <<< categoryRow!
        }
        
        
        // Creating Asset ModelRow
        assetField = assetDict[107]
        if assetField!.fieldDisabled == false {
            modelRow = PushRow<PushRowList>("asset_model") { modelRow in
                modelRow.title = "Asset Model"
                modelRow.selectorTitle = "Pick model"
                self.loadAssetModel(completionHandler: { (assetModel) in
                    if let modelNames = assetModel {
                        modelRow.options = modelNames
                    }
                })
        
                modelRow.value = self.noneItem
                modelRow.displayValueFor = {
                    guard let cat = $0 else { return nil }
                    return cat.optionTitle
                }
                
                modelRow.onChange { [unowned self] row in
                    let categoryId = self.categoryRow!.value!.optionId
                    self.loadAssetList(categoryId: categoryId, modelId: modelRow.value?.optionId, from: 0, to: 0, completionHandler: { (assets) in
                        self.assetRow?.options = assets
                        self.assetRow?.value = self.noneItem
                    })
                }
                modelRow.onPresent({ (from, to) in
                    to.enableDeselection = false
                })
            }
            self.form.sectionBy(tag: "asset")!  <<< modelRow!
        }
            
        
        // Creating Asset NameRow
        assetField = assetDict[4]
        if assetField!.fieldDisabled == false {
            let fieldTypeId = assetField!.fieldTypeId
            let fieldRequired = assetField!.fieldRequired

            let fieldLabel = fieldRequired ? "Asset Name *" : "Asset Name"
            assetRow = PushRow<PushRowList>(String(fieldTypeId)) { assetRow in
                assetRow.title = fieldLabel
                assetRow.selectorTitle = "Pick Asset"
                if fieldRequired {
                    assetRow.add(rule: RuleNone())
                }
                self.loadAssetList(from: 0, to: 0, completionHandler: { (assets) in
                    if let payload = assets {
                        assetRow.options = payload
                    }
                })
                assetRow.value = self.noneItem
                assetRow.displayValueFor = {
                    guard let asset = $0 else { return nil }
                    return asset.optionTitle
                }
                assetRow.onChange({ [unowned self] row in
                    let mandatoryCount = row.section?.form?.validate().count
                    self.doneButton.isEnabled = mandatoryCount == 0 ? true : false
                })
                assetRow.onPresent({ (_, to) in
                    to.enableDeselection = false
                })
            }
            self.form.sectionBy(tag: "asset")!  <<< assetRow!
        }
    }
            
    /// Creating Attachment select button and collectionview in tableview with given attributes.
    ///
    @available(iOS 11.0, *)
    private func createAttachmentRow() {
        let fileSize = AsistaCore.attachmentSize / 1000000
        let footerText = "Upload supported formats (\(AsistaCore.attachmentTypes.joined(separator: ", "))). Maximum size = \(fileSize) MB"
        
        form +++ Section(header: "Upload File", footer: footerText)
            <<< ViewRow<UIView>("view") { (row) in
                }
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
                    
                    let button = UIButton(frame: CGRect(x: 0, y: 5, width: 50, height: 50))
                    button.backgroundColor = .gray
                    button.setTitle("+", for: .normal)
                    button.addTarget(self, action: #selector(self.attachmentButtonTapped), for: .touchUpInside)
                    
                    let flowLayout = UICollectionViewFlowLayout()
                    flowLayout.scrollDirection = .horizontal
                    
                    let frame =  CGRect(x: 55, y: 5, width: self.view.frame.width - 60, height: 50)
                    self.collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
                    self.collectionView?.register(AttachmentCell.self, forCellWithReuseIdentifier: "AttachmentCell")
                    self.collectionView?.backgroundColor = .white
                    self.collectionView?.delegate = self
                    self.collectionView?.dataSource = self
                    
                    cell.view?.addSubview(self.collectionView!)
                    cell.view?.addSubview(button)
        }
    }
    //****************************************************************************************************
}


// Document picker for selecting files from the phone.
///
@available(iOS 11.0, *)
extension CreateTicketVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, AttachmentCellActions {
    
    
    /// Removes the selected item in upload list.
    ///
    /// - Parameter cell: gives the instance of selected cell
    func removeItem(cell: AttachmentCell) {
        if let indexPath = collectionView!.indexPath(for: cell) {
            iconList.remove(at: indexPath.row)
            attachmentList.remove(at: indexPath.row)
            collectionView?.reloadData()
        }
    }
    
    @objc private func attachmentButtonTapped(sender: UIButton!) {
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
            let importMenu = UIDocumentPickerViewController(documentTypes:  ["public.item"], in: .import)
            importMenu.modalPresentationStyle = .formSheet
            importMenu.delegate = self
            DispatchQueue.main.async {
                self.present(importMenu, animated: true, completion: nil)
            }
        })
        
        UIAlertController.presentActionSheet(title: "Upload File", message: "What would you like to do?", actions: [cameraButton, imageButton, docButton])
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
            UIAlertController.presentAlert(title: "Error", message: "The file you are attaching is bigger than server allows.")
            return
        }
        
        let fileItem = FileParameters(data: fileData, name: "file.\(fileExt)", mimeType: "application/\(fileExt)")
        
        let imgName = Helper.attachmentIcon(for: fileExt)
        let icon = Helper.loadImage(name: imgName)
        
        uploadAttachment(file: fileItem, fileIcon: icon!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let imageData = image.jpegData(compressionQuality: 0.2)
            let imageSize = Int(imageData!.count)
            
            guard imageSize < AsistaCore.attachmentSize else {
                UIAlertController.presentAlert(title: "Error", message: "The file you are attaching is bigger than server allows.")
                return
            }
            
            let imageItem = FileParameters(data: imageData!, name: "image.jpg", mimeType: "image/jpg")
            uploadAttachment(file: imageItem, fileIcon: image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Upload Ticket attachements to server
    ///
    /// - Parameters:
    ///   - file: Object of `FileParameters` model which contains `filedata`, `name` and `mimeType`
    ///   - fileIcon: Iconsouce to display in client side.
    private func uploadAttachment(file: FileParameters, fileIcon: UIImage) {
        IHProgressHUD.show()
        try! AsistaCore.getInstance().getTicketService().uploadAttachment(fileParameters: file) { (result) in
            switch result {
            case .success(let response):
                 let attachmentItem = UploadAttachment(id: response.id, url: response.url)
                 self.attachmentList.append(attachmentItem)
                 self.iconList.append(fileIcon)
                 DispatchQueue.main.async {
                    IHProgressHUD.dismiss()
                    self.collectionView!.reloadData()
                }
            case .failed(let error):
                IHProgressHUD.dismiss()
                UIAlertController.presentAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }
}

// CollectionView showing selected attachments for the ticket.
///
@available(iOS 11.0, *)
extension CreateTicketVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachmentCell.identifier, for: indexPath) as! AttachmentCell
        cell.populate(icon: iconList[indexPath.row])
        cell.delegate = self
        return cell
    }
}


struct RuleNone<T: Equatable>: RuleType {
    
    init(msg: String = "Field required!", id: String? = nil) {
        self.validationError = ValidationError(msg: msg)
        self.id = id
    }
    
    var id: String?
    var validationError: ValidationError
    
    func isValid(value: T?) -> ValidationError? {
        if let str = value as? PushRowList {
            return str.optionId == -1 ? validationError : nil
        }
        return value != nil ? nil : validationError
    }
}
