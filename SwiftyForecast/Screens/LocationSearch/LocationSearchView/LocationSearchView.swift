//
//  LocationSearchView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import SwiftUI

struct LocationSearchView: View {
    private enum FocusedField {
        case searchText
    }
    @ObservedObject var viewModel: LocationSearchView.ViewModel
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Search for a city or address", text: $viewModel.searchText)
                        .font(.subheadline)
                        .focused($focusedField, equals: .searchText)
                }
                Section {
                    ForEach(viewModel.searchResults, id: \.self) { location in
                        let viewModel = LocationSearchDetailView.ViewModel(searchResult: location)
                        NavigationLink(destination: LocationSearchDetailView(viewModel: viewModel)) {
                            LocationSearchRowView(title: location.title, subtitle: location.subtitle)
                        }
                    }
                }
            }
            .onAppear {
                focusedField = .searchText
            }
            .navigationTitle(Text("Location"))
        }
    }
}

#Preview {
    LocationSearchView(viewModel: LocationSearchView.ViewModel())
}
