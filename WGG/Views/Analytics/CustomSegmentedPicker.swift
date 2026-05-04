//
//  CustomSegmentedPicker.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 03/05/26.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    @Binding private var selectedTime: String
    
    let times = ["1M", "3M", "6M", "1Y", "All"]
    
    init(selectedTime: Binding<String>) {
        self._selectedTime = selectedTime
        
        UISegmentedControl.appearance().backgroundColor = UIColor.background
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.background,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.brandSecondary
        ], for: .normal)
    }
    
    var body: some View {
        Picker("Select", selection: $selectedTime) {
            ForEach(times, id: \.self) { time in
                Text(time)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

#Preview {
    CustomSegmentedPicker(selectedTime: .constant("All"))
}
