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
                        location: userDefaultsManager.selectedCountry ?? Location(name: "Jakarta", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true),
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
    let location: Location
    let date: String
    @Binding var isPinned: Bool 
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(location.name), +1UTC")
                    .font(.headline)
                    //.foregroundStyle(Color("test"))
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
    @State var country = ["Jakarta", "Argentina", "Jakarta","Jakarta", "Argentina", "Jakarta","Jakarta", "Argentina", "Jakarta","Jakarta", "Argentina", "Jakarta"]

    // Definisikan nilai dasar dan padding
    let baseRowHeight: CGFloat = 60
    let verticalPadding: CGFloat = 10 // 5 atas + 5 bawah

    var body: some View {
        VStack(alignment: .leading) {
            Text("Pinned")
                .font(.system(size: 24))
                .bold()
                .padding(.horizontal)

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
                    .frame(minHeight: baseRowHeight)
                    .padding(.vertical, verticalPadding / 2) // 5 poin di atas dan 5 poin di bawah
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
            // Perhitungan tinggi: jumlah item * (baseRowHeight + verticalPadding)
            .frame(height: CGFloat(country.count) * (baseRowHeight + verticalPadding))
            .scrollDisabled(true)
        }
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


