//
//  CustomButton.swift
//  ctzone
//
//  Created by Ali An Nuur on 17/03/25.
//

import SwiftUI

struct CustomButton: View {
    
    var text: String = "Select"
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            action()
        }
        ) {
            Text(text)

                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .buttonStyle(.plain)
        
    }
}

#Preview {
    CustomButton()
}
