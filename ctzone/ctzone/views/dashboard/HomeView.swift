import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigationController: NavigationViewModel
    @EnvironmentObject var userDefaultsManager : UserDefaultsManager
    
    var body: some View {
        ScrollView{
            ZStack {
                
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TopSectione(
                        country: userDefaultsManager.selectedCountry ?? Country(name: "Indonesia", timezone: "Asia/Jakarta"),
                        date: userDefaultsManager.selectedDate,
                        isPinned: $userDefaultsManager.use24HourFormat
                    )
                    
                    Divider()
                    PinnedSection()
                    ReminderSection()

                    
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
            }
            
        }
    }
}

private struct TopSectione: View {
    @Environment(\.colorScheme) var colorScheme
    let country: Country
    let date: String
    @Binding var isPinned: Bool 
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(country.name), +1UTC")
                    .font(.headline)
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                isPinned.toggle()
            }) {
                Image(systemName: isPinned ? "24.circle.fill" : "24.circle")
                    .foregroundColor(isPinned ? Color(.blue): .blue)
                    //.foregroundColor(colorScheme == .dark ? Color.yellow : Color.blue)
                    .font(.system(size: 28))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        
    }
}

private struct PinnedSection: View {
    @State var country = ["Jakarta", "Argentina", "Jakarta"]
    
    var body: some View {
        HStack{
            Text("Pinned").font(.system(size: 24)).bold()
            Spacer()
        }.frame(maxWidth: .infinity)
            .padding(.bottom, -10)
            List {
                
                ForEach(country, id: \.self) { item in
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("UTC+3")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("15:00")
                            .font(.system(size: 44, weight: .light))
                    }
                    .frame(minHeight: 50)
                    .swipeActions {
                        Button(role: .destructive) {
                            if let index = country.firstIndex(of: item) {
                                country.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.leading, -20)
            //.scrollDisabled(true)
//            .frame(minHeight: (CGFloat(country.count) * 60))
            //.frame(maxHeight: .infinity)
    }
}


private struct ReminderSection: View {
    @State var reminderTime = ["15:00","13:12"]
    var body: some View {
        HStack{
            Text("Reminder").font(.system(size: 24)).bold()
            Spacer()
        }.frame(maxWidth: .infinity)
        
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(reminderTime, id: \.self){ item in
                VStack {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(item)
                                .font(.largeTitle)
                            Text("Jakarta")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("UTC+3")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(item)
                                .font(.largeTitle)
                            Text("Argentina")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("UTC+3")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                    }.padding(.top, 10)
                        .padding(.horizontal, 16)
                        
                    
                    Divider().padding(.horizontal, 16)
                    
                    HStack{
                        //Image(systemName: "note.text")
                        Text("Pergi ke pasar Argentina").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "trash").foregroundColor(.red)
                    }.padding(.horizontal, 16)
                        .padding(.bottom, 10)
                    
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            }
        }
    }
}


