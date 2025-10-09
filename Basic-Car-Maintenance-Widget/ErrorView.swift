//
//  ErrorView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct ErrorView: View {
    let error: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.title)

            Text("Error")
                .font(.subheadline)
                .bold()
                .foregroundColor(.primary)

            Text(error)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
