import UIKit
import CoreLocation
//import MapboxGeocoder

final class SearchLocationViewController: UIViewController {
  @IBOutlet private weak var instructionLabel: UILabel!
  @IBOutlet private weak var searchLocationTextField: SearchTextField!
  @IBOutlet private weak var currentLocationButton: UIButton!
  @IBOutlet private weak var updateSettingsButton: UIButton!
  @IBOutlet private weak var scrollView: UIScrollView!
  
  private lazy var keyboardObserver: KeyboardObserver = {
    let observer = KeyboardObserver()
    observer.eventResponder = self
    return observer
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  deinit {
    keyboardObserver.stopObserving()
    debugPrint("deinit LocationViewController")
  }
}

// MARK: - Private - SetUps
private extension SearchLocationViewController {
  
  func setUp() {
    setTitle()
    setupInstructionLabel()
    setupSearchTextField()
    setupScrollView()
    setupButtons()
    startKeyboardObserver()
    addKeyboardDismissGestureRecognizer()
  }
  
}

// MARK: - Private - SetUps helpers
private extension SearchLocationViewController {
  
  func setTitle() {
    title = "Location"
  }
  
  func setupInstructionLabel() {
    instructionLabel.text = "Enter address or click marker to set current location"
    instructionLabel.numberOfLines = 2
    instructionLabel.textAlignment = .center
    instructionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
  }
  
  func setupSearchTextField() {
    searchLocationTextField.placeholder = "Current location"
    searchLocationTextField.font = UIFont.systemFont(ofSize: 13, weight: .light)
    searchLocationTextField.backgroundColor = UIColor.solitude.withAlphaComponent(0.7)
    searchLocationTextField.layer.cornerRadius = 10
    searchLocationTextField.delegate = self
    
    searchLocationTextField.addTarget(self, action:#selector(searchLocationTextFieldDidChange), for: .editingChanged)
    searchLocationTextField.theme = SearchTextFieldTheme.lightTheme()
    searchLocationTextField.theme.font = UIFont.systemFont(ofSize: 13, weight: .light)
    searchLocationTextField.theme.bgColor = UIColor.solitude.withAlphaComponent(0.7)
    searchLocationTextField.theme.borderColor = .clear
    searchLocationTextField.theme.separatorColor = .darkPink
    searchLocationTextField.comparisonOptions = [.caseInsensitive]
    searchLocationTextField.theme.cellHeight = 50
    searchLocationTextField.maxNumberOfResults = 4
  }
  
  func setupButtons() {
    let currentLocationImage = UIImage(named: "icon-location")
    currentLocationButton.setImage(currentLocationImage?.withRenderingMode(.alwaysTemplate), for: .normal)
    currentLocationButton.tintColor = .darkPink
    currentLocationButton.layer.borderColor = UIColor.solitude.cgColor
    currentLocationButton.layer.borderWidth = 1
    currentLocationButton.layer.cornerRadius = 10
    
    let cornerRadius = updateSettingsButton.frame.size.height / 2
    updateSettingsButton.setTitle("UPDATE SETTINGS", for: .normal)
    updateSettingsButton.titleLabel?.font =  UIFont.systemFont(ofSize: 13, weight: .light)
    updateSettingsButton.backgroundColor = .darkPink
    updateSettingsButton.applyShadow(cornerRadius: cornerRadius,
                                     color: .gray,
                                     opacity: 0.3,
                                     shadowRadius: 3,
                                     shadowSpace: 10,
                                     edge: .bottom)
  }
  
  func setupScrollView() {
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInsetAdjustmentBehavior = .never
  }
  
}

// MARK: - Start Keyboard observer
private extension SearchLocationViewController {

  private func startKeyboardObserver() {
    keyboardObserver.startObserving()
  }

}

// MARK: - Private - Actions
private extension SearchLocationViewController {
  
  @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
    if let currentLocation = try? User.all().first?.currentLocation {
      searchLocationTextField.text = currentLocation.formattedAddress
    }
  }
  
  @IBAction func updateSettingsButtonTapped(_ sender: UIButton) {
    debugPrint("updateSettingsButtonTapped")
  }
  
  @objc func searchLocationTextFieldDidChange() {
    guard let searchedAddress = searchLocationTextField.text, searchedAddress.count > 0 else { return }
    var addressResult: [String?] = []
    
    let options = ForwardGeocodeOptions(query: searchedAddress)
    options.allowedScopes = [.address, .pointOfInterest]
    
    
    Geocoder.shared.geocode(options) { [weak self] placemarks, attribution, error in
      guard let self = self else { return }
      guard let placemarks = placemarks else { return }
      
      placemarks.forEach {
        let coordinate = $0.location?.coordinate
        debugPrint("coordinate: \(coordinate)")
        addressResult.append($0.qualifiedName)
      }
      
      self.searchLocationTextField.filterStrings(addressResult.compactMap { $0 })
      self.searchLocationTextField.maxNumberOfResults = 5
      
      self.searchLocationTextField.itemSelectionHandler = { filteredResults, itemPosition in
        let item = filteredResults[itemPosition]
        self.searchLocationTextField.text = item.title
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(item.title) { placemarks, error in
          guard let placemarks = placemarks,
            let location = placemarks.first?.location,
            let placeMark = placemarks.first else {
              return
          }
          
          // TODO: Save new current locoation in Realm
          debugPrint("placemarks: \(placemarks)")
        }
      }
    }
  }
  
}

// MARK: - UITextViewDelegate protocol
extension SearchLocationViewController: UITextViewDelegate { }

// MARK: - UITextFieldDelegate protocol
extension SearchLocationViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

// MARK: - KeyboardObserverEventResponder protocol
extension SearchLocationViewController: KeyboardObserverEventResponder {
  
  func keyboardWillShow(_ userInfo: KeyboardUserInfo) {
    let keyboardSize = userInfo.endFrame as NSValue
    let keyboardFrame = keyboardSize.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardFrame, from: nil)
    
    var contentInset: UIEdgeInsets = self.scrollView.contentInset
    contentInset.bottom = keyboardViewEndFrame.size.height - view.safeAreaInsets.bottom + CGFloat(150)
    scrollView.contentInset = contentInset
  }
  
  func keyboardWillHide(_ userInfo: KeyboardUserInfo) {
    self.scrollView.contentInset = .zero
    self.scrollView.contentOffset = .zero
  }
  
}

// MARK: - Factory method
extension SearchLocationViewController {
  
  static func make() -> SearchLocationViewController {
    return SearchLocationViewController.loadFromNib()
  }
  
}
