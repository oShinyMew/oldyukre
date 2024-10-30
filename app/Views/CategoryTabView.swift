import SwiftUI

struct CategoryTabView: View {
    @Binding var selectedCategory: ToolCategory?
    
    private let categories: [ToolCategory] = [
        .system, .security, .network, .diagnostics
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryButton(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(categories, id: \.rawValue) { category in
                    CategoryButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}