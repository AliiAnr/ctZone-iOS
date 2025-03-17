import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigationController: NavigationViewModel
    @EnvironmentObject var userDefaultsManager : UserDefaultsManager
    
    var body: some View {
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
                
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        }

    }
}

private struct TopSectione: View {
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
                    .foregroundColor(isPinned ? Color(UIColor.systemBlue): .primary)
                    .font(.system(size: 28))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        
    }
}


