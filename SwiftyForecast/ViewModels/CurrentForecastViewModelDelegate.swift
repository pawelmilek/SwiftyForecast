protocol CurrentForecastViewModelDelegate: class {
  func currentForecastViewModelDidFetchData(_ viewModel: CurrentForecastViewModel, error: WebServiceError?)
}
