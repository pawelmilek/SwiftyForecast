import UIKit
import CoreLocation

final class SearchLocationViewController: UIViewController {
  @IBOutlet private weak var instructionLabel: UILabel!
  @IBOutlet private weak var searchLocationTextField: SearchTextField!
  @IBOutlet private weak var updateSettingsButton: UIButton!
  @IBOutlet private weak var scrollView: UIScrollView!
  
  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search City"
    searchController.searchBar.delegate = self
    searchController.searchBar.tintColor = .red
    searchController.searchBar.barTintColor = .red
    searchController.searchBar.backgroundColor = .gray
    searchController.searchBar.searchTextField.backgroundColor = .white
    return searchController
  }()
  
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
    debugPrint("deinit SearchLocationViewController")
  }
}

// MARK: - Private - SetUps
private extension SearchLocationViewController {
  
  func setUp() {
    setTitle()
    setupSearchController()
    setupInstructionLabel()
    setupSearchTextField()
    setupScrollView()
    startKeyboardObserver()
    addKeyboardDismissGestureRecognizer()
  }
  
  func setupSearchController() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
  
  func resetSearchController() {
    searchController.isActive = false
    searchController.searchBar.text = nil
    searchController.searchBar.resignFirstResponder()
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
    searchLocationTextField.placeholder = "Search location"
    searchLocationTextField.font = UIFont.systemFont(ofSize: 13, weight: .light)
    searchLocationTextField.backgroundColor = UIColor.red.withAlphaComponent(0.7)
    searchLocationTextField.layer.cornerRadius = 10
    searchLocationTextField.delegate = self
    
    searchLocationTextField.addTarget(self, action:#selector(searchLocationTextFieldDidChange), for: .editingChanged)
//    searchLocationTextField.theme = SearchTextFieldTheme.lightTheme()
//    searchLocationTextField.theme.font = UIFont.systemFont(ofSize: 13, weight: .light)
//    searchLocationTextField.theme.bgColor = UIColor.red.withAlphaComponent(0.7)
//    searchLocationTextField.theme.borderColor = .clear
//    searchLocationTextField.theme.separatorColor = .gray
//    searchLocationTextField.comparisonOptions = [.caseInsensitive]
//    searchLocationTextField.theme.cellHeight = 50
//    searchLocationTextField.maxNumberOfResults = 4
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
//    if let currentLocation = try? User.all().first?.currentLocation {
//      searchLocationTextField.text = currentLocation.formattedAddress
//    }
  }
  
  @IBAction func updateSettingsButtonTapped(_ sender: UIButton) {
    debugPrint("updateSettingsButtonTapped")
  }
  
  @objc func searchLocationTextFieldDidChange() {
    guard let searchedAddress = searchLocationTextField.text, searchedAddress.count > 0 else { return }
    var addressResult: [String?] = []
    
//    let options = ForwardGeocodeOptions(query: searchedAddress)
//    options.allowedScopes = [.address, .pointOfInterest]
    
    
//    Geocoder.shared.geocode(options) { [weak self] placemarks, attribution, error in
//      guard let self = self else { return }
//      guard let placemarks = placemarks else { return }
//
//      placemarks.forEach {
//        let coordinate = $0.location?.coordinate
//        debugPrint("coordinate: \(coordinate)")
//        addressResult.append($0.qualifiedName)
//      }
//
//      self.searchLocationTextField.filterStrings(addressResult.compactMap { $0 })
//      self.searchLocationTextField.maxNumberOfResults = 5
//
//      self.searchLocationTextField.itemSelectionHandler = { filteredResults, itemPosition in
//        let item = filteredResults[itemPosition]
//        self.searchLocationTextField.text = item.title
//
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(item.title) { placemarks, error in
//          guard let placemarks = placemarks,
//            let location = placemarks.first?.location,
//            let placeMark = placemarks.first else {
//              return
//          }
//
//          // TODO: Save new current locoation in Realm
//          debugPrint("placemarks: \(placemarks)")
//        }
//      }
//    }
  }
  
}


// MARK: - UISearchBarDelegate protocol
extension SearchLocationViewController: UISearchBarDelegate { }

// MARK: - UISearchResultsUpdating protocol
extension SearchLocationViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }

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
