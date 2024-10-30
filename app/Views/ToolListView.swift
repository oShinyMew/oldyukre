import SwiftUI

struct ToolListView: View {
    @ObservedObject var viewModel: ToolkitViewModel
    
    var body: some View {
        List(viewModel.filteredTools) { tool in
            ToolRow(tool: tool) {
                Task {
                    await viewModel.runTool(withId: tool.id)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct ToolRow: View {
    let tool: Tool
    let onRun: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tool.name)
                        .font(.headline)
                    Text(tool.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onRun) {
                    Text("Run")
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(tool.isEnabled ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!tool.isEnabled)
            }
            
            HStack {
                ForEach(tool.supportedVersions, id: \.self) { version in
                    Text(version)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 8)
    }
}