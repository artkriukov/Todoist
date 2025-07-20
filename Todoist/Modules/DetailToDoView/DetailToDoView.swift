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
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Button(action: {
                    didTapDoneButton()
                    // swiftlint:disable:next multiple_closures_with_trailing_closure
                }) {
                    // swiftlint:disable:next superfluous_disable_command
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                }
                Text(toDo.title)
                    .font(.system(size: 25))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let description = toDo.description {
                Text(description)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let data = toDo.expirationDate {
                Text(data.formattedShort())
                    .padding(.vertical, 7)
                    .padding(.horizontal, 7)
                    .foregroundStyle(.white)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
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
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 20)
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
            description: "something",
            expirationDate: Date(),
            selectedImage: nil
        )
    )
}
