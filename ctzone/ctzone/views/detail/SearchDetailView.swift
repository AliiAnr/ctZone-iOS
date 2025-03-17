import SwiftUI

struct SearchDetailView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @StateObject private var viewModel = TimePickerViewModel()
    @State private var isPinned: Bool = false
    @FocusState var isFocused: Bool
    @State private var isSheetPresented = false
    
    var body: some View {
        ScrollView{
            ZStack {
                // **Background utama yang memenuhi seluruh layar**
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // **Top Section**
                    TopSectionView()
                    
                    
                    // **Mid Section**
                    MidSectionView(viewModel: viewModel)
                    
                    Button(action: {
                        print("Save button tapped")
                        isSheetPresented.toggle()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 30)
                    .buttonStyle(.plain)
                    
                    // **Bottom Section**
                    //                    BottomSectionView(isFocused: $isFocused)
                    
                    //                    Spacer() // **Mendorong VStack ke atas**
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
            }
        }
        .onAppear{
            viewModel.use24HourFormat = userDefaultsManager.use24HourFormat
        }
        .sheet(isPresented: $isSheetPresented) {
            DescriptionSheet(isPresented: $isSheetPresented)
                .presentationDetents([.medium])
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            isFocused = false // Menghapus fokus saat mengetuk di luar
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isPinned.toggle()
                }) {
                    Image(systemName: isPinned ? "pin.fill" : "pin")
                        .foregroundColor(isPinned ? .yellow : .primary)
                }
            }
        }
        .navigationTitle("Search Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TopSectionView: View {
    var body: some View {
        VStack {
            Image("Flag_of_Argentina")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(
                      RoundedRectangle(cornerRadius: 12)
                          .fill(Color.black.opacity(0.2))
                          .blur(radius: 10)
                  )
            
            Text("Argentina")
                .font(.title)
                .fontDesign(.default)
                .foregroundColor(Color(UIColor.label))
                .padding(.top, 7)
        }
        .padding()
        
    }
}

private struct MidSectionView: View {
    @ObservedObject var viewModel: TimePickerViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var body: some View {
        VStack {
            HStack {
                TimePickerView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// **Bottom Section**
private struct BottomSectionView: View {
    var isFocused: FocusState<Bool>.Binding
    var body: some View {
        VStack {
            DescriptionInputView(isFocused: isFocused)
            Button(action: {
                print("Save button tapped")
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 30)
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DescriptionInputView: View {
    @State private var description: String = "" // Tidak perlu default placeholder
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description (optional)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
            
            ZStack(alignment: .topLeading) {
                // **Placeholder (Hanya muncul saat teks kosong)**
                
                TextEditor(text: $description)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .focused(isFocused)
                
                if description.isEmpty {
                    Text("Type Here...")
                        .foregroundColor(Color.primary.opacity(0.25))
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 0, trailing: 0))
                        .padding(5)
                }
                
            }
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
                UITextView.appearance().tintColor = UIColor.black
            }
            .onDisappear {
                UITextView.appearance().backgroundColor = nil
            }
        }
    }
}

struct DescriptionSheet: View {
    @Binding var isPresented: Bool
    @FocusState var isFocused: Bool
    @State private var description: String = ""
    //    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Description (optional)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.top, 50)
                    .padding(.horizontal)
                
                ZStack(alignment: .topLeading) {
                    // **Placeholder (Hanya muncul saat teks kosong)**
                    
                    TextEditor(text: $description)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .focused($isFocused)
                    
                    if description.isEmpty {
                        Text("Type Here...")
                            .foregroundColor(Color.primary.opacity(0.25))
                            .padding(EdgeInsets(top: 12, leading: 10, bottom: 0, trailing: 0))
                            .padding(5)
                    }
                    
                }
                .padding(.horizontal)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                    UITextView.appearance().tintColor = UIColor.black
                }
                .onDisappear {
                    UITextView.appearance().backgroundColor = nil
                }
                
                Spacer()
                
                Button(action: {
                    print("Save button tapped")
                    isPresented.toggle()
                    
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                
                Button("Cancel") {
                    isPresented.toggle()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.red)
                .padding(.horizontal)
                .padding(.top, 30)
                
                Spacer()

            }
        }
    }
}


#Preview {
    SearchDetailView()
}
