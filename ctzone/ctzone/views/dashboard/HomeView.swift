import SwiftUI

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var navigationController: NavigationViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var timeViewModel: TimeViewModel
    var pinnedLocations: [Location] {
        locationViewModel.locations.filter { $0.isPinned }
    }
    
    var reminders: [Reminder] {
        locationViewModel.reminders
    }
    
    var shouldShowEmptyState: Bool {
        pinnedLocations.isEmpty && reminders.isEmpty
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Text("Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 6)
                
                Menu {
                    Button {
                        userDefaultsManager.use24HourFormat = true
                    } label: {
                        Label("24h Format", systemImage: userDefaultsManager.use24HourFormat ? "checkmark" : "")
                    }
                    Button {
                        userDefaultsManager.use24HourFormat = false
                    } label: {
                        Label("12h Format", systemImage: !userDefaultsManager.use24HourFormat ? "checkmark" : "")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 28))
                        .foregroundColor(Color("primeColor"))
                        .contentShape(Rectangle())
                }
                .menuStyle(DefaultMenuStyle())
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            
            TopSectione(
                location: userDefaultsManager.selectedCountry ?? Location(name: "", country: "", image: "", timezoneIdentifier: "", utcInformation: "", isCity: true, isPinned: false),
                date: userDefaultsManager.selectedDate
            )
            .id("top")
            .padding(.horizontal)
            
            devedere()
            
            
            Spacer()
            
            if shouldShowEmptyState {
                EmptyValue()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                ScrollView {
                    ZStack {
                        Color(UIColor.systemBackground)
                            .ignoresSafeArea()
                        
                        VStack {
                            
                            if !pinnedLocations.isEmpty {
                                PinnedSection(is24HourFormat: $userDefaultsManager.use24HourFormat)
                            }
                            if !reminders.isEmpty {
                                ReminderSection(is24HourFormat: $userDefaultsManager.use24HourFormat)
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
            }
            
            Spacer()
        }
    }
}


struct EmptyValue : View {
    var body : some View {
        VStack{
            Image(systemName: "clock")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("emptyColor"))
                .opacity(0.5)
                .frame(width: 170, height: 170)
            Text("Go pin a location and they will show up here")
                .font(.system(size: 20, weight: .light))
                .opacity(0.5)
                .padding(.top, 10)
                .foregroundColor(Color("text/body"))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
    }
}

struct devedere: View {
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 2)
            .padding(.horizontal)
            .overlay(
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.2))
                    .frame(height: 1)
                    .padding(.top, 9)
                    .padding(.horizontal),
                alignment: .top
            )
    }
}

private struct TopSectione: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @Environment(\.colorScheme) var colorScheme
    let location: Location
    let date: String
    
    var body: some View {
        HStack {
            if userDefaultsManager.selectedCountry != nil {
                VStack(alignment: .leading) {
                    Text("\(location.name), \(location.utcInformation ?? "")")
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(userDefaultsManager.selectedCountry?.image ?? "")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.2))
                            .blur(radius: 2)
                    )
                    .padding(.trailing, 4)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .if(userDefaultsManager.selectedCountry == nil) { view in
            view.frame(minHeight: 55)
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

private struct PinnedSection: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @Binding var is24HourFormat: Bool
    @EnvironmentObject var timeViewModel: TimeViewModel
    
    let baseRowHeight: CGFloat = 60
    let verticalPadding: CGFloat = 24
    
    var pinnedLocations: [Location] {
        locationViewModel.locations.filter { $0.isPinned }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pinned")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 8)
            
            List {
                ForEach(Array(pinnedLocations.enumerated()), id: \.element.id) { index, location in
                    
                    let dateInfo = location.getCurrentDate()
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(formattedDate(selectedDay: dateInfo?.day ?? 2, selectedMonth: dateInfo?.month ?? 2, selectedYear: dateInfo?.year ?? 2)), \(location.utcInformation ?? "No UTC")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(location.name)
                                .font(.title3)
                                .fontWeight(.light)
                            
                        }
                        
                        Spacer()
                        let timeInfo = location.currentTimeFormat(is24HourFormat: is24HourFormat, date: timeViewModel.currentDate)
                        HStack(spacing: 2) {
                            Text(timeInfo.hourMinute)
                                .font(.system(size: 44, weight: .light))
                                .foregroundColor(Color(UIColor.label))
                            if let amPm = timeInfo.amPm {
                                Text(amPm)
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(UIColor.label))
                                    .baselineOffset(-16)
                            }
                        }
                    }
                    .frame(minHeight: baseRowHeight)
                    .padding(.top, index == 0 ? 0 : verticalPadding / 2)
                    .padding(.bottom, verticalPadding / 2)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation(.easeInOut) {
                                locationViewModel.updatePinStatus(location: location, pinned: false)
                            }
                        } label: {
                            Label("Unpin", systemImage: "pin.slash")
                        }
                    }
                    .transition(.slide)
                }
            }
            .listStyle(PlainListStyle())
            .frame(height: CGFloat(pinnedLocations.count) * (baseRowHeight + verticalPadding))
            .scrollDisabled(true)
            .animation(.easeInOut, value: pinnedLocations)
        }
    }
}

