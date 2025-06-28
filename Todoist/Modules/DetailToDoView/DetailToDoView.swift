//
//  DetailToDoView.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.06.2025.
//

import SwiftUI

struct DetailToDoView: View {
    
    let toDo: ToDoItem
    
    @State private var isDone = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 20) {
                Button(action: {
                    didTapDoneButton()
                    // swiftlint:disable:next multiple_closures_with_trailing_closure
                }) {
                    // swiftlint:disable:next superfluous_disable_command
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.gray)
                }
                Text(toDo.title)
                    .font(.system(size: 35))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            if let description = toDo.description {
                Text(description)
                    .font(.system(size: 25))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            
            ScrollView(.horizontal) {
                if let data = toDo.expirationDate {
                    Text(data.formatted(
                        date: .abbreviated,
                        time: .shortened)
                    )
                }
            }
            .padding()
            
            if let imageData = toDo.selectedImage, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
                
            Spacer()
            
        }
        .padding(.horizontal)
        .background(Color(Asset.Colors.mainBackground))
    }
    
    private func didTapDoneButton() {
        isDone.toggle()
    }
}

#Preview {
    DetailToDoView(
        toDo: ToDoItem(
            title: "Test",
            description: nil,
            expirationDate: Date(),
            selectedImage: nil
        )
    )
}
