//
//  LocationSearchAnnotationView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import SwiftUI

struct LocationSearchAnnotationView: View {
    let title: String
    let subtitle: String
    let time: String
    var onAddAction: (() -> Void)

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Style.Annotation.titleFont)
                .fontWeight(Style.Annotation.titleFontWeight)
                .foregroundStyle(Style.Annotation.titleColor)
            Text(subtitle)
                .font(Style.Annotation.subtitleFont)
                .foregroundStyle(Style.Annotation.subtitleColor)
            Text(time)
                .font(Style.Annotation.timeFont)
                .fontWeight(Style.Annotation.timeFontWeight)
                .foregroundStyle(Style.Annotation.timeColor)
        }
        .fontDesign(Style.Annotation.fontDesign)
        .padding(10)
        .padding(.trailing, 55)
        .background(Style.Annotation.backgroundColor)
        .cornerRadius(Style.Annotation.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Style.Annotation.cornerRadius)
                .stroke(Color(UIColor.primary), lineWidth: 0.5)
        )

        .overlay(alignment: .topTrailing) {
            Button {
                onAddAction()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 30)
                    .foregroundStyle(Style.Annotation.systemSymbolColor)
            }
            .padding(10)
        }

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationSearchAnnotationView(title: "Chicago",
                   subtitle: "United States United States",
                   time: "10:00 PM",
                   onAddAction: {
    })
    .padding()
}
