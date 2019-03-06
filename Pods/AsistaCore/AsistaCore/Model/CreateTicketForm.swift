//
//  TicketCreationForm.swift
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

/// Used to store `CreateTicketForm` data associated with a decoded response.
public struct CreateTicketForm: Codable {
    public let agentOnly: Bool
    public let expanded: Bool
    public let fieldData: String?
    public let fieldDelete: Bool
    public let fieldDisabled: Bool
    public let fieldId: Int
    public let fieldLabel: String
    public let fieldName: String
    public let fieldOrgName: String
    public let fieldPlaceholder: String?
    public let fieldRequired: Bool
    public let fieldTitle: String
    public let fieldType: String
    public let fieldTypeId: Int
    public let fieldValue: String?
    public let fieldOptions: [FieldOption]?
    
    enum CodingKeys: String, CodingKey {
        case agentOnly = "agent_only"
        case expanded = "expanded"
        case fieldData = "field_data"
        case fieldDelete = "field_delete"
        case fieldDisabled = "field_disabled"
        case fieldId = "field_id"
        case fieldLabel = "field_label"
        case fieldName = "field_name"
        case fieldOrgName = "field_org_name"
        case fieldPlaceholder = "field_placeholder"
        case fieldRequired = "field_required"
        case fieldTitle = "field_title"
        case fieldType = "field_type"
        case fieldTypeId = "field_type_id"
        case fieldValue = "field_value"
        case fieldOptions = "field_options"
    }
    
    public init() {
        self.agentOnly = false
        self.expanded = false
        self.fieldData = nil
        self.fieldDelete = false
        self.fieldDisabled = false
        self.fieldId = 0
        self.fieldLabel = ""
        self.fieldName = ""
        self.fieldOrgName = ""
        self.fieldPlaceholder = nil
        self.fieldRequired = false
        self.fieldTitle = ""
        self.fieldType = ""
        self.fieldTypeId = 0
        self.fieldValue = nil
        self.fieldOptions = [FieldOption]()
    }
}


public struct FieldOption: Codable {
    public let optionValue: Int
    public let optionTitle: String
    public let optionId: Int

    enum CodingKeys: String, CodingKey {
        case optionValue = "option_value"
        case optionTitle = "option_title"
        case optionId = "option_id"
    }
}
