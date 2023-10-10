//
//  LocationSearchDetailView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import SwiftUI
import MapKit

struct LocationSearchDetailView: View {
    @StateObject private var viewModel: LocationSearchDetailView.ViewModel

    init(viewModel: @autoclosure @escaping () -> LocationSearchDetailView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
        print("LocationSearchDetailView init")
    }

    var body: some View {
        Map(position: $viewModel.position) {
            Annotation(
                viewModel.title,
                coordinate: viewModel.coordinate,
                anchor: .bottom
            ) {
                LocationSearchAnnotationView(
                    title: viewModel.title,
                    subtitle: viewModel.subtitle,
                    time: viewModel.time,
                    onAddAction: viewModel.addNewLocation
                )
            }
        }
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.white.ignoresSafeArea()
                    ProgressView("Loading...")
                }
            }
        }
        .onAppear {
            viewModel.startSearchRequest()
        }
        .errorAlert(error: $viewModel.error)
        .navigationTitle(Text(viewModel.title))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LocationSearchDetailView(
        viewModel: LocationSearchDetailView.ViewModel(
            searchResult: MKLocalSearchCompletion()
        )
    )
}
