import Foundation
import CoreData

class LocationRepository: LocationRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    // MARK: - LOCATION SECTION
    
    func fetchLocations() -> [LocationEntity] {
        let request: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            print("DEBUG: Fetching LocationEntity success")
            return try context.fetch(request)
            
        } catch {
            print("Error fetching LocationEntity: \(error)")
            return []
        }
    }
    
    func updatePinStatus(for locationId: UUID, pinned: Bool) {
        let request: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", locationId as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                entity.isPinned = pinned
                try context.save()
                print("location \(entity.name ?? "") isPinned: \(entity.isPinned)")
            }
        } catch {
            print("Error updating pin status: \(error)")
        }
    }
    
    func deleteLocation(withId id: UUID) {
        let request: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                try context.save()
                print("DEBUG: Successfully deleted location with id: \(id)")
            }
        } catch {
            print("DEBUG: Error deleting location: \(error)")
        }
    }
    
    func fetchLocation(by id: UUID) -> LocationEntity? {
        let request: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching location by id: \(error)")
            return nil
        }
    }
    
    
    //    MARK: - REMINDER SECTION
    
    // MARK: - Insert (WITHOUT RELATIONSHIP WITH LOCATION) -> next Fitur (User can see their list of reminder in the destination location) if needed
    
    func insertReminder(_ reminder: Reminder) -> Bool {
        let entity = ReminderEntity(context: context)
        
        entity.id = reminder.id
        
        entity.currentHour = Int32(reminder.currentHour)
        entity.currentMinute = Int32(reminder.currentMinute)
        entity.currentDay = Int32(reminder.currentDay)
        entity.currentMonth = Int32(reminder.currentMonth)
        entity.currentYear = Int32(reminder.currentYear)
        
        entity.destinationHour = Int32(reminder.destinationHour)
        entity.destinationMinute = Int32(reminder.destinationMinute)
        entity.destinationDay = Int32(reminder.destinationDay)
        entity.destinationMonth = Int32(reminder.destinationMonth)
        entity.destinationYear = Int32(reminder.destinationYear)
        
        entity.timestamp = reminder.timestamp
        
        entity.desc = reminder.desc
        
        entity.currentName = reminder.currentName
        entity.currentImage = reminder.currentImage
        entity.currentCountry = reminder.currentCountry
        entity.currentTimezone = reminder.currentTimezone
        entity.currentUtc = reminder.currentUtc
        
        entity.destinationName = reminder.destinationName
        entity.destinationImage = reminder.destinationImage
        entity.destinationCountry = reminder.destinationCountry
        entity.destinationTimezone = reminder.destinationTimezone
        entity.destinationUtc = reminder.destinationUtc
        
        do {
            try context.save()
            print("DEBUG: Successfully insert reminder with id: \(reminder.id)")
            return true
        } catch {
            print("Error inserting reminder: \(error)")
            return false
        }
    }
    
    func fetchAllReminders() -> [Reminder] {
        let request: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { mapEntityToModel($0) }
        } catch {
            print("Error fetching all reminders: \(error)")
            return []
        }
    }
    
    func deleteReminder(by id: UUID) -> Bool {
        let request: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
                return true
            }
        } catch {
            print("Error deleting reminder: \(error)")
        }
        return false
    }
    
    func deleteAllReminders() -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReminderEntity")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        batchDelete.resultType = .resultTypeObjectIDs
        
        do {
            if let result = try context.execute(batchDelete) as? NSBatchDeleteResult,
               let objectIDs = result.result as? [NSManagedObjectID] {
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [context])
                return true
            }
        } catch {
            print("Error deleting all reminders: \(error)")
        }
        return false
    }
    
    func fetchRemindersSortedByTimestamp() -> [Reminder] {
            let request: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
            
            do {
                let results = try context.fetch(request)
                return results.map { mapEntityToModel($0) }
            } catch {
                print("Error fetching reminders sorted by timestamp: \(error)")
                return []
            }
        }
    
    func fetchReminder(by id: UUID) -> Reminder? {
            let request: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try context.fetch(request)
                if let entity = results.first {
                    return mapEntityToModel(entity)
                }
            } catch {
                print("Error fetching reminder by id: \(error)")
            }
            return nil
        }
    
    private func mapEntityToModel(_ entity: ReminderEntity) -> Reminder {
        return Reminder(
            id: entity.id ?? UUID(),
            
            currentHour: Int(entity.currentHour),
            currentMinute: Int(entity.currentMinute),
            currentDay: Int(entity.currentDay),
            currentMonth: Int(entity.currentMonth),
            currentYear: Int(entity.currentYear),
            
            destinationHour: Int(entity.destinationHour),
            destinationMinute: Int(entity.destinationMinute),
            destinationDay: Int(entity.destinationDay),
            destinationMonth: Int(entity.destinationMonth),
            destinationYear: Int(entity.destinationYear),
            
            timestamp: entity.timestamp ?? Date(),
            
            desc: entity.desc,
            
            currentName: entity.currentName,
            currentImage: entity.currentImage,
            currentCountry: entity.currentCountry,
            currentTimezone: entity.currentTimezone,
            currentUtc: entity.currentUtc,
            
            destinationName: entity.destinationName,
            destinationImage: entity.destinationImage,
            destinationCountry: entity.destinationCountry,
            destinationTimezone: entity.destinationTimezone,
            destinationUtc: entity.destinationUtc
        )
    }
    
    
    
    func addDummyLocationsIfNeeded() {
        let count = fetchLocations().count
        print("Count OIWOWW: \(count)")
        if count == 0 {
            
            let dummyData: [Location] = [
                Location(name: "Afghanistan", country: "Afghanistan", image: "Afghanistan", timezoneIdentifier: "Asia/Kabul", utcInformation: "UTC+4:30", isCity: false),
                Location(name: "Albania", country: "Albania", image: "Albania", timezoneIdentifier: "Europe/Tirane", utcInformation: "UTC+1", isCity: false),
                Location(name: "Algeria", country: "Algeria", image: "Algeria", timezoneIdentifier: "Africa/Algiers", utcInformation: "UTC+1", isCity: false),
                Location(name: "Andorra", country: "Andorra", image: "Andorra", timezoneIdentifier: "Europe/Andorra", utcInformation: "UTC+1", isCity: false),
                Location(name: "Angola", country: "Angola", image: "Angola", timezoneIdentifier: "Africa/Luanda", utcInformation: "UTC+1", isCity: false),
                Location(name: "Antigua and Barbuda", country: "Antigua and Barbuda", image: "Antigua_and_Barbuda", timezoneIdentifier: "America/Antigua", utcInformation: "UTC-4", isCity: false),
                Location(name: "Argentina", country: "Argentina", image: "Argentina", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: false),
                Location(name: "Armenia", country: "Armenia", image: "Armenia", timezoneIdentifier: "Asia/Yerevan", utcInformation: "UTC+4", isCity: false),
                Location(name: "Australia", country: "Australia", image: "Australia", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: false),
                Location(name: "Austria", country: "Austria", image: "Austria", timezoneIdentifier: "Europe/Vienna", utcInformation: "UTC+1", isCity: false),
                Location(name: "Azerbaijan", country: "Azerbaijan", image: "Azerbaijan", timezoneIdentifier: "Asia/Baku", utcInformation: "UTC+4", isCity: false),
                Location(name: "Bahamas", country: "Bahamas", image: "Bahamas", timezoneIdentifier: "America/Nassau", utcInformation: "UTC-5", isCity: false),
                Location(name: "Bahrain", country: "Bahrain", image: "Bahrain", timezoneIdentifier: "Asia/Bahrain", utcInformation: "UTC+3", isCity: false),
                Location(name: "Bangladesh", country: "Bangladesh", image: "Bangladesh", timezoneIdentifier: "Asia/Dhaka", utcInformation: "UTC+6", isCity: false),
                Location(name: "Barbados", country: "Barbados", image: "Barbados", timezoneIdentifier: "America/Barbados", utcInformation: "UTC-4", isCity: false),
                Location(name: "Belarus", country: "Belarus", image: "Belarus", timezoneIdentifier: "Europe/Minsk", utcInformation: "UTC+3", isCity: false),
                Location(name: "Belgium", country: "Belgium", image: "Belgium", timezoneIdentifier: "Europe/Brussels", utcInformation: "UTC+1", isCity: false),
                Location(name: "Belize", country: "Belize", image: "Belize", timezoneIdentifier: "America/Belize", utcInformation: "UTC-6", isCity: false),
                Location(name: "Benin", country: "Benin", image: "Benin", timezoneIdentifier: "Africa/Porto-Novo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Bhutan", country: "Bhutan", image: "Bhutan", timezoneIdentifier: "Asia/Thimphu", utcInformation: "UTC+6", isCity: false),
                Location(name: "Bolivia", country: "Bolivia", image: "Bolivia", timezoneIdentifier: "America/La_Paz", utcInformation: "UTC-4", isCity: false),
                Location(name: "Bosnia and Herzegovina", country: "Bosnia and Herzegovina", image: "Bosnia_and_Herzegovina", timezoneIdentifier: "Europe/Sarajevo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Botswana", country: "Botswana", image: "Botswana", timezoneIdentifier: "Africa/Gaborone", utcInformation: "UTC+2", isCity: false),
                Location(name: "Brazil", country: "Brazil", image: "Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: false),
                Location(name: "Brunei", country: "Brunei", image: "Brunei", timezoneIdentifier: "Asia/Brunei", utcInformation: "UTC+8", isCity: false),
                Location(name: "Bulgaria", country: "Bulgaria", image: "Bulgaria", timezoneIdentifier: "Europe/Sofia", utcInformation: "UTC+2", isCity: false),
                Location(name: "Burkina Faso", country: "Burkina Faso", image: "Burkina_Faso", timezoneIdentifier: "Africa/Ouagadougou", utcInformation: "UTC+0", isCity: false),
                Location(name: "Burundi", country: "Burundi", image: "Burundi", timezoneIdentifier: "Africa/Bujumbura", utcInformation: "UTC+2", isCity: false),
                Location(name: "Cabo Verde", country: "Cabo Verde", image: "Cape_Verde", timezoneIdentifier: "Atlantic/Cape_Verde", utcInformation: "UTC-1", isCity: false),
                Location(name: "Cambodia", country: "Cambodia", image: "Cambodia", timezoneIdentifier: "Asia/Phnom_Penh", utcInformation: "UTC+7", isCity: false),
                Location(name: "Cameroon", country: "Cameroon", image: "Cameroon", timezoneIdentifier: "Africa/Douala", utcInformation: "UTC+1", isCity: false),
                Location(name: "Canada", country: "Canada", image: "Canada", timezoneIdentifier: "America/Toronto", utcInformation: "UTC-5", isCity: false),
                Location(name: "Central African Republic", country: "Central African Republic", image: "Central_African_Republic", timezoneIdentifier: "Africa/Bangui", utcInformation: "UTC+1", isCity: false),
                Location(name: "Chad", country: "Chad", image: "Chad", timezoneIdentifier: "Africa/Ndjamena", utcInformation: "UTC+1", isCity: false),
                Location(name: "Chile", country: "Chile", image: "Chile", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: false),
                Location(name: "China", country: "China", image: "Peoples_Republic_of_China", timezoneIdentifier: "Asia/Shanghai", utcInformation: "UTC+8", isCity: false),
                Location(name: "Colombia", country: "Colombia", image: "Colombia", timezoneIdentifier: "America/Bogota", utcInformation: "UTC-5", isCity: false),
                Location(name: "Comoros", country: "Comoros", image: "Comoros", timezoneIdentifier: "Indian/Comoro", utcInformation: "UTC+3", isCity: false),
                Location(name: "Congo (Congo-Brazzaville)", country: "Congo", image: "Republic_of_Congo", timezoneIdentifier: "Africa/Brazzaville", utcInformation: "UTC+1", isCity: false),
                Location(name: "Costa Rica", country: "Costa Rica", image: "Costa_Rica", timezoneIdentifier: "America/Costa_Rica", utcInformation: "UTC-6", isCity: false),
                Location(name: "Croatia", country: "Croatia", image: "Croatia", timezoneIdentifier: "Europe/Zagreb", utcInformation: "UTC+1", isCity: false),
                Location(name: "Cuba", country: "Cuba", image: "Cuba", timezoneIdentifier: "America/Havana", utcInformation: "UTC-5", isCity: false),
                Location(name: "Cyprus", country: "Cyprus", image: "Cyprus", timezoneIdentifier: "Asia/Nicosia", utcInformation: "UTC+2", isCity: false),
                Location(name: "Czech Republic", country: "Czech Republic", image: "Czech_Republic", timezoneIdentifier: "Europe/Prague", utcInformation: "UTC+1", isCity: false),
                Location(name: "Denmark", country: "Denmark", image: "Denmark", timezoneIdentifier: "Europe/Copenhagen", utcInformation: "UTC+1", isCity: false),
                Location(name: "Djibouti", country: "Djibouti", image: "Djibouti", timezoneIdentifier: "Africa/Djibouti", utcInformation: "UTC+3", isCity: false),
                Location(name: "Dominica", country: "Dominica", image: "Dominica", timezoneIdentifier: "America/Dominica", utcInformation: "UTC-4", isCity: false),
                Location(name: "Dominican Republic", country: "Dominican Republic", image: "Dominican_Republic", timezoneIdentifier: "America/Santo_Domingo", utcInformation: "UTC-4", isCity: false),
                Location(name: "East Timor", country: "East Timor", image: "East_Timor", timezoneIdentifier: "Asia/Dili", utcInformation: "UTC+9", isCity: false),
                Location(name: "Ecuador", country: "Ecuador", image: "Ecuador", timezoneIdentifier: "America/Guayaquil", utcInformation: "UTC-5", isCity: false),
                Location(name: "Egypt", country: "Egypt", image: "Egypt", timezoneIdentifier: "Africa/Cairo", utcInformation: "UTC+2", isCity: false),
                Location(name: "El Salvador", country: "El Salvador", image: "El_Salvador", timezoneIdentifier: "America/El_Salvador", utcInformation: "UTC-6", isCity: false),
                Location(name: "Equatorial Guinea", country: "Equatorial Guinea", image: "Equatorial_Guinea", timezoneIdentifier: "Africa/Malabo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Eritrea", country: "Eritrea", image: "Eritrea", timezoneIdentifier: "Africa/Asmara", utcInformation: "UTC+3", isCity: false),
                Location(name: "Estonia", country: "Estonia", image: "Estonia", timezoneIdentifier: "Europe/Tallinn", utcInformation: "UTC+2", isCity: false),
                Location(name: "Eswatini", country: "Eswatini", image: "Eswatini", timezoneIdentifier: "Africa/Mbabane", utcInformation: "UTC+2", isCity: false),
                Location(name: "Ethiopia", country: "Ethiopia", image: "Ethiopia", timezoneIdentifier: "Africa/Addis_Ababa", utcInformation: "UTC+3", isCity: false),
                Location(name: "Fiji", country: "Fiji", image: "Fiji", timezoneIdentifier: "Pacific/Fiji", utcInformation: "UTC+12", isCity: false),
                Location(name: "Finland", country: "Finland", image: "Finland", timezoneIdentifier: "Europe/Helsinki", utcInformation: "UTC+2", isCity: false),
                Location(name: "France", country: "France", image: "France", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: false),
                Location(name: "Gabon", country: "Gabon", image: "Gabon", timezoneIdentifier: "Africa/Libreville", utcInformation: "UTC+1", isCity: false),
                Location(name: "Gambia", country: "Gambia", image: "Gambia", timezoneIdentifier: "Africa/Banjul", utcInformation: "UTC+0", isCity: false),
                Location(name: "Georgia", country: "Georgia", image: "Georgia", timezoneIdentifier: "Asia/Tbilisi", utcInformation: "UTC+4", isCity: false),
                Location(name: "Germany", country: "Germany", image: "Germany", timezoneIdentifier: "Europe/Berlin", utcInformation: "UTC+1", isCity: false),
                Location(name: "Ghana", country: "Ghana", image: "Ghana", timezoneIdentifier: "Africa/Accra", utcInformation: "UTC+0", isCity: false),
                Location(name: "Greece", country: "Greece", image: "Greece", timezoneIdentifier: "Europe/Athens", utcInformation: "UTC+2", isCity: false),
                Location(name: "Grenada", country: "Grenada", image: "Grenada", timezoneIdentifier: "America/Grenada", utcInformation: "UTC-4", isCity: false),
                Location(name: "Guatemala", country: "Guatemala", image: "Guatemala", timezoneIdentifier: "America/Guatemala", utcInformation: "UTC-6", isCity: false),
                Location(name: "Guinea", country: "Guinea", image: "Guinea", timezoneIdentifier: "Africa/Conakry", utcInformation: "UTC+0", isCity: false),
                Location(name: "Guinea-Bissau", country: "Guinea-Bissau", image: "Guinea_Bissau", timezoneIdentifier: "Africa/Bissau", utcInformation: "UTC+0", isCity: false),
                Location(name: "Guyana", country: "Guyana", image: "Guyana", timezoneIdentifier: "America/Guyana", utcInformation: "UTC-4", isCity: false),
                Location(name: "Haiti", country: "Haiti", image: "Haiti", timezoneIdentifier: "America/Port-au-Prince", utcInformation: "UTC-5", isCity: false),
                Location(name: "Honduras", country: "Honduras", image: "Honduras", timezoneIdentifier: "America/Tegucigalpa", utcInformation: "UTC-6", isCity: false),
                Location(name: "Hungary", country: "Hungary", image: "Hungary", timezoneIdentifier: "Europe/Budapest", utcInformation: "UTC+1", isCity: false),
                Location(name: "Iceland", country: "Iceland", image: "Iceland", timezoneIdentifier: "Atlantic/Reykjavik", utcInformation: "UTC+0", isCity: false),
                Location(name: "India", country: "India", image: "India", timezoneIdentifier: "Asia/Kolkata", utcInformation: "UTC+5:30", isCity: false),
                Location(name: "Indonesia", country: "Indonesia", image: "Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation: "UTC+7", isCity: false),
                Location(name: "Iran", country: "Iran", image: "Iran", timezoneIdentifier: "Asia/Tehran", utcInformation: "UTC+3:30", isCity: false),
                Location(name: "Iraq", country: "Iraq", image: "Iraq", timezoneIdentifier: "Asia/Baghdad", utcInformation: "UTC+3", isCity: false),
                Location(name: "Ireland", country: "Ireland", image: "Ireland", timezoneIdentifier: "Europe/Dublin", utcInformation: "UTC+0", isCity: false),
                Location(name: "Israel", country: "Israel", image: "Israel", timezoneIdentifier: "Asia/Jerusalem", utcInformation: "UTC+2", isCity: false),
                Location(name: "Italy", country: "Italy", image: "Italy", timezoneIdentifier: "Europe/Rome", utcInformation: "UTC+1", isCity: false),
                Location(name: "Jamaica", country: "Jamaica", image: "Jamaica", timezoneIdentifier: "America/Jamaica", utcInformation: "UTC-5", isCity: false),
                Location(name: "Japan", country: "Japan", image: "Japan", timezoneIdentifier: "Asia/Tokyo", utcInformation: "UTC+9", isCity: false),
                Location(name: "Jordan", country: "Jordan", image: "Jordan", timezoneIdentifier: "Asia/Amman", utcInformation: "UTC+2", isCity: false),
                Location(name: "Kazakhstan", country: "Kazakhstan", image: "Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation: "UTC+6", isCity: false),
                Location(name: "Kenya", country: "Kenya", image: "Kenya", timezoneIdentifier: "Africa/Nairobi", utcInformation: "UTC+3", isCity: false),
                Location(name: "Kiribati", country: "Kiribati", image: "Kiribati", timezoneIdentifier: "Pacific/Tarawa", utcInformation: "UTC+12", isCity: false),
                Location(name: "Kuwait", country: "Kuwait", image: "Kuwait", timezoneIdentifier: "Asia/Kuwait", utcInformation: "UTC+3", isCity: false),
                Location(name: "Kyrgyzstan", country: "Kyrgyzstan", image: "Kyrgyzstan", timezoneIdentifier: "Asia/Bishkek", utcInformation: "UTC+6", isCity: false),
                Location(name: "Laos", country: "Laos", image: "Laos", timezoneIdentifier: "Asia/Vientiane", utcInformation: "UTC+7", isCity: false),
                Location(name: "Latvia", country: "Latvia", image: "Latvia", timezoneIdentifier: "Europe/Riga", utcInformation: "UTC+2", isCity: false),
                Location(name: "Lebanon", country: "Lebanon", image: "Lebanon", timezoneIdentifier: "Asia/Beirut", utcInformation: "UTC+2", isCity: false),
                Location(name: "Lesotho", country: "Lesotho", image: "Lesotho", timezoneIdentifier: "Africa/Maseru", utcInformation: "UTC+2", isCity: false),
                Location(name: "Liberia", country: "Liberia", image: "Liberia", timezoneIdentifier: "Africa/Monrovia", utcInformation: "UTC+0", isCity: false),
                Location(name: "Libya", country: "Libya", image: "Libya", timezoneIdentifier: "Africa/Tripoli", utcInformation: "UTC+2", isCity: false),
                Location(name: "Liechtenstein", country: "Liechtenstein", image: "Liechtenstein", timezoneIdentifier: "Europe/Vaduz", utcInformation: "UTC+1", isCity: false),
                Location(name: "Lithuania", country: "Lithuania", image: "Lithuania", timezoneIdentifier: "Europe/Vilnius", utcInformation: "UTC+2", isCity: false),
                Location(name: "Luxembourg", country: "Luxembourg", image: "Luxembourg", timezoneIdentifier: "Europe/Luxembourg", utcInformation: "UTC+1", isCity: false),
                Location(name: "Madagascar", country: "Madagascar", image: "Madagascar", timezoneIdentifier: "Indian/Antananarivo", utcInformation: "UTC+3", isCity: false),
                Location(name: "Malawi", country: "Malawi", image: "Malawi", timezoneIdentifier: "Africa/Blantyre", utcInformation: "UTC+2", isCity: false),
                Location(name: "Malaysia", country: "Malaysia", image: "Malaysia", timezoneIdentifier: "Asia/Kuala_Lumpur", utcInformation: "UTC+8", isCity: false),
                Location(name: "Maldives", country: "Maldives", image: "Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation: "UTC+5", isCity: false),
                Location(name: "Mali", country: "Mali", image: "Mali", timezoneIdentifier: "Africa/Bamako", utcInformation: "UTC+0", isCity: false),
                Location(name: "Malta", country: "Malta", image: "Malta", timezoneIdentifier: "Europe/Malta", utcInformation: "UTC+1", isCity: false),
                Location(name: "Marshall Islands", country: "Marshall Islands", image: "Marshall_Islands", timezoneIdentifier: "Pacific/Majuro", utcInformation: "UTC+12", isCity: false),
                Location(name: "Mauritania", country: "Mauritania", image: "Mauritania", timezoneIdentifier: "Africa/Nouakchott", utcInformation: "UTC+0", isCity: false),
                Location(name: "Mauritius", country: "Mauritius", image: "Mauritius", timezoneIdentifier: "Indian/Mauritius", utcInformation: "UTC+4", isCity: false),
                Location(name: "Mexico", country: "Mexico", image: "Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: false),
                Location(name: "Micronesia", country: "Micronesia", image: "Federated_States_of_Micronesia", timezoneIdentifier: "Pacific/Chuuk", utcInformation: "UTC+10", isCity: false),
                Location(name: "Moldova", country: "Moldova", image: "Moldova", timezoneIdentifier: "Europe/Chisinau", utcInformation: "UTC+2", isCity: false),
                Location(name: "Monaco", country: "Monaco", image: "Monaco", timezoneIdentifier: "Europe/Monaco", utcInformation: "UTC+1", isCity: false),
                Location(name: "Mongolia", country: "Mongolia", image: "Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation: "UTC+8", isCity: false),
                Location(name: "Montenegro", country: "Montenegro", image: "Montenegro", timezoneIdentifier: "Europe/Podgorica", utcInformation: "UTC+1", isCity: false),
                Location(name: "Morocco", country: "Morocco", image: "Morocco", timezoneIdentifier: "Africa/Casablanca", utcInformation: "UTC+1", isCity: false),
                Location(name: "Mozambique", country: "Mozambique", image: "Mozambique", timezoneIdentifier: "Africa/Maputo", utcInformation: "UTC+2", isCity: false),
                Location(name: "Myanmar (Burma)", country: "Myanmar", image: "Myanmar", timezoneIdentifier: "Asia/Yangon", utcInformation: "UTC+6:30", isCity: false),
                Location(name: "Namibia", country: "Namibia", image: "Namibia", timezoneIdentifier: "Africa/Windhoek", utcInformation: "UTC+2", isCity: false),
                Location(name: "Nauru", country: "Nauru", image: "Nauru", timezoneIdentifier: "Pacific/Nauru", utcInformation: "UTC+12", isCity: false),
                Location(name: "Nepal", country: "Nepal", image: "Nepal", timezoneIdentifier: "Asia/Kathmandu", utcInformation: "UTC+5:45", isCity: false),
                Location(name: "Netherlands", country: "Netherlands", image: "Netherlands", timezoneIdentifier: "Europe/Amsterdam", utcInformation: "UTC+1", isCity: false),
                Location(name: "New Zealand", country: "New Zealand", image: "New_Zealand", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: false),
                Location(name: "Nicaragua", country: "Nicaragua", image: "Nicaragua", timezoneIdentifier: "America/Managua", utcInformation: "UTC-6", isCity: false),
                Location(name: "Niger", country: "Niger", image: "Niger", timezoneIdentifier: "Africa/Niamey", utcInformation: "UTC+1", isCity: false),
                Location(name: "Nigeria", country: "Nigeria", image: "Nigeria", timezoneIdentifier: "Africa/Lagos", utcInformation: "UTC+1", isCity: false),
                Location(name: "North Korea", country: "North Korea", image: "North_Korea", timezoneIdentifier: "Asia/Pyongyang", utcInformation: "UTC+9", isCity: false),
                Location(name: "North Macedonia", country: "North Macedonia", image: "North_Macedonia", timezoneIdentifier: "Europe/Skopje", utcInformation: "UTC+1", isCity: false),
                Location(name: "Norway", country: "Norway", image: "Norway", timezoneIdentifier: "Europe/Oslo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Oman", country: "Oman", image: "Oman", timezoneIdentifier: "Asia/Muscat", utcInformation: "UTC+4", isCity: false),
                Location(name: "Pakistan", country: "Pakistan", image: "Pakistan", timezoneIdentifier: "Asia/Karachi", utcInformation: "UTC+5", isCity: false),
                Location(name: "Palau", country: "Palau", image: "Palau", timezoneIdentifier: "Pacific/Palau", utcInformation: "UTC+9", isCity: false),
                Location(name: "Panama", country: "Panama", image: "Panama", timezoneIdentifier: "America/Panama", utcInformation: "UTC-5", isCity: false),
                Location(name: "Papua New Guinea", country: "Papua New Guinea", image: "Papua_New_Guinea", timezoneIdentifier: "Pacific/Port_Moresby", utcInformation: "UTC+10", isCity: false),
                Location(name: "Paraguay", country: "Paraguay", image: "Paraguay", timezoneIdentifier: "America/Asuncion", utcInformation: "UTC-4", isCity: false),
                Location(name: "Peru", country: "Peru", image: "Peru", timezoneIdentifier: "America/Lima", utcInformation: "UTC-5", isCity: false),
                Location(name: "Philippines", country: "Philippines", image: "Philippines", timezoneIdentifier: "Asia/Manila", utcInformation: "UTC+8", isCity: false),
                Location(name: "Poland", country: "Poland", image: "Poland", timezoneIdentifier: "Europe/Warsaw", utcInformation: "UTC+1", isCity: false),
                Location(name: "Portugal", country: "Portugal", image: "Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: false),
                Location(name: "Qatar", country: "Qatar", image: "Qatar", timezoneIdentifier: "Asia/Qatar", utcInformation: "UTC+3", isCity: false),
                Location(name: "Romania", country: "Romania", image: "Romania", timezoneIdentifier: "Europe/Bucharest", utcInformation: "UTC+2", isCity: false),
                Location(name: "Russia", country: "Russia", image: "Russia", timezoneIdentifier: "Asia/Moscow", utcInformation: "UTC+3", isCity: false),
                Location(name: "Rwanda", country: "Rwanda", image: "Rwanda", timezoneIdentifier: "Africa/Kigali", utcInformation: "UTC+2", isCity: false),
                Location(name: "Saint Kitts and Nevis", country: "Saint Kitts and Nevis", image: "Saint_Kitts_and_Nevis", timezoneIdentifier: "America/St_Kitts", utcInformation: "UTC-4", isCity: false),
                Location(name: "Saint Lucia", country: "Saint Lucia", image: "Saint_Lucia", timezoneIdentifier: "America/St_Lucia", utcInformation: "UTC-4", isCity: false),
                Location(name: "Saint Vincent and the Grenadines", country: "Saint Vincent and the Grenadines", image: "Saint_Vincent_and_the_Grenadines", timezoneIdentifier: "America/St_Vincent", utcInformation: "UTC-4", isCity: false),
                Location(name: "Samoa", country: "Samoa", image: "Samoa", timezoneIdentifier: "Pacific/Apia", utcInformation: "UTC+13", isCity: false),
                Location(name: "San Marino", country: "San Marino", image: "San_Marino", timezoneIdentifier: "Europe/San_Marino", utcInformation: "UTC+1", isCity: false),
                Location(name: "Sao Tome and Principe", country: "Sao Tome and Principe", image: "Sao_Tome_and_Principe", timezoneIdentifier: "Africa/Sao_Tome", utcInformation: "UTC+0", isCity: false),
                Location(name: "Saudi Arabia", country: "Saudi Arabia", image: "Saudi_Arabia", timezoneIdentifier: "Asia/Riyadh", utcInformation: "UTC+3", isCity: false),
                Location(name: "Senegal", country: "Senegal", image: "Senegal", timezoneIdentifier: "Africa/Dakar", utcInformation: "UTC+0", isCity: false),
                Location(name: "Serbia", country: "Serbia", image: "Serbia", timezoneIdentifier: "Europe/Belgrade", utcInformation: "UTC+1", isCity: false),
                Location(name: "Seychelles", country: "Seychelles", image: "Seychelles", timezoneIdentifier: "Indian/Mahe", utcInformation: "UTC+4", isCity: false),
                Location(name: "Sierra Leone", country: "Sierra Leone", image: "Sierra_Leone", timezoneIdentifier: "Africa/Freetown", utcInformation: "UTC+0", isCity: false),
                Location(name: "Singapore", country: "Singapore", image: "Singapore", timezoneIdentifier: "Asia/Singapore", utcInformation: "UTC+8", isCity: false),
                Location(name: "Slovakia", country: "Slovakia", image: "Slovakia", timezoneIdentifier: "Europe/Bratislava", utcInformation: "UTC+1", isCity: false),
                Location(name: "Slovenia", country: "Slovenia", image: "Slovenia", timezoneIdentifier: "Europe/Ljubljana", utcInformation: "UTC+1", isCity: false),
                Location(name: "Solomon Islands", country: "Solomon Islands", image: "Solomon_Islands", timezoneIdentifier: "Pacific/Guadalcanal", utcInformation: "UTC+11", isCity: false),
                Location(name: "Somalia", country: "Somalia", image: "Somalia", timezoneIdentifier: "Africa/Mogadishu", utcInformation: "UTC+3", isCity: false),
                Location(name: "South Africa", country: "South Africa", image: "South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: false),
                Location(name: "South Sudan", country: "South Sudan", image: "South_Sudan", timezoneIdentifier: "Africa/Juba", utcInformation: "UTC+2", isCity: false),
                Location(name: "Spain", country: "Spain", image: "Spain", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: false),
                Location(name: "Sri Lanka", country: "Sri Lanka", image: "Sri_Lanka", timezoneIdentifier: "Asia/Colombo", utcInformation: "UTC+5:30", isCity: false),
                Location(name: "Sudan", country: "Sudan", image: "Sudan", timezoneIdentifier: "Africa/Khartoum", utcInformation: "UTC+2", isCity: false),
                Location(name: "Suriname", country: "Suriname", image: "Suriname", timezoneIdentifier: "America/Paramaribo", utcInformation: "UTC-3", isCity: false),
                Location(name: "Sweden", country: "Sweden", image: "Sweden", timezoneIdentifier: "Europe/Stockholm", utcInformation: "UTC+1", isCity: false),
                Location(name: "Switzerland", country: "Switzerland", image: "Switzerland", timezoneIdentifier: "Europe/Zurich", utcInformation: "UTC+1", isCity: false),
                Location(name: "Syria", country: "Syria", image: "Syria", timezoneIdentifier: "Asia/Damascus", utcInformation: "UTC+2", isCity: false),
                Location(name: "Taiwan", country: "Taiwan", image: "Taiwan_Republic_of_China", timezoneIdentifier: "Asia/Taipei", utcInformation: "UTC+8", isCity: false),
                Location(name: "Tajikistan", country: "Tajikistan", image: "Tajikistan", timezoneIdentifier: "Asia/Dushanbe", utcInformation: "UTC+5", isCity: false),
                Location(name: "Tanzania", country: "Tanzania", image: "Tanzania", timezoneIdentifier: "Africa/Dar_es_Salaam", utcInformation: "UTC+3", isCity: false),
                Location(name: "Thailand", country: "Thailand", image: "Thailand", timezoneIdentifier: "Asia/Bangkok", utcInformation: "UTC+7", isCity: false),
                Location(name: "Togo", country: "Togo", image: "Togo", timezoneIdentifier: "Africa/Lome", utcInformation: "UTC+0", isCity: false),
                Location(name: "Tonga", country: "Tonga", image: "Tonga", timezoneIdentifier: "Pacific/Tongatapu", utcInformation: "UTC+13", isCity: false),
                Location(name: "Trinidad and Tobago", country: "Trinidad and Tobago", image: "Trinidad_and_Tobago", timezoneIdentifier: "America/Port_of_Spain", utcInformation: "UTC-4", isCity: false),
                Location(name: "Tunisia", country: "Tunisia", image: "Tunisia", timezoneIdentifier: "Africa/Tunis", utcInformation: "UTC+1", isCity: false),
                Location(name: "Turkey", country: "Turkey", image: "Turkey", timezoneIdentifier: "Europe/Istanbul", utcInformation: "UTC+3", isCity: false),
                Location(name: "Turkmenistan", country: "Turkmenistan", image: "Turkmenistan", timezoneIdentifier: "Asia/Ashgabat", utcInformation: "UTC+5", isCity: false),
                Location(name: "Tuvalu", country: "Tuvalu", image: "Tuvalu", timezoneIdentifier: "Pacific/Funafuti", utcInformation: "UTC+12", isCity: false),
                Location(name: "Uganda", country: "Uganda", image: "Uganda", timezoneIdentifier: "Africa/Kampala", utcInformation: "UTC+3", isCity: false),
                Location(name: "Ukraine", country: "Ukraine", image: "Ukraine", timezoneIdentifier: "Europe/Kiev", utcInformation: "UTC+2", isCity: false),
                Location(name: "United Arab Emirates", country: "United Arab Emirates", image: "United_Arab_Emirates", timezoneIdentifier: "Asia/Dubai", utcInformation: "UTC+4", isCity: false),
                Location(name: "United Kingdom", country: "United Kingdom", image: "United_Kingdom", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: false),
                Location(name: "United States", country: "USA", image: "Usa", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: false),
                Location(name: "Uruguay", country: "Uruguay", image: "Uruguay", timezoneIdentifier: "America/Montevideo", utcInformation: "UTC-3", isCity: false),
                Location(name: "Uzbekistan", country: "Uzbekistan", image: "Uzbekistan", timezoneIdentifier: "Asia/Tashkent", utcInformation: "UTC+5", isCity: false),
                Location(name: "Vanuatu", country: "Vanuatu", image: "Vanuatu", timezoneIdentifier: "Pacific/Efate", utcInformation: "UTC+11", isCity: false),
                Location(name: "Vatican City", country: "Vatican City", image: "Vatican_City", timezoneIdentifier: "Europe/Vatican", utcInformation: "UTC+1", isCity: false),
                Location(name: "Venezuela", country: "Venezuela", image: "Venezuela", timezoneIdentifier: "America/Caracas", utcInformation: "UTC-4", isCity: false),
                Location(name: "Vietnam", country: "Vietnam", image: "Vietnam", timezoneIdentifier: "Asia/Ho_Chi_Minh", utcInformation: "UTC+7", isCity: false),
                Location(name: "Yemen", country: "Yemen", image: "Yemen", timezoneIdentifier: "Asia/Aden", utcInformation: "UTC+3", isCity: false),
                Location(name: "Zambia", country: "Zambia", image: "Zambia", timezoneIdentifier: "Africa/Lusaka", utcInformation: "UTC+2", isCity: false),
                Location(name: "Zimbabwe", country: "Zimbabwe", image: "Zimbabwe", timezoneIdentifier: "Africa/Harare", utcInformation: "UTC+2", isCity: false),
                
                Location(name: "Kaliningrad", country: "Russia", image:"Russia", timezoneIdentifier: "Europe/Kaliningrad", utcInformation:"UTC+2", isCity: true),
                Location(name: "Moscow", country: "Russia", image:"Russia", timezoneIdentifier: "Europe/Moscow", utcInformation:"UTC+3", isCity: true),
                Location(name: "Saint Petersburg", country: "Russia", image:"Russia", timezoneIdentifier: "Europe/Moscow", utcInformation:"UTC+3", isCity: true),
                Location(name: "Samara", country: "Russia", image:"Russia", timezoneIdentifier: "Europe/Samara", utcInformation:"UTC+4", isCity: true),
                Location(name: "Udmurtia", country: "Russia", image:"Russia", timezoneIdentifier: "Europe/Samara", utcInformation:"UTC+4", isCity: true),
                Location(name: "Yekaterinburg", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation:"UTC+5", isCity: true),
                Location(name: "Chelyabinsk", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation:"UTC+5", isCity: true),
                Location(name: "Omsk", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Omsk", utcInformation:"UTC+6", isCity: true),
                Location(name: "Novosibirsk", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Novosibirsk", utcInformation:"UTC+6", isCity: true),
                Location(name: "Krasnoyarsk", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Krasnoyarsk", utcInformation:"UTC+7", isCity: true),
                Location(name: "Irkutsk", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Irkutsk", utcInformation:"UTC+8", isCity: true),
                Location(name: "Ulan-Ude", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Irkutsk", utcInformation:"UTC+8", isCity: true),
                Location(name: "Yakutsk", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Yakutsk", utcInformation:"UTC+9", isCity: true),
                Location(name: "Vladivostok", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Vladivostok", utcInformation:"UTC+10", isCity: true),
                Location(name: "Magadan", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Magadan", utcInformation:"UTC+11", isCity: true),
                Location(name: "Kamchatka", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Kamchatka", utcInformation:"UTC+12", isCity: true),
                Location(name: "Anadyr", country: "Russia", image:"Russia", timezoneIdentifier: "Asia/Anadyr", utcInformation:"UTC+12", isCity: true),
                Location(name: "Baker Island", country: "USA", image:"United_States", timezoneIdentifier: "Pacific/Kiritimati", utcInformation:"UTC-14", isCity: true),
                Location(name: "Howland Island", country: "USA", image:"United_States", timezoneIdentifier: "Pacific/Kiritimati", utcInformation:"UTC-14", isCity: true),
                Location(name: "American Samoa", country: "USA", image:"United_States", timezoneIdentifier: "Pacific/Pago_Pago", utcInformation:"UTC-11", isCity: true),
                Location(name: "Midway Atoll", country: "USA", image:"United_States", timezoneIdentifier: "Pacific/Midway", utcInformation:"UTC-11", isCity: true),
                Location(name: "Hawaii", country: "USA", image:"United_States", timezoneIdentifier: "Pacific/Honolulu", utcInformation:"UTC-10", isCity: true),
                Location(name: "Anchorage", country: "USA", image:"United_States", timezoneIdentifier: "America/Anchorage", utcInformation:"UTC-9", isCity: true),
                Location(name: "Los Angeles", country: "USA", image:"United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation:"UTC-8", isCity: true),
                Location(name: "San Francisco", country: "USA", image:"United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation:"UTC-8", isCity: true),
                Location(name: "Denver", country: "USA", image:"United_States", timezoneIdentifier: "America/Denver", utcInformation:"UTC-7", isCity: true),
                Location(name: "Phoenix", country: "USA", image:"United_States", timezoneIdentifier: "America/Phoenix", utcInformation:"UTC-7", isCity: true),
                Location(name: "Chicago", country: "USA", image:"United_States", timezoneIdentifier: "America/Chicago", utcInformation:"UTC-6", isCity: true),
                Location(name: "New York", country: "USA", image:"United_States", timezoneIdentifier: "America/New_York", utcInformation:"UTC-5", isCity: true),
                Location(name: "Guam", country: "USA", image:"United_States", timezoneIdentifier: "Pacific/Guam", utcInformation:"UTC+10", isCity: true),
                Location(name: "Wake Island", country: "USA", image:"United_States", timezoneIdentifier: "Pacific/Wake", utcInformation:"UTC+12", isCity: true),
                Location(name: "Polinesia Prancis", country: "France", image:"France", timezoneIdentifier: "Pacific/Tahiti", utcInformation:"UTC-10", isCity: true),
                Location(name: "Kepulauan Marquesas", country: "France", image:"France", timezoneIdentifier: "Pacific/Marquesas", utcInformation:"UTC-9:30", isCity: true),
                Location(name: "Kepulauan Gambier", country: "France", image:"France", timezoneIdentifier: "Pacific/Gambier", utcInformation:"UTC-9", isCity: true),
                Location(name: "Pulau Clipperton", country: "France", image:"France", timezoneIdentifier: "Pacific/Tahiti", utcInformation:"UTC-10", isCity: true),
                Location(name: "Guadeloupe", country: "France", image:"France", timezoneIdentifier: "America/Guadeloupe", utcInformation:"UTC-4", isCity: true),
                Location(name: "Martinique", country: "France", image:"France", timezoneIdentifier: "America/Martinique", utcInformation:"UTC-4", isCity: true),
                Location(name: "Guyana Prancis", country: "France", image:"France", timezoneIdentifier: "America/Cayenne", utcInformation:"UTC-3", isCity: true),
                Location(name: "Saint Pierre dan Miquelon", country: "France", image:"France", timezoneIdentifier: "America/Miquelon", utcInformation:"UTC-3", isCity: true),
                Location(name: "Paris", country: "France", image:"France", timezoneIdentifier: "Europe/Paris", utcInformation:"UTC+1", isCity: true),
                Location(name: "Mayotte", country: "France", image:"France", timezoneIdentifier: "Indian/Mayotte", utcInformation:"UTC+3", isCity: true),
                Location(name: "Réunion", country: "France", image:"France", timezoneIdentifier: "Indian/Reunion", utcInformation:"UTC+4", isCity: true),
                Location(name: "Kepulauan Kerguelen", country: "France", image:"France", timezoneIdentifier: "Indian/Kerguelen", utcInformation:"UTC+5", isCity: true),
                Location(name: "Kaledonia Baru", country: "France", image:"France", timezoneIdentifier: "Pacific/Noumea", utcInformation:"UTC+11", isCity: true),
                Location(name: "Wallis dan Futuna", country: "France", image:"France", timezoneIdentifier: "Pacific/Wallis", utcInformation:"UTC+12", isCity: true),
                Location(name: "Kepulauan Heard dan McDonald", country: "Australia", image:"Australia", timezoneIdentifier: "Indian/Mauritius", utcInformation:"UTC+5", isCity: true),
                Location(name: "Kepulauan Cocos (Keeling)", country: "Australia", image:"Australia", timezoneIdentifier: "Indian/Cocos", utcInformation:"UTC+6:30", isCity: true),
                Location(name: "Pulau Christmas", country: "Australia", image:"Australia", timezoneIdentifier: "Indian/Christmas", utcInformation:"UTC+7", isCity: true),
                Location(name: "Perth", country: "Australia", image:"Australia", timezoneIdentifier: "Australia/Perth", utcInformation:"UTC+8", isCity: true),
                Location(name: "Adelaide", country: "Australia", image:"Australia", timezoneIdentifier: "Australia/Adelaide", utcInformation:"UTC+9:30", isCity: true),
                Location(name: "Darwin", country: "Australia", image:"Australia", timezoneIdentifier: "Australia/Darwin", utcInformation:"UTC+9:30", isCity: true),
                Location(name: "Sydney", country: "Australia", image:"Australia", timezoneIdentifier: "Australia/Sydney", utcInformation:"UTC+10", isCity: true),
                Location(name: "Melbourne", country: "Australia", image:"Australia", timezoneIdentifier: "Australia/Melbourne", utcInformation:"UTC+10", isCity: true),
                Location(name: "Brisbane", country: "Australia", image:"Australia", timezoneIdentifier: "Australia/Brisbane", utcInformation:"UTC+10", isCity: true),
                Location(name: "Pulau Lord Howe", country: "Australia", image:"Australia", timezoneIdentifier: "Australia/Lord_Howe", utcInformation:"UTC+10:30", isCity: true),
                Location(name: "Pulau Norfolk", country: "Australia", image:"Australia", timezoneIdentifier: "Pacific/Norfolk", utcInformation:"UTC+11", isCity: true),
                Location(name: "Vancouver", country: "Canada", image:"Canada", timezoneIdentifier: "America/Vancouver", utcInformation:"UTC-8", isCity: true),
                Location(name: "Edmonton", country: "Canada", image:"Canada", timezoneIdentifier: "America/Edmonton", utcInformation:"UTC-7", isCity: true),
                Location(name: "Winnipeg", country: "Canada", image:"Canada", timezoneIdentifier: "America/Winnipeg", utcInformation:"UTC-6", isCity: true),
                Location(name: "Toronto", country: "Canada", image:"Canada", timezoneIdentifier: "America/Toronto", utcInformation:"UTC-5", isCity: true),
                Location(name: "Halifax", country: "Canada", image:"Canada", timezoneIdentifier: "America/Halifax", utcInformation:"UTC-4", isCity: true),
                Location(name: "St. John's", country: "Canada", image:"Canada", timezoneIdentifier: "America/St_Johns", utcInformation:"UTC-3:30", isCity: true),
                Location(name: "Rio Branco", country: "Brazil", image:"Brazil", timezoneIdentifier: "America/Rio_Branco", utcInformation:"UTC-5", isCity: true),
                Location(name: "Manaus", country: "Brazil", image:"Brazil", timezoneIdentifier: "America/Manaus", utcInformation:"UTC-4", isCity: true),
                Location(name: "Brasilia", country: "Brazil", image:"Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation:"UTC-3", isCity: true),
                Location(name: "Fernando de Noronha", country: "Brazil", image:"Brazil", timezoneIdentifier: "America/Noronha", utcInformation:"UTC-2", isCity: true),
                Location(name: "Jakarta", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation:"UTC+7", isCity: true),
                Location(name: "Bandung", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation:"UTC+7", isCity: true),
                Location(name: "Medan", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation:"UTC+7", isCity: true),
                Location(name: "Denpasar", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Makassar", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Mataram", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Jayapura", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Jayapura", utcInformation:"UTC+9", isCity: true),
                Location(name: "Ambon", country: "Indonesia", image:"Indonesia", timezoneIdentifier: "Asia/Jayapura", utcInformation:"UTC+9", isCity: true),
                Location(name: "Tijuana", country: "Mexico", image:"Mexico", timezoneIdentifier: "America/Tijuana", utcInformation:"UTC-8", isCity: true),
                Location(name: "Chihuahua", country: "Mexico", image:"Mexico", timezoneIdentifier: "America/Chihuahua", utcInformation:"UTC-7", isCity: true),
                Location(name: "Tijuana", country: "Mexico", image:"Mexico", timezoneIdentifier: "America/Tijuana", utcInformation:"UTC-8", isCity: true),
                Location(name: "Hermosillo", country: "Mexico", image:"Mexico", timezoneIdentifier: "America/Hermosillo", utcInformation:"UTC-7", isCity: true),
                Location(name: "Mexico City", country: "Mexico", image:"Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation:"UTC-6", isCity: true),
                Location(name: "Cancún", country: "Mexico", image:"Mexico", timezoneIdentifier: "America/Cancun", utcInformation:"UTC-5", isCity: true),
                Location(name: "Aktobe", country: "Kazakhstan", image:"Kazakhstan", timezoneIdentifier: "Asia/Aqtobe", utcInformation:"UTC+5", isCity: true),
                Location(name: "Atyrau", country: "Kazakhstan", image:"Kazakhstan", timezoneIdentifier: "Asia/Atyrau", utcInformation:"UTC+5", isCity: true),
                Location(name: "Uralsk", country: "Kazakhstan", image:"Kazakhstan", timezoneIdentifier: "Asia/Oral", utcInformation:"UTC+5", isCity: true),
                Location(name: "Nur-Sultan (Astana)", country: "Kazakhstan", image:"Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation:"UTC+6", isCity: true),
                Location(name: "Almaty", country: "Kazakhstan", image:"Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation:"UTC+6", isCity: true),
                Location(name: "Shymkent", country: "Kazakhstan", image:"Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation:"UTC+6", isCity: true),
                Location(name: "Khovd", country: "Mongolia", image:"Mongolia", timezoneIdentifier: "Asia/Hovd", utcInformation:"UTC+7", isCity: true),
                Location(name: "Uvs", country: "Mongolia", image:"Mongolia", timezoneIdentifier: "Asia/Hovd", utcInformation:"UTC+7", isCity: true),
                Location(name: "Bayan-Ölgii", country: "Mongolia", image:"Mongolia", timezoneIdentifier: "Asia/Hovd", utcInformation:"UTC+7", isCity: true),
                Location(name: "Ulaanbaatar", country: "Mongolia", image:"Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Darkhan", country: "Mongolia", image:"Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Erdenet", country: "Mongolia", image:"Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Lisbon", country: "Portugal", image:"Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation:"UTC+0", isCity: true),
                Location(name: "Porto", country: "Portugal", image:"Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation:"UTC+0", isCity: true),
                Location(name: "Braga", country: "Portugal", image:"Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation:"UTC+0", isCity: true),
                Location(name: "Ponta Delgada", country: "Portugal", image:"Portugal", timezoneIdentifier: "Atlantic/Azores", utcInformation:"UTC-1", isCity: true),
                Location(name: "Angra do Heroísmo", country: "Portugal", image:"Portugal", timezoneIdentifier: "Atlantic/Azores", utcInformation:"UTC-1", isCity: true),
                Location(name: "Madrid", country: "Spain", image:"Spain", timezoneIdentifier: "Europe/Madrid", utcInformation:"UTC+1", isCity: true),
                Location(name: "Barcelona", country: "Spain", image:"Spain", timezoneIdentifier: "Europe/Madrid", utcInformation:"UTC+1", isCity: true),
                Location(name: "Valencia", country: "Spain", image:"Spain", timezoneIdentifier: "Europe/Madrid", utcInformation:"UTC+1", isCity: true),
                Location(name: "Las Palmas", country: "Spain", image:"Spain", timezoneIdentifier: "Atlantic/Canary", utcInformation:"UTC+0", isCity: true),
                Location(name: "Santa Cruz de Tenerife", country: "Spain", image:"Spain", timezoneIdentifier: "Atlantic/Canary", utcInformation:"UTC+0", isCity: true),
                Location(name: "Johannesburg", country: "South Africa", image:"South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"UTC+2", isCity: true),
                Location(name: "Cape Town", country: "South Africa", image:"South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"UTC+2", isCity: true),
                Location(name: "Pretoria", country: "South Africa", image:"South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"UTC+2", isCity: true),
                Location(name: "Marion Island", country: "South Africa", image:"South_Africa", timezoneIdentifier: "Indian/Marion", utcInformation:"UTC+2", isCity: true),
                Location(name: "Prince Edward Islands", country: "South Africa", image:"South_Africa", timezoneIdentifier: "Indian/Marion", utcInformation:"UTC+2", isCity: true),
                Location(name: "Santiago", country: "Chile", image:"Chile", timezoneIdentifier: "America/Santiago", utcInformation:"UTC-4", isCity: true),
                Location(name: "Easter Island", country: "Chile", image:"Chile", timezoneIdentifier: "Pacific/Easter", utcInformation:"UTC-6", isCity: true),
                Location(name: "Valparaíso", country: "Chile", image:"Chile", timezoneIdentifier: "America/Santiago", utcInformation:"UTC-4", isCity: true),
                Location(name: "Concepción", country: "Chile", image:"Chile", timezoneIdentifier: "America/Santiago", utcInformation:"UTC-4", isCity: true),
                Location(name: "Magallanes", country: "Chile", image:"Chile", timezoneIdentifier: "America/Punta_Arenas", utcInformation:"UTC-3", isCity: true),
                Location(name: "Kinshasa", country: "DRC", image:"Democratic_Republic_of_Congo", timezoneIdentifier: "Africa/Kinshasa", utcInformation:"UTC+1", isCity: true),
                Location(name: "Lubumbashi", country: "DRC", image:"Democratic_Republic_of_Congo", timezoneIdentifier: "Africa/Lubumbashi", utcInformation:"UTC+2", isCity: true),
                Location(name: "Malé", country: "Maldives", image:"Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation:"UTC+5", isCity: true),
                Location(name: "Resorts & Atolls", country: "Maldives", image:"Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation:"UTC+5", isCity: true),
                
                
                Location(name: "Kazan", country: "Russia", image: "Russia", timezoneIdentifier: "Europe/Moscow", utcInformation: "UTC+3", isCity: true),
                Location(name: "Nizhny Novgorod", country: "Russia", image: "Russia", timezoneIdentifier: "Europe/Moscow", utcInformation: "UTC+3", isCity: true),
                Location(name: "Tyumen", country: "Russia", image: "Russia", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation: "UTC+5", isCity: true),
                Location(name: "Khabarovsk", country: "Russia", image: "Russia", timezoneIdentifier: "Asia/Vladivostok", utcInformation: "UTC+10", isCity: true),
                Location(name: "Seattle", country: "USA", image: "United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation: "UTC-8", isCity: true),
                Location(name: "San Diego", country: "USA", image: "United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation: "UTC-8", isCity: true),
                Location(name: "Salt Lake City", country: "USA", image: "United_States", timezoneIdentifier: "America/Denver", utcInformation: "UTC-7", isCity: true),
                Location(name: "Austin", country: "USA", image: "United_States", timezoneIdentifier: "America/Chicago", utcInformation: "UTC-6", isCity: true),
                Location(name: "Nashville", country: "USA", image: "United_States", timezoneIdentifier: "America/Chicago", utcInformation: "UTC-6", isCity: true),
                Location(name: "Miami", country: "USA", image: "United_States", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: true),
                Location(name: "Boston", country: "USA", image: "United_States", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: true),
                Location(name: "Victoria", country: "Canada", image: "Canada", timezoneIdentifier: "America/Vancouver", utcInformation: "UTC-8", isCity: true),
                Location(name: "Calgary", country: "Canada", image: "Canada", timezoneIdentifier: "America/Edmonton", utcInformation: "UTC-7", isCity: true),
                Location(name: "Charlottetown", country: "Canada", image: "Canada", timezoneIdentifier: "America/Halifax", utcInformation: "UTC-4", isCity: true),
                Location(name: "Rio de Janeiro", country: "Brazil", image: "Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: true),
                Location(name: "Curitiba", country: "Brazil", image: "Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: true),
                Location(name: "Yogyakarta", country: "Indonesia", image: "Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation: "UTC+7", isCity: true),
                Location(name: "Manado", country: "Indonesia", image: "Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Sorong", country: "Indonesia", image: "Indonesia", timezoneIdentifier: "Asia/Jayapura", utcInformation: "UTC+9", isCity: true),
                Location(name: "Ensenada", country: "Mexico", image: "Mexico", timezoneIdentifier: "America/Tijuana", utcInformation: "UTC-8", isCity: true),
                Location(name: "Oaxaca City", country: "Mexico", image: "Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: true),
                Location(name: "Mérida", country: "Mexico", image: "Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: true),
                Location(name: "Karagandy", country: "Kazakhstan", image: "Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation: "UTC+6", isCity: true),
                Location(name: "Erdenet", country: "Mongolia", image: "Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Faro", country: "Portugal", image: "Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
                Location(name: "Coimbra", country: "Portugal", image: "Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
                Location(name: "Seville", country: "Spain", image: "Spain", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: true),
                Location(name: "Bilbao", country: "Spain", image: "Spain", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: true),
                Location(name: "Valdivia", country: "Chile", image: "Chile", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: true),
                Location(name: "La Serena", country: "Chile", image: "Chile", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: true),
                Location(name: "Kisangani", country: "DRC", image: "Democratic_Republic_of_Congo", timezoneIdentifier: "Africa/Kinshasa", utcInformation: "UTC+1", isCity: true),
                Location(name: "Gold Coast", country: "Australia", image: "Australia", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: true),
                Location(name: "Canberra", country: "Australia", image: "Australia", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: true),
                Location(name: "Lyon", country: "France", image: "France", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: true),
                Location(name: "Nice", country: "France", image: "France", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: true),
                Location(name: "Edinburgh", country: "United Kingdom", image: "United_Kingdom", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: true),
                Location(name: "Manchester", country: "United Kingdom", image: "United_Kingdom", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: true),
                Location(name: "Queenstown", country: "New Zealand", image: "New_Zealand", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: true),
                Location(name: "Christchurch", country: "New Zealand", image: "New_Zealand", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: true),
                Location(name: "Durban", country: "South Africa", image: "South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
                Location(name: "Stellenbosch", country: "South Africa", image: "South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
                Location(name: "Maafushi", country: "Maldives", image: "Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation: "UTC+5", isCity: true),
                Location(name: "Tarawa", country: "Kiribati", image: "Kiribati", timezoneIdentifier: "Pacific/Tarawa", utcInformation: "UTC+12", isCity: true),
                Location(name: "Weno", country: "Micronesia", image: "Federated_States_of_Micronesia", timezoneIdentifier: "Pacific/Chuuk", utcInformation: "UTC+10", isCity: true),
                Location(name: "Lae", country: "Papua New Guinea", image: "Papua_New_Guinea", timezoneIdentifier: "Pacific/Port_Moresby", utcInformation: "UTC+10", isCity: true),
                Location(name: "Pokhara", country: "Nepal", image: "Nepal", timezoneIdentifier: "Asia/Kathmandu", utcInformation: "UTC+5:45", isCity: true),
                Location(name: "Herat", country: "Afghanistan", image: "Afghanistan", timezoneIdentifier: "Asia/Kabul", utcInformation: "UTC+4:30", isCity: true),
                Location(name: "Isfahan", country: "Iran", image: "Iran", timezoneIdentifier: "Asia/Tehran", utcInformation: "UTC+3:30", isCity: true),
                Location(name: "Ubud", country: "Indonesia", image: "Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Canggu", country: "Indonesia", image: "Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Chiang Mai", country: "Thailand", image: "Thailand", timezoneIdentifier: "Asia/Bangkok", utcInformation: "UTC+7", isCity: true),
                Location(name: "Medellín", country: "Colombia", image: "Colombia", timezoneIdentifier: "America/Bogota", utcInformation: "UTC-5", isCity: true),
                Location(name: "Lisbon", country: "Portugal", image: "Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
                Location(name: "Tbilisi", country: "Georgia", image: "Georgia", timezoneIdentifier: "Asia/Tbilisi", utcInformation: "UTC+4", isCity: true),
                Location(name: "Budapest", country: "Hungary", image: "Hungary", timezoneIdentifier: "Europe/Budapest", utcInformation: "UTC+1", isCity: true),
                Location(name: "Ho Chi Minh City", country: "Vietnam", image: "Vietnam", timezoneIdentifier: "Asia/Ho_Chi_Minh", utcInformation: "UTC+7", isCity: true),
                Location(name: "Buenos Aires", country: "Argentina", image: "Argentina", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: true),
                Location(name: "Reykjavik", country: "Iceland", image: "Iceland", timezoneIdentifier: "Atlantic/Reykjavik", utcInformation: "UTC+0", isCity: true),
            ]
            
            dummyData.forEach { loc in
                let newEntity = LocationEntity(context: context)
                newEntity.id = loc.id
                newEntity.name = loc.name
                newEntity.country = loc.country
                newEntity.image = loc.image
                newEntity.timezoneIdentifier = loc.timezoneIdentifier
                newEntity.utcInformation = loc.utcInformation
                newEntity.isCity = loc.isCity
                newEntity.isPinned = false
            }
            
            do {
                try context.save()
                print("DEBUG: Dummy locations added.")
            } catch {
                print("Error saving dummy data: \(error)")
            }
        }
    }
    
}
