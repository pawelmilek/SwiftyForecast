import UIKit
import CoreLocation
import RealmSwift
import Combine

protocol LocationListViewControllerDelegate: AnyObject {
    func locationListViewController(_ view: LocationListViewController, didSelectLocationAt index: Int)
    func locationListViewController(_ view: LocationListViewController, didTapSearchLocationButton sender: UIButton)
}

final class LocationListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchLocationButton: UIButton!

    weak var delegate: LocationListViewControllerDelegate?
    var viewModel: LocationListViewController.ViewModel?

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }
}

// MARK: - Private - Setups
private extension LocationListViewController {

    func setup() {
        setupTableView()
        setupSearchLocationButton()
        setupSubscribers()
    }

    func setupTableView() {
        tableView.register(cellClass: LocationViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Style.LocationList.backgroundColor
        tableView.separatorStyle = Style.LocationList.separatorStyle
        tableView.separatorColor = Style.LocationList.separatorColor
        tableView.separatorInset = Style.LocationList.separatorInset
        tableView.tableFooterView = UIView()
    }

    func setupSearchLocationButton() {
        searchLocationButton.backgroundColor = Style.LocationList.searchLocationButtonBackgroundColor
        searchLocationButton.layer.cornerRadius = 15
        searchLocationButton.clipsToBounds = true
        searchLocationButton.setTitle("Search Location", for: .normal)
        searchLocationButton.titleLabel?.font = Style.LocationList.searchLocationButtonFont
        searchLocationButton.addTarget(
            self,
            action: #selector(searchLocationButtonTapped(_:)),
            for: .touchUpInside
        )
    }

    func setupSubscribers() {
        viewModel?.$isInitialLoaded
            .receive(on: DispatchQueue.main)
            .sink { [self] isInitialLoaded in
                if isInitialLoaded {
                    relaodData()
                }
            }
            .store(in: &cancellables)

        viewModel?.$collectionChangeTransaction
            .receive(on: DispatchQueue.main)
            .sink { [self] collectionChangeTransaction in
                guard let collectionChangeTransaction else { return }
                tableView.applyChanges(
                    deletions: collectionChangeTransaction.deletions,
                    insertions: collectionChangeTransaction.insertions,
                    updates: collectionChangeTransaction.modifications
                )
            }
            .store(in: &cancellables)
    }

    private func relaodData() {
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource protocol
extension LocationListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfLocations ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LocationViewCell.self, for: indexPath)
        guard let viewModel = viewModel else { return cell }

        let row = indexPath.row
        let cityName = viewModel.name(at: row)
        let localTime = viewModel.localTime(at: row)
        let mapPoint = viewModel.mapPoint(at: row)

        cell.configure(by: cityName, time: localTime, mapPoint: mapPoint)
        return cell
    }

}

// MARK: - UITableViewDelegate protocol
extension LocationListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.locationListViewController(self, didSelectLocationAt: indexPath.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 ? false : true
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        viewModel?.delete(at: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationViewCell.defaultHeight
    }

}

// MARK: - Private - Actions
private extension LocationListViewController {

    @objc func searchLocationButtonTapped(_ sender: UIButton) {
        delegate?.locationListViewController(self, didTapSearchLocationButton: sender)
    }

}

// MARK: - Factory method
extension LocationListViewController {

    static func make() -> LocationListViewController {
        return UIViewController.make(LocationListViewController.self, from: .main)
    }

}