private struct ReminderSection: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @Binding var is24HourFormat: Bool
    
    var reminders: [Reminder] {
        locationViewModel.reminders
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Reminder")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 16)
            
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(reminders) { reminder in
                    ReminderRow(reminder: reminder, is24HourFormat: is24HourFormat)
                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading)))
                }
                .animation(.easeInOut, value: reminders)
            }
        }
    }
}

private struct ReminderRow: View {
    var reminder: Reminder
    var is24HourFormat: Bool
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    @State private var isShowingDetail = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    withAnimation(.easeInOut) {
                        locationViewModel.removeReminder(id: reminder.id)
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            HStack {
                
                let timeInfo = reminder.currentFormattedTime(is24HourFormat: is24HourFormat)
                let cDateInfo = reminder.currentFormattedDate()
                
                let desInfo = reminder.currentFormattedTime(is24HourFormat: is24HourFormat)
                let dDateInfo = reminder.destinationFormattedDate()
                VStack(alignment: .leading) {
                    HStack (alignment: .bottom, spacing: 2){
                        Text(timeInfo.hourMinute)
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(Color(UIColor.label))
                        if let amPm = timeInfo.amPm {
                            Text("\(amPm)")
                                .font(.title3)
                                .fontWeight(.light)
                                .foregroundColor(Color(UIColor.label))
                                .baselineOffset(5)
                        }
                    }
                    Text(reminder.currentName ?? "default")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(cDateInfo)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack (alignment: .bottom, spacing: 2){
                        Text(desInfo.hourMinute)
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(Color(UIColor.label))
                        if let amPm = desInfo.amPm {
                            Text("\(amPm)")
                                .font(.title3)
                                .fontWeight(.light)
                                .foregroundColor(Color(UIColor.label))
                                .baselineOffset(5)
                        }
                    }
                    Text(reminder.destinationName ?? "default")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(dDateInfo)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 5)
            .padding(.horizontal, 16)
            
            Divider()
                .padding(.horizontal, 16)
            
            HStack {
                Text(reminder.desc ?? "default")
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingDetail = true
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .sheet(isPresented: $isShowingDetail) {
            ReminderDetailView(reminder: reminder)
                .presentationDetents([.medium])
        }
    }
}

struct ReminderDetailView: View {
    var reminder: Reminder

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Description")
                        .font(.headline)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.separator), lineWidth: 1)
                            )
                        
                        if let desc = reminder.desc, !desc.isEmpty {
                            Text(desc)
                                .foregroundColor(.primary)
                                .padding(8)
                        } else {
                            Text("No description")
                                .foregroundColor(.primary.opacity(0.25))
                                .padding(8)
                        }
                    }
                    .frame(minHeight: 120)
                }
                .padding()
            }
            .navigationTitle("Detail Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                            .font(.headline)
                            .fontWeight(.light)                            .foregroundColor(Color("primeColor"))
                    }
                }
            }
        }
    }
}



