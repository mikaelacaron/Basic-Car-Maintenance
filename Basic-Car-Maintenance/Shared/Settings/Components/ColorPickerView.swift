//
//  ColorPicker.swift
//  Basic-Car-Maintenance
//
//  Created by Abdallah Mohammed Nsour on 29/11/2023.
//

import SwiftUI

struct ColorPickerView: View {
    @State private var color = Color.red

    var body: some View {
        ColorPicker("pick a color", selection: $color)
            .frame(width: 200, height: 50)
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
    }
}
