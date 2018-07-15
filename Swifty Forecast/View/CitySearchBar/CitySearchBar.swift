//
//  RestaurantSearchBar.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 imac. All rights reserved.
//

import Foundation
import UIKit

class CitySearchBar: UISearchBar, ViewSetupable {
    typealias SearchBarStyle = Style.CitySearchBar
  
    private var isSearchButtonPressed = false
    private var searchingTextPassIntoSelector: String?
    
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupStyle()
    }
}


// MARK: - ViewSetupable protocol
extension CitySearchBar {
    
    func setup() {
        placeholder = "Search city, state, zip"
        isTranslucent = false
    }

    func setupStyle() {
        setupSearchBar()
        setupTextFieldInsideSearchBar()
    }
    
}


// MARK: - Private - Modify SearchBar style
private extension CitySearchBar {
    
    func setupSearchBar() {
        setupSearchBarBackground(color: SearchBarStyle.backgroundColor)
        setupSearchBarCancelButton(color: SearchBarStyle.cancelButtonColor, andFont: SearchBarStyle.cancelButtonFont)
    }
    
    func setupTextFieldInsideSearchBar() {
        setSearchTextFieldBackground(color: SearchBarStyle.searchTextFieldBackgroundColor)
        setSearchTextField(font: SearchBarStyle.searchTextFieldFont)
        setSearchTextField(textColor: SearchBarStyle.searchTextFieldColor)
        setSearchTextFieldTint(color: SearchBarStyle.searchTextFieldTintColor)
        setupGlassIconView(color: SearchBarStyle.glassIconColor)
        setSearchTextFieldPlaceholder(textColor: SearchBarStyle.searchTextFieldPlaceholder)
        setupTextFieldClearButton(color: SearchBarStyle.textFieldClearButtonColor)
    }
}



// MARK: - Private - SerchBar elements
private extension CitySearchBar {
    
    var textFieldInsideSearchBar: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    var textFieldClearButton: UIButton? {
        guard let textField = textFieldInsideSearchBar else { return nil }
        return textField.value(forKey: "clearButton") as? UIButton
    }
    
    var glassIconInsideTextField: UIImageView? {
        guard let iconImage = textFieldInsideSearchBar?.leftView as? UIImageView else { return nil }
        return iconImage
    }
    
}


// MARK: - Set background color
extension CitySearchBar {
    
    func setupSearchBarBackground(color: UIColor) {
        setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: .default)
        barTintColor = color
    }
    
}


// MARK: - Set SearchTextField background color
extension CitySearchBar {
    
    func setSearchTextFieldBackground(color: UIColor) {
        guard let textField = textFieldInsideSearchBar else { return }
        textField.backgroundColor = color
    }
    
    func setupSearchBarCancelButton(color: UIColor) {
        setupSearchBarCancelButton(color: color, andFont: SearchBarStyle.cancelButtonFont)
    }
    
    
    func setSearchTextFieldBorder(color: UIColor) {
        guard let textField = textFieldInsideSearchBar else { return }
        
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = color.cgColor
        textField.layer.cornerRadius = 10
    }
    
    
    func setSearchTextFieldGlassIcon(color: UIColor) {
        guard let imageView = glassIconInsideTextField else { return }
        
        let templateImage = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.image = templateImage
        imageView.tintColor = color
    }
    
}


// MARK: - Private - Set style
private extension CitySearchBar {
    
    func setupSearchBarCancelButton(color: UIColor, andFont font: UIFont) {
        let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
    }
    
    func setupGlassIconView(color: UIColor) {
        guard let iconView = textFieldInsideSearchBar?.leftView as? UIImageView else { return }
        
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = color
    }
    
    func setupTextFieldClearButton(color: UIColor) {
        guard let button = textFieldClearButton else { return }
        
        if let image = button.imageView?.image {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            button.imageView?.tintColor = color
            button.setImage(templateImage, for: .normal)
        }
    }
    
}


// MARK: - Private - Set SearchTextField style
private extension CitySearchBar {
    
    func setSearchTextField(textColor color: UIColor) {
        guard let textField = textFieldInsideSearchBar else { return }
        textField.textColor = color
    }
    
    func setSearchTextFieldTint(color: UIColor) {
        guard let textField = textFieldInsideSearchBar else { return }
        textField.tintColor = color
    }
    
    func setSearchTextField(font: UIFont) {
        guard let textField = textFieldInsideSearchBar else { return }
        textField.font = font
    }
    
    func setSearchTextFieldPlaceholder(textColor color: UIColor) {
        guard let textField = textFieldInsideSearchBar else { return }
        
        let placeholderText = placeholder != nil ? placeholder! : ""
        let attributes = [NSAttributedStringKey.foregroundColor: color]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
    
}
