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
                Location(name: "Afghanistan", country: "Afghanistan", image: "Flag_of_Afghanistan", timezoneIdentifier: "Asia/Kabul", utcInformation: "UTC+4:30", isCity: false),
                Location(name: "Albania", country: "Albania", image: "Flag_of_Albania", timezoneIdentifier: "Europe/Tirane", utcInformation: "UTC+1", isCity: false),
                Location(name: "Algeria", country: "Algeria", image: "Flag_of_Algeria", timezoneIdentifier: "Africa/Algiers", utcInformation: "UTC+1", isCity: false),
                Location(name: "Andorra", country: "Andorra", image: "Flag_of_Andorra", timezoneIdentifier: "Europe/Andorra", utcInformation: "UTC+1", isCity: false),
                Location(name: "Angola", country: "Angola", image: "Flag_of_Angola", timezoneIdentifier: "Africa/Luanda", utcInformation: "UTC+1", isCity: false),
                Location(name: "Antigua and Barbuda", country: "Antigua and Barbuda", image: "Flag_of_Antigua", timezoneIdentifier: "America/Antigua", utcInformation: "UTC-4", isCity: false),
                Location(name: "Argentina", country: "Argentina", image: "Flag_of_Argentina", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: false),
                Location(name: "Armenia", country: "Armenia", image: "Flag_of_Armenia", timezoneIdentifier: "Asia/Yerevan", utcInformation: "UTC+4", isCity: false),
                Location(name: "Australia", country: "Australia", image: "Flag_of_Australia", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: false),
                Location(name: "Austria", country: "Austria", image: "Flag_of_Austria", timezoneIdentifier: "Europe/Vienna", utcInformation: "UTC+1", isCity: false),
                Location(name: "Azerbaijan", country: "Azerbaijan", image: "Flag_of_Azerbaijan", timezoneIdentifier: "Asia/Baku", utcInformation: "UTC+4", isCity: false),
                Location(name: "Bahamas", country: "Bahamas", image: "Flag_of_Bahamas", timezoneIdentifier: "America/Nassau", utcInformation: "UTC-5", isCity: false),
                Location(name: "Bahrain", country: "Bahrain", image: "Flag_of_Bahrain", timezoneIdentifier: "Asia/Bahrain", utcInformation: "UTC+3", isCity: false),
                Location(name: "Bangladesh", country: "Bangladesh", image: "Flag_of_Bangladesh", timezoneIdentifier: "Asia/Dhaka", utcInformation: "UTC+6", isCity: false),
                Location(name: "Barbados", country: "Barbados", image: "Flag_of_Barbados", timezoneIdentifier: "America/Barbados", utcInformation: "UTC-4", isCity: false),
                Location(name: "Belarus", country: "Belarus", image: "Flag_of_Belarus", timezoneIdentifier: "Europe/Minsk", utcInformation: "UTC+3", isCity: false),
                Location(name: "Belgium", country: "Belgium", image: "Flag_of_Belgium", timezoneIdentifier: "Europe/Brussels", utcInformation: "UTC+1", isCity: false),
                Location(name: "Belize", country: "Belize", image: "Flag_of_Belize", timezoneIdentifier: "America/Belize", utcInformation: "UTC-6", isCity: false),
                Location(name: "Benin", country: "Benin", image: "Flag_of_Benin", timezoneIdentifier: "Africa/Porto-Novo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Bhutan", country: "Bhutan", image: "Flag_of_Bhutan", timezoneIdentifier: "Asia/Thimphu", utcInformation: "UTC+6", isCity: false),
                Location(name: "Bolivia", country: "Bolivia", image: "Flag_of_Bolivia", timezoneIdentifier: "America/La_Paz", utcInformation: "UTC-4", isCity: false),
                Location(name: "Bosnia and Herzegovina", country: "Bosnia and Herzegovina", image: "Flag_of_Bosnia", timezoneIdentifier: "Europe/Sarajevo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Botswana", country: "Botswana", image: "Flag_of_Botswana", timezoneIdentifier: "Africa/Gaborone", utcInformation: "UTC+2", isCity: false),
                Location(name: "Brazil", country: "Brazil", image: "Flag_of_Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: false),
                Location(name: "Brunei", country: "Brunei", image: "Flag_of_Brunei", timezoneIdentifier: "Asia/Brunei", utcInformation: "UTC+8", isCity: false),
                Location(name: "Bulgaria", country: "Bulgaria", image: "Flag_of_Bulgaria", timezoneIdentifier: "Europe/Sofia", utcInformation: "UTC+2", isCity: false),
                Location(name: "Burkina Faso", country: "Burkina Faso", image: "Flag_of_Burkina_Faso", timezoneIdentifier: "Africa/Ouagadougou", utcInformation: "UTC+0", isCity: false),
                Location(name: "Burundi", country: "Burundi", image: "Flag_of_Burundi", timezoneIdentifier: "Africa/Bujumbura", utcInformation: "UTC+2", isCity: false),
                Location(name: "Cabo Verde", country: "Cabo Verde", image: "Flag_of_Cape_Verde", timezoneIdentifier: "Atlantic/Cape_Verde", utcInformation: "UTC-1", isCity: false),
                Location(name: "Cambodia", country: "Cambodia", image: "Flag_of_Cambodia", timezoneIdentifier: "Asia/Phnom_Penh", utcInformation: "UTC+7", isCity: false),
                Location(name: "Cameroon", country: "Cameroon", image: "Flag_of_Cameroon", timezoneIdentifier: "Africa/Douala", utcInformation: "UTC+1", isCity: false),
                Location(name: "Canada", country: "Canada", image: "Flag_of_Canada", timezoneIdentifier: "America/Toronto", utcInformation: "UTC-5", isCity: false),
                Location(name: "Central African Republic", country: "Central African Republic", image: "Flag_of_Central_African_Republic", timezoneIdentifier: "Africa/Bangui", utcInformation: "UTC+1", isCity: false),
                Location(name: "Chad", country: "Chad", image: "Flag_of_Chad", timezoneIdentifier: "Africa/Ndjamena", utcInformation: "UTC+1", isCity: false),
                Location(name: "Chile", country: "Chile", image: "Flag_of_Chile", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: false),
                Location(name: "China", country: "China", image: "Flag_of_China", timezoneIdentifier: "Asia/Shanghai", utcInformation: "UTC+8", isCity: false),
                Location(name: "Colombia", country: "Colombia", image: "Flag_of_colombia", timezoneIdentifier: "America/Bogota", utcInformation: "UTC-5", isCity: false),
                Location(name: "Comoros", country: "Comoros", image: "Flag_of_Comoros", timezoneIdentifier: "Indian/Comoro", utcInformation: "UTC+3", isCity: false),
                Location(name: "Congo (Congo-Brazzaville)", country: "Congo", image: "Flag_of_Congo", timezoneIdentifier: "Africa/Brazzaville", utcInformation: "UTC+1", isCity: false),
                Location(name: "Costa Rica", country: "Costa Rica", image: "Flag_of_Costa_Rica", timezoneIdentifier: "America/Costa_Rica", utcInformation: "UTC-6", isCity: false),
                Location(name: "Croatia", country: "Croatia", image: "Flag_of_Croatia", timezoneIdentifier: "Europe/Zagreb", utcInformation: "UTC+1", isCity: false),
                Location(name: "Cuba", country: "Cuba", image: "Flag_of_Cuba", timezoneIdentifier: "America/Havana", utcInformation: "UTC-5", isCity: false),
                Location(name: "Cyprus", country: "Cyprus", image: "Flag_of_Cyprus", timezoneIdentifier: "Asia/Nicosia", utcInformation: "UTC+2", isCity: false),
                Location(name: "Czech Republic", country: "Czech Republic", image: "Flag_of_Czech_Republic", timezoneIdentifier: "Europe/Prague", utcInformation: "UTC+1", isCity: false),
                Location(name: "Denmark", country: "Denmark", image: "Flag_of_Denmark", timezoneIdentifier: "Europe/Copenhagen", utcInformation: "UTC+1", isCity: false),
                Location(name: "Djibouti", country: "Djibouti", image: "Flag_of_Djibouti", timezoneIdentifier: "Africa/Djibouti", utcInformation: "UTC+3", isCity: false),
                Location(name: "Dominica", country: "Dominica", image: "Flag_of_Dominica", timezoneIdentifier: "America/Dominica", utcInformation: "UTC-4", isCity: false),
                Location(name: "Dominican Republic", country: "Dominican Republic", image: "Flag_of_Dominican_Republic", timezoneIdentifier: "America/Santo_Domingo", utcInformation: "UTC-4", isCity: false),
                Location(name: "East Timor", country: "East Timor", image: "Flag_of_East_Timor", timezoneIdentifier: "Asia/Dili", utcInformation: "UTC+9", isCity: false),
                Location(name: "Ecuador", country: "Ecuador", image: "Flag_of_Ecuador", timezoneIdentifier: "America/Guayaquil", utcInformation: "UTC-5", isCity: false),
                Location(name: "Egypt", country: "Egypt", image: "Flag_of_Egypt", timezoneIdentifier: "Africa/Cairo", utcInformation: "UTC+2", isCity: false),
                Location(name: "El Salvador", country: "El Salvador", image: "Flag_of_El_Salvador", timezoneIdentifier: "America/El_Salvador", utcInformation: "UTC-6", isCity: false),
                Location(name: "Equatorial Guinea", country: "Equatorial Guinea", image: "Flag_of_Equatorial_Guinea", timezoneIdentifier: "Africa/Malabo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Eritrea", country: "Eritrea", image: "Flag_of_Eritrea", timezoneIdentifier: "Africa/Asmara", utcInformation: "UTC+3", isCity: false),
                Location(name: "Estonia", country: "Estonia", image: "Flag_of_Estonia", timezoneIdentifier: "Europe/Tallinn", utcInformation: "UTC+2", isCity: false),
                Location(name: "Eswatini", country: "Eswatini", image: "Flag_of_Eswatini", timezoneIdentifier: "Africa/Mbabane", utcInformation: "UTC+2", isCity: false),
                Location(name: "Ethiopia", country: "Ethiopia", image: "Flag_of_Ethiopia", timezoneIdentifier: "Africa/Addis_Ababa", utcInformation: "UTC+3", isCity: false),
                Location(name: "Fiji", country: "Fiji", image: "Flag_of_Fiji", timezoneIdentifier: "Pacific/Fiji", utcInformation: "UTC+12", isCity: false),
                Location(name: "Finland", country: "Finland", image: "Flag_of_Finland", timezoneIdentifier: "Europe/Helsinki", utcInformation: "UTC+2", isCity: false),
                Location(name: "France", country: "France", image: "Flag_of_France", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: false),
                Location(name: "Gabon", country: "Gabon", image: "Flag_of_Gabon", timezoneIdentifier: "Africa/Libreville", utcInformation: "UTC+1", isCity: false),
                Location(name: "Gambia", country: "Gambia", image: "Flag_of_Gambia", timezoneIdentifier: "Africa/Banjul", utcInformation: "UTC+0", isCity: false),
                Location(name: "Georgia", country: "Georgia", image: "Flag_of_Georgia", timezoneIdentifier: "Asia/Tbilisi", utcInformation: "UTC+4", isCity: false),
                Location(name: "Germany", country: "Germany", image: "Flag_of_Germany", timezoneIdentifier: "Europe/Berlin", utcInformation: "UTC+1", isCity: false),
                Location(name: "Ghana", country: "Ghana", image: "Flag_of_Ghana", timezoneIdentifier: "Africa/Accra", utcInformation: "UTC+0", isCity: false),
                Location(name: "Greece", country: "Greece", image: "Flag_of_Greece", timezoneIdentifier: "Europe/Athens", utcInformation: "UTC+2", isCity: false),
                Location(name: "Grenada", country: "Grenada", image: "Flag_of_Grenada", timezoneIdentifier: "America/Grenada", utcInformation: "UTC-4", isCity: false),
                Location(name: "Guatemala", country: "Guatemala", image: "Flag_of_Guatemala", timezoneIdentifier: "America/Guatemala", utcInformation: "UTC-6", isCity: false),
                Location(name: "Guinea", country: "Guinea", image: "Flag_of_Guinea", timezoneIdentifier: "Africa/Conakry", utcInformation: "UTC+0", isCity: false),
                Location(name: "Guinea-Bissau", country: "Guinea-Bissau", image: "Flag_of_Guinea_Bissau", timezoneIdentifier: "Africa/Bissau", utcInformation: "UTC+0", isCity: false),
                Location(name: "Guyana", country: "Guyana", image: "Flag_of_Guyana", timezoneIdentifier: "America/Guyana", utcInformation: "UTC-4", isCity: false),
                Location(name: "Haiti", country: "Haiti", image: "Flag_of_Haiti", timezoneIdentifier: "America/Port-au-Prince", utcInformation: "UTC-5", isCity: false),
                Location(name: "Honduras", country: "Honduras", image: "Flag_of_Honduras", timezoneIdentifier: "America/Tegucigalpa", utcInformation: "UTC-6", isCity: false),
                Location(name: "Hungary", country: "Hungary", image: "Flag_of_Hungary", timezoneIdentifier: "Europe/Budapest", utcInformation: "UTC+1", isCity: false),
                Location(name: "Iceland", country: "Iceland", image: "Flag_of_Iceland", timezoneIdentifier: "Atlantic/Reykjavik", utcInformation: "UTC+0", isCity: false),
                Location(name: "India", country: "India", image: "Flag_of_India", timezoneIdentifier: "Asia/Kolkata", utcInformation: "UTC+5:30", isCity: false),
                Location(name: "Indonesia", country: "Indonesia", image: "Flag_of_Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation: "UTC+7", isCity: false),
                Location(name: "Iran", country: "Iran", image: "Flag_of_Iran", timezoneIdentifier: "Asia/Tehran", utcInformation: "UTC+3:30", isCity: false),
                Location(name: "Iraq", country: "Iraq", image: "Flag_of_Iraq", timezoneIdentifier: "Asia/Baghdad", utcInformation: "UTC+3", isCity: false),
                Location(name: "Ireland", country: "Ireland", image: "Flag_of_Ireland", timezoneIdentifier: "Europe/Dublin", utcInformation: "UTC+0", isCity: false),
                Location(name: "Israel", country: "Israel", image: "Flag_of_Israel", timezoneIdentifier: "Asia/Jerusalem", utcInformation: "UTC+2", isCity: false),
                Location(name: "Italy", country: "Italy", image: "Flag_of_Italy", timezoneIdentifier: "Europe/Rome", utcInformation: "UTC+1", isCity: false),
                Location(name: "Jamaica", country: "Jamaica", image: "Flag_of_Jamaica", timezoneIdentifier: "America/Jamaica", utcInformation: "UTC-5", isCity: false),
                Location(name: "Japan", country: "Japan", image: "Flag_of_Japan", timezoneIdentifier: "Asia/Tokyo", utcInformation: "UTC+9", isCity: false),
                Location(name: "Jordan", country: "Jordan", image: "Flag_of_Jordan", timezoneIdentifier: "Asia/Amman", utcInformation: "UTC+2", isCity: false),
                Location(name: "Kazakhstan", country: "Kazakhstan", image: "Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation: "UTC+6", isCity: false),
                Location(name: "Kenya", country: "Kenya", image: "Flag_of_Kenya", timezoneIdentifier: "Africa/Nairobi", utcInformation: "UTC+3", isCity: false),
                Location(name: "Kiribati", country: "Kiribati", image: "Flag_of_Kiribati", timezoneIdentifier: "Pacific/Tarawa", utcInformation: "UTC+12", isCity: false),
                Location(name: "Kuwait", country: "Kuwait", image: "Flag_of_Kuwait", timezoneIdentifier: "Asia/Kuwait", utcInformation: "UTC+3", isCity: false),
                Location(name: "Kyrgyzstan", country: "Kyrgyzstan", image: "Flag_of_Kyrgyzstan", timezoneIdentifier: "Asia/Bishkek", utcInformation: "UTC+6", isCity: false),
                Location(name: "Laos", country: "Laos", image: "Flag_of_Laos", timezoneIdentifier: "Asia/Vientiane", utcInformation: "UTC+7", isCity: false),
                Location(name: "Latvia", country: "Latvia", image: "Flag_of_Latvia", timezoneIdentifier: "Europe/Riga", utcInformation: "UTC+2", isCity: false),
                Location(name: "Lebanon", country: "Lebanon", image: "Flag_of_Lebanon", timezoneIdentifier: "Asia/Beirut", utcInformation: "UTC+2", isCity: false),
                Location(name: "Lesotho", country: "Lesotho", image: "Flag_of_Lesotho", timezoneIdentifier: "Africa/Maseru", utcInformation: "UTC+2", isCity: false),
                Location(name: "Liberia", country: "Liberia", image: "Flag_of_Liberia", timezoneIdentifier: "Africa/Monrovia", utcInformation: "UTC+0", isCity: false),
                Location(name: "Libya", country: "Libya", image: "Flag_of_Libya", timezoneIdentifier: "Africa/Tripoli", utcInformation: "UTC+2", isCity: false),
                Location(name: "Liechtenstein", country: "Liechtenstein", image: "Flag_of_Liechtenstein", timezoneIdentifier: "Europe/Vaduz", utcInformation: "UTC+1", isCity: false),
                Location(name: "Lithuania", country: "Lithuania", image: "Flag_of_Lithuania", timezoneIdentifier: "Europe/Vilnius", utcInformation: "UTC+2", isCity: false),
                Location(name: "Luxembourg", country: "Luxembourg", image: "Flag_of_Luxembourg", timezoneIdentifier: "Europe/Luxembourg", utcInformation: "UTC+1", isCity: false),
                Location(name: "Madagascar", country: "Madagascar", image: "Flag_of_Madagascar", timezoneIdentifier: "Indian/Antananarivo", utcInformation: "UTC+3", isCity: false),
                Location(name: "Malawi", country: "Malawi", image: "Flag_of_Malawi", timezoneIdentifier: "Africa/Blantyre", utcInformation: "UTC+2", isCity: false),
                Location(name: "Malaysia", country: "Malaysia", image: "Flag_of_Malaysia", timezoneIdentifier: "Asia/Kuala_Lumpur", utcInformation: "UTC+8", isCity: false),
                Location(name: "Maldives", country: "Maldives", image: "Flag_of_Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation: "UTC+5", isCity: false),
                Location(name: "Mali", country: "Mali", image: "Flag_of_Mali", timezoneIdentifier: "Africa/Bamako", utcInformation: "UTC+0", isCity: false),
                Location(name: "Malta", country: "Malta", image: "Flag_of_Malta", timezoneIdentifier: "Europe/Malta", utcInformation: "UTC+1", isCity: false),
                Location(name: "Marshall Islands", country: "Marshall Islands", image: "Flag_of_Marshall_Islands", timezoneIdentifier: "Pacific/Majuro", utcInformation: "UTC+12", isCity: false),
                Location(name: "Mauritania", country: "Mauritania", image: "Flag_of_Mauritania", timezoneIdentifier: "Africa/Nouakchott", utcInformation: "UTC+0", isCity: false),
                Location(name: "Mauritius", country: "Mauritius", image: "Flag_of_Mauritius", timezoneIdentifier: "Indian/Mauritius", utcInformation: "UTC+4", isCity: false),
                Location(name: "Mexico", country: "Mexico", image: "Flag_of_Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: false),
                Location(name: "Micronesia", country: "Micronesia", image: "Flag_of_Micronesia", timezoneIdentifier: "Pacific/Chuuk", utcInformation: "UTC+10", isCity: false),
                Location(name: "Moldova", country: "Moldova", image: "Flag_of_Moldova", timezoneIdentifier: "Europe/Chisinau", utcInformation: "UTC+2", isCity: false),
                Location(name: "Monaco", country: "Monaco", image: "Flag_of_Monaco", timezoneIdentifier: "Europe/Monaco", utcInformation: "UTC+1", isCity: false),
                Location(name: "Mongolia", country: "Mongolia", image: "Flag_of_Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation: "UTC+8", isCity: false),
                Location(name: "Montenegro", country: "Montenegro", image: "Flag_of_Montenegro", timezoneIdentifier: "Europe/Podgorica", utcInformation: "UTC+1", isCity: false),
                Location(name: "Morocco", country: "Morocco", image: "Flag_of_Morocco", timezoneIdentifier: "Africa/Casablanca", utcInformation: "UTC+1", isCity: false),
                Location(name: "Mozambique", country: "Mozambique", image: "Flag_of_Mozambique", timezoneIdentifier: "Africa/Maputo", utcInformation: "UTC+2", isCity: false),
                Location(name: "Myanmar (Burma)", country: "Myanmar", image: "Flag_of_Myanmar", timezoneIdentifier: "Asia/Yangon", utcInformation: "UTC+6:30", isCity: false),
                Location(name: "Namibia", country: "Namibia", image: "Flag_of_Mamibia", timezoneIdentifier: "Africa/Windhoek", utcInformation: "UTC+2", isCity: false),
                Location(name: "Nauru", country: "Nauru", image: "Flag_of_Nauru", timezoneIdentifier: "Pacific/Nauru", utcInformation: "UTC+12", isCity: false),
                Location(name: "Nepal", country: "Nepal", image: "Flag_of_Nepal", timezoneIdentifier: "Asia/Kathmandu", utcInformation: "UTC+5:45", isCity: false),
                Location(name: "Netherlands", country: "Netherlands", image: "Flag_of_Netherlands", timezoneIdentifier: "Europe/Amsterdam", utcInformation: "UTC+1", isCity: false),
                Location(name: "New Zealand", country: "New Zealand", image: "Flag_of_New_Nealand", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: false),
                Location(name: "Nicaragua", country: "Nicaragua", image: "Flag_of_Nicaragua", timezoneIdentifier: "America/Managua", utcInformation: "UTC-6", isCity: false),
                Location(name: "Niger", country: "Niger", image: "Flag_of_Niger", timezoneIdentifier: "Africa/Niamey", utcInformation: "UTC+1", isCity: false),
                Location(name: "Nigeria", country: "Nigeria", image: "Flag_of_Nigeria", timezoneIdentifier: "Africa/Lagos", utcInformation: "UTC+1", isCity: false),
                Location(name: "North Korea", country: "North Korea", image: "Flag_of_North_Norea", timezoneIdentifier: "Asia/Pyongyang", utcInformation: "UTC+9", isCity: false),
                Location(name: "North Macedonia", country: "North Macedonia", image: "Flag_of_North_Macedonia", timezoneIdentifier: "Europe/Skopje", utcInformation: "UTC+1", isCity: false),
                Location(name: "Norway", country: "Norway", image: "Flag_of_Norway", timezoneIdentifier: "Europe/Oslo", utcInformation: "UTC+1", isCity: false),
                Location(name: "Oman", country: "Oman", image: "Flag_of_Oman", timezoneIdentifier: "Asia/Muscat", utcInformation: "UTC+4", isCity: false),
                Location(name: "Pakistan", country: "Pakistan", image: "Flag_of_Pakistan", timezoneIdentifier: "Asia/Karachi", utcInformation: "UTC+5", isCity: false),
                Location(name: "Palau", country: "Palau", image: "Flag_of_Palau", timezoneIdentifier: "Pacific/Palau", utcInformation: "UTC+9", isCity: false),
                Location(name: "Panama", country: "Panama", image: "Flag_of_Panama", timezoneIdentifier: "America/Panama", utcInformation: "UTC-5", isCity: false),
                Location(name: "Papua New Guinea", country: "Papua New Guinea", image: "Flag_of_Papua_New_Guinea", timezoneIdentifier: "Pacific/Port_Moresby", utcInformation: "UTC+10", isCity: false),
                Location(name: "Paraguay", country: "Paraguay", image: "Flag_of_Paraguay", timezoneIdentifier: "America/Asuncion", utcInformation: "UTC-4", isCity: false),
                Location(name: "Peru", country: "Peru", image: "Flag_of_Peru", timezoneIdentifier: "America/Lima", utcInformation: "UTC-5", isCity: false),
                Location(name: "Philippines", country: "Philippines", image: "Flag_of_Philippines", timezoneIdentifier: "Asia/Manila", utcInformation: "UTC+8", isCity: false),
                Location(name: "Poland", country: "Poland", image: "Flag_of_Poland", timezoneIdentifier: "Europe/Warsaw", utcInformation: "UTC+1", isCity: false),
                Location(name: "Portugal", country: "Portugal", image: "Flag_of_Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: false),
                Location(name: "Qatar", country: "Qatar", image: "Flag_of_Qatar", timezoneIdentifier: "Asia/Qatar", utcInformation: "UTC+3", isCity: false),
                Location(name: "Romania", country: "Romania", image: "Flag_of_Romania", timezoneIdentifier: "Europe/Bucharest", utcInformation: "UTC+2", isCity: false),
                Location(name: "Russia", country: "Russia", image: "Flag_of_Russia", timezoneIdentifier: "Asia/Moscow", utcInformation: "UTC+3", isCity: false),
                Location(name: "Rwanda", country: "Rwanda", image: "Flag_of_Rwanda", timezoneIdentifier: "Africa/Kigali", utcInformation: "UTC+2", isCity: false),
                Location(name: "Saint Kitts and Nevis", country: "Saint Kitts and Nevis", image: "Flag_of_Saint_Kitts", timezoneIdentifier: "America/St_Kitts", utcInformation: "UTC-4", isCity: false),
                Location(name: "Saint Lucia", country: "Saint Lucia", image: "Flag_of_Saint_Lucia", timezoneIdentifier: "America/St_Lucia", utcInformation: "UTC-4", isCity: false),
                Location(name: "Saint Vincent and the Grenadines", country: "Saint Vincent and the Grenadines", image: "Flag_of_Saint_Vincent", timezoneIdentifier: "America/St_Vincent", utcInformation: "UTC-4", isCity: false),
                Location(name: "Samoa", country: "Samoa", image: "Flag_of_Samoa", timezoneIdentifier: "Pacific/Apia", utcInformation: "UTC+13", isCity: false),
                Location(name: "San Marino", country: "San Marino", image: "Flag_of_San_Narino", timezoneIdentifier: "Europe/San_Marino", utcInformation: "UTC+1", isCity: false),
                Location(name: "Sao Tome and Principe", country: "Sao Tome and Principe", image: "Flag_of_Sao_Tome", timezoneIdentifier: "Africa/Sao_Tome", utcInformation: "UTC+0", isCity: false),
                Location(name: "Saudi Arabia", country: "Saudi Arabia", image: "Flag_of_Saudi_Arabia", timezoneIdentifier: "Asia/Riyadh", utcInformation: "UTC+3", isCity: false),
                Location(name: "Senegal", country: "Senegal", image: "Flag_of_Senegal", timezoneIdentifier: "Africa/Dakar", utcInformation: "UTC+0", isCity: false),
                Location(name: "Serbia", country: "Serbia", image: "Flag_of_Serbia", timezoneIdentifier: "Europe/Belgrade", utcInformation: "UTC+1", isCity: false),
                Location(name: "Seychelles", country: "Seychelles", image: "Flag_of_Seychelles", timezoneIdentifier: "Indian/Mahe", utcInformation: "UTC+4", isCity: false),
                Location(name: "Sierra Leone", country: "Sierra Leone", image: "Flag_of_Sierra_Leone", timezoneIdentifier: "Africa/Freetown", utcInformation: "UTC+0", isCity: false),
                Location(name: "Singapore", country: "Singapore", image: "Flag_of_Singapore", timezoneIdentifier: "Asia/Singapore", utcInformation: "UTC+8", isCity: false),
                Location(name: "Slovakia", country: "Slovakia", image: "Flag_of_Slovakia", timezoneIdentifier: "Europe/Bratislava", utcInformation: "UTC+1", isCity: false),
                Location(name: "Slovenia", country: "Slovenia", image: "Flag_of_Slovenia", timezoneIdentifier: "Europe/Ljubljana", utcInformation: "UTC+1", isCity: false),
                Location(name: "Solomon Islands", country: "Solomon Islands", image: "Flag_of_Solomon_Islands", timezoneIdentifier: "Pacific/Guadalcanal", utcInformation: "UTC+11", isCity: false),
                Location(name: "Somalia", country: "Somalia", image: "Flag_of_Somalia", timezoneIdentifier: "Africa/Mogadishu", utcInformation: "UTC+3", isCity: false),
                Location(name: "South Africa", country: "South Africa", image: "Flag_of_South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: false),
                Location(name: "South Sudan", country: "South Sudan", image: "Flag_of_South_Sudan", timezoneIdentifier: "Africa/Juba", utcInformation: "UTC+2", isCity: false),
                Location(name: "Spain", country: "Spain", image: "Flag_of_Spain", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: false),
                Location(name: "Sri Lanka", country: "Sri Lanka", image: "Flag_of_Sri_Lanka", timezoneIdentifier: "Asia/Colombo", utcInformation: "UTC+5:30", isCity: false),
                Location(name: "Sudan", country: "Sudan", image: "Flag_of_Sudan", timezoneIdentifier: "Africa/Khartoum", utcInformation: "UTC+2", isCity: false),
                Location(name: "Suriname", country: "Suriname", image: "Flag_of_Suriname", timezoneIdentifier: "America/Paramaribo", utcInformation: "UTC-3", isCity: false),
                Location(name: "Sweden", country: "Sweden", image: "Flag_of_Sweden", timezoneIdentifier: "Europe/Stockholm", utcInformation: "UTC+1", isCity: false),
                Location(name: "Switzerland", country: "Switzerland", image: "Flag_of_Switzerland", timezoneIdentifier: "Europe/Zurich", utcInformation: "UTC+1", isCity: false),
                Location(name: "Syria", country: "Syria", image: "Flag_of_Syria", timezoneIdentifier: "Asia/Damascus", utcInformation: "UTC+2", isCity: false),
                Location(name: "Taiwan", country: "Taiwan", image: "Flag_of_Taiwan", timezoneIdentifier: "Asia/Taipei", utcInformation: "UTC+8", isCity: false),
                Location(name: "Tajikistan", country: "Tajikistan", image: "Flag_of_Tajikistan", timezoneIdentifier: "Asia/Dushanbe", utcInformation: "UTC+5", isCity: false),
                Location(name: "Tanzania", country: "Tanzania", image: "Flag_of_Tanzania", timezoneIdentifier: "Africa/Dar_es_Salaam", utcInformation: "UTC+3", isCity: false),
                Location(name: "Thailand", country: "Thailand", image: "Flag_of_Thailand", timezoneIdentifier: "Asia/Bangkok", utcInformation: "UTC+7", isCity: false),
                Location(name: "Togo", country: "Togo", image: "Flag_of_Togo", timezoneIdentifier: "Africa/Lome", utcInformation: "UTC+0", isCity: false),
                Location(name: "Tonga", country: "Tonga", image: "Flag_of_Tonga", timezoneIdentifier: "Pacific/Tongatapu", utcInformation: "UTC+13", isCity: false),
                Location(name: "Trinidad and Tobago", country: "Trinidad and Tobago", image: "Flag_of_trinidad_tobago", timezoneIdentifier: "America/Port_of_Spain", utcInformation: "UTC-4", isCity: false),
                Location(name: "Tunisia", country: "Tunisia", image: "Flag_of_Tunisia", timezoneIdentifier: "Africa/Tunis", utcInformation: "UTC+1", isCity: false),
                Location(name: "Turkey", country: "Turkey", image: "Flag_of_Turkey", timezoneIdentifier: "Europe/Istanbul", utcInformation: "UTC+3", isCity: false),
                Location(name: "Turkmenistan", country: "Turkmenistan", image: "Flag_of_Turkmenistan", timezoneIdentifier: "Asia/Ashgabat", utcInformation: "UTC+5", isCity: false),
                Location(name: "Tuvalu", country: "Tuvalu", image: "Flag_of_Tuvalu", timezoneIdentifier: "Pacific/Funafuti", utcInformation: "UTC+12", isCity: false),
                Location(name: "Uganda", country: "Uganda", image: "Flag_of_Uganda", timezoneIdentifier: "Africa/Kampala", utcInformation: "UTC+3", isCity: false),
                Location(name: "Ukraine", country: "Ukraine", image: "Flag_of_Ukraine", timezoneIdentifier: "Europe/Kiev", utcInformation: "UTC+2", isCity: false),
                Location(name: "United Arab Emirates", country: "United Arab Emirates", image: "Flag_of_UAE", timezoneIdentifier: "Asia/Dubai", utcInformation: "UTC+4", isCity: false),
                Location(name: "United Kingdom", country: "United Kingdom", image: "Flag_of_United_Kingdom", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: false),
                Location(name: "United States", country: "USA", image: "Flag_of_Usa", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: false),
                Location(name: "Uruguay", country: "Uruguay", image: "Flag_of_Uruguay", timezoneIdentifier: "America/Montevideo", utcInformation: "UTC-3", isCity: false),
                Location(name: "Uzbekistan", country: "Uzbekistan", image: "Flag_of_Uzbekistan", timezoneIdentifier: "Asia/Tashkent", utcInformation: "UTC+5", isCity: false),
                Location(name: "Vanuatu", country: "Vanuatu", image: "Flag_of_Vanuatu", timezoneIdentifier: "Pacific/Efate", utcInformation: "UTC+11", isCity: false),
                Location(name: "Vatican City", country: "Vatican City", image: "Flag_of_Vatican_City", timezoneIdentifier: "Europe/Vatican", utcInformation: "UTC+1", isCity: false),
                Location(name: "Venezuela", country: "Venezuela", image: "Flag_of_Venezuela", timezoneIdentifier: "America/Caracas", utcInformation: "UTC-4", isCity: false),
                Location(name: "Vietnam", country: "Vietnam", image: "Flag_of_Vietnam", timezoneIdentifier: "Asia/Ho_Chi_Minh", utcInformation: "UTC+7", isCity: false),
                Location(name: "Yemen", country: "Yemen", image: "Flag_of_Yemen", timezoneIdentifier: "Asia/Aden", utcInformation: "UTC+3", isCity: false),
                Location(name: "Zambia", country: "Zambia", image: "Flag_of_Zambia", timezoneIdentifier: "Africa/Lusaka", utcInformation: "UTC+2", isCity: false),
                Location(name: "Zimbabwe", country: "Zimbabwe", image: "Flag_of_Zimbabwe", timezoneIdentifier: "Africa/Harare", utcInformation: "UTC+2", isCity: false),
                
                Location(name: "Kaliningrad", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Europe/Kaliningrad", utcInformation:"UTC+2", isCity: true),
                Location(name: "Moscow", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Europe/Moscow", utcInformation:"UTC+3", isCity: true),
                Location(name: "Saint Petersburg", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Europe/Moscow", utcInformation:"UTC+3", isCity: true),
                Location(name: "Samara", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Europe/Samara", utcInformation:"UTC+4", isCity: true),
                Location(name: "Udmurtia", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Europe/Samara", utcInformation:"UTC+4", isCity: true),
                Location(name: "Yekaterinburg", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation:"UTC+5", isCity: true),
                Location(name: "Chelyabinsk", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation:"UTC+5", isCity: true),
                Location(name: "Omsk", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Omsk", utcInformation:"UTC+6", isCity: true),
                Location(name: "Novosibirsk", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Novosibirsk", utcInformation:"UTC+6", isCity: true),
                Location(name: "Krasnoyarsk", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Krasnoyarsk", utcInformation:"UTC+7", isCity: true),
                Location(name: "Irkutsk", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Irkutsk", utcInformation:"UTC+8", isCity: true),
                Location(name: "Ulan-Ude", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Irkutsk", utcInformation:"UTC+8", isCity: true),
                Location(name: "Yakutsk", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Yakutsk", utcInformation:"UTC+9", isCity: true),
                Location(name: "Vladivostok", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Vladivostok", utcInformation:"UTC+10", isCity: true),
                Location(name: "Magadan", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Magadan", utcInformation:"UTC+11", isCity: true),
                Location(name: "Kamchatka", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Kamchatka", utcInformation:"UTC+12", isCity: true),
                Location(name: "Anadyr", country: "Russia", image:"Flag_of_Russia", timezoneIdentifier: "Asia/Anadyr", utcInformation:"UTC+12", isCity: true),
                Location(name: "Baker Island", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "Pacific/Kiritimati", utcInformation:"UTC-14", isCity: true),
                Location(name: "Howland Island", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "Pacific/Kiritimati", utcInformation:"UTC-14", isCity: true),
                Location(name: "American Samoa", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "Pacific/Pago_Pago", utcInformation:"UTC-11", isCity: true),
                Location(name: "Midway Atoll", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "Pacific/Midway", utcInformation:"UTC-11", isCity: true),
                Location(name: "Hawaii", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "Pacific/Honolulu", utcInformation:"UTC-10", isCity: true),
                Location(name: "Anchorage", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "America/Anchorage", utcInformation:"UTC-9", isCity: true),
                Location(name: "Los Angeles", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation:"UTC-8", isCity: true),
                Location(name: "San Francisco", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation:"UTC-8", isCity: true),
                Location(name: "Denver", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "America/Denver", utcInformation:"UTC-7", isCity: true),
                Location(name: "Phoenix", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "America/Phoenix", utcInformation:"UTC-7", isCity: true),
                Location(name: "Chicago", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "America/Chicago", utcInformation:"UTC-6", isCity: true),
                Location(name: "New York", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "America/New_York", utcInformation:"UTC-5", isCity: true),
                Location(name: "Guam", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "Pacific/Guam", utcInformation:"UTC+10", isCity: true),
                Location(name: "Wake Island", country: "USA", image:"Flag_of_United_States", timezoneIdentifier: "Pacific/Wake", utcInformation:"UTC+12", isCity: true),
                Location(name: "Polinesia Prancis", country: "France", image:"Flag_of_France", timezoneIdentifier: "Pacific/Tahiti", utcInformation:"UTC-10", isCity: true),
                Location(name: "Kepulauan Marquesas", country: "France", image:"Flag_of_France", timezoneIdentifier: "Pacific/Marquesas", utcInformation:"UTC-9:30", isCity: true),
                Location(name: "Kepulauan Gambier", country: "France", image:"Flag_of_France", timezoneIdentifier: "Pacific/Gambier", utcInformation:"UTC-9", isCity: true),
                Location(name: "Pulau Clipperton", country: "France", image:"Flag_of_France", timezoneIdentifier: "Pacific/Tahiti", utcInformation:"UTC-10", isCity: true),
                Location(name: "Guadeloupe", country: "France", image:"Flag_of_France", timezoneIdentifier: "America/Guadeloupe", utcInformation:"UTC-4", isCity: true),
                Location(name: "Martinique", country: "France", image:"Flag_of_France", timezoneIdentifier: "America/Martinique", utcInformation:"UTC-4", isCity: true),
                Location(name: "Guyana Prancis", country: "France", image:"Flag_of_France", timezoneIdentifier: "America/Cayenne", utcInformation:"UTC-3", isCity: true),
                Location(name: "Saint Pierre dan Miquelon", country: "France", image:"Flag_of_France", timezoneIdentifier: "America/Miquelon", utcInformation:"UTC-3", isCity: true),
                Location(name: "Paris", country: "France", image:"Flag_of_France", timezoneIdentifier: "Europe/Paris", utcInformation:"UTC+1", isCity: true),
                Location(name: "Mayotte", country: "France", image:"Flag_of_France", timezoneIdentifier: "Indian/Mayotte", utcInformation:"UTC+3", isCity: true),
                Location(name: "Réunion", country: "France", image:"Flag_of_France", timezoneIdentifier: "Indian/Reunion", utcInformation:"UTC+4", isCity: true),
                Location(name: "Kepulauan Kerguelen", country: "France", image:"Flag_of_France", timezoneIdentifier: "Indian/Kerguelen", utcInformation:"UTC+5", isCity: true),
                Location(name: "Kaledonia Baru", country: "France", image:"Flag_of_France", timezoneIdentifier: "Pacific/Noumea", utcInformation:"UTC+11", isCity: true),
                Location(name: "Wallis dan Futuna", country: "France", image:"Flag_of_France", timezoneIdentifier: "Pacific/Wallis", utcInformation:"UTC+12", isCity: true),
                Location(name: "Kepulauan Heard dan McDonald", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Indian/Mauritius", utcInformation:"UTC+5", isCity: true),
                Location(name: "Kepulauan Cocos (Keeling)", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Indian/Cocos", utcInformation:"UTC+6:30", isCity: true),
                Location(name: "Pulau Christmas", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Indian/Christmas", utcInformation:"UTC+7", isCity: true),
                Location(name: "Perth", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Australia/Perth", utcInformation:"UTC+8", isCity: true),
                Location(name: "Adelaide", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Australia/Adelaide", utcInformation:"UTC+9:30", isCity: true),
                Location(name: "Darwin", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Australia/Darwin", utcInformation:"UTC+9:30", isCity: true),
                Location(name: "Sydney", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Australia/Sydney", utcInformation:"UTC+10", isCity: true),
                Location(name: "Melbourne", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Australia/Melbourne", utcInformation:"UTC+10", isCity: true),
                Location(name: "Brisbane", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Australia/Brisbane", utcInformation:"UTC+10", isCity: true),
                Location(name: "Pulau Lord Howe", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Australia/Lord_Howe", utcInformation:"UTC+10:30", isCity: true),
                Location(name: "Pulau Norfolk", country: "Australia", image:"Flag_of_Australia", timezoneIdentifier: "Pacific/Norfolk", utcInformation:"UTC+11", isCity: true),
                Location(name: "Vancouver", country: "Canada", image:"Flag_of_Canada", timezoneIdentifier: "America/Vancouver", utcInformation:"UTC-8", isCity: true),
                Location(name: "Edmonton", country: "Canada", image:"Flag_of_Canada", timezoneIdentifier: "America/Edmonton", utcInformation:"UTC-7", isCity: true),
                Location(name: "Winnipeg", country: "Canada", image:"Flag_of_Canada", timezoneIdentifier: "America/Winnipeg", utcInformation:"UTC-6", isCity: true),
                Location(name: "Toronto", country: "Canada", image:"Flag_of_Canada", timezoneIdentifier: "America/Toronto", utcInformation:"UTC-5", isCity: true),
                Location(name: "Halifax", country: "Canada", image:"Flag_of_Canada", timezoneIdentifier: "America/Halifax", utcInformation:"UTC-4", isCity: true),
                Location(name: "St. John's", country: "Canada", image:"Flag_of_Canada", timezoneIdentifier: "America/St_Johns", utcInformation:"UTC-3:30", isCity: true),
                Location(name: "Rio Branco", country: "Brazil", image:"Flag_of_Brazil", timezoneIdentifier: "America/Rio_Branco", utcInformation:"UTC-5", isCity: true),
                Location(name: "Manaus", country: "Brazil", image:"Flag_of_Brazil", timezoneIdentifier: "America/Manaus", utcInformation:"UTC-4", isCity: true),
                Location(name: "Brasilia", country: "Brazil", image:"Flag_of_Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation:"UTC-3", isCity: true),
                Location(name: "Fernando de Noronha", country: "Brazil", image:"Flag_of_Brazil", timezoneIdentifier: "America/Noronha", utcInformation:"UTC-2", isCity: true),
                Location(name: "Jakarta", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation:"UTC+7", isCity: true),
                Location(name: "Bandung", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation:"UTC+7", isCity: true),
                Location(name: "Medan", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation:"UTC+7", isCity: true),
                Location(name: "Denpasar", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Makassar", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Mataram", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Jayapura", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Jayapura", utcInformation:"UTC+9", isCity: true),
                Location(name: "Ambon", country: "Indonesia", image:"Flag_of_Indonesia", timezoneIdentifier: "Asia/Jayapura", utcInformation:"UTC+9", isCity: true),
                Location(name: "Tijuana", country: "Mexico", image:"Flag_of_Mexico", timezoneIdentifier: "America/Tijuana", utcInformation:"UTC-8", isCity: true),
                Location(name: "Chihuahua", country: "Mexico", image:"Flag_of_Mexico", timezoneIdentifier: "America/Chihuahua", utcInformation:"UTC-7", isCity: true),
                Location(name: "Tijuana", country: "Mexico", image:"Flag_of_Mexico", timezoneIdentifier: "America/Tijuana", utcInformation:"UTC-8", isCity: true),
                Location(name: "Hermosillo", country: "Mexico", image:"Flag_of_Mexico", timezoneIdentifier: "America/Hermosillo", utcInformation:"UTC-7", isCity: true),
                Location(name: "Mexico City", country: "Mexico", image:"Flag_of_Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation:"UTC-6", isCity: true),
                Location(name: "Cancún", country: "Mexico", image:"Flag_of_Mexico", timezoneIdentifier: "America/Cancun", utcInformation:"UTC-5", isCity: true),
                Location(name: "Aktobe", country: "Kazakhstan", image:"Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Aqtobe", utcInformation:"UTC+5", isCity: true),
                Location(name: "Atyrau", country: "Kazakhstan", image:"Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Atyrau", utcInformation:"UTC+5", isCity: true),
                Location(name: "Uralsk", country: "Kazakhstan", image:"Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Oral", utcInformation:"UTC+5", isCity: true),
                Location(name: "Nur-Sultan (Astana)", country: "Kazakhstan", image:"Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation:"UTC+6", isCity: true),
                Location(name: "Almaty", country: "Kazakhstan", image:"Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation:"UTC+6", isCity: true),
                Location(name: "Shymkent", country: "Kazakhstan", image:"Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation:"UTC+6", isCity: true),
                Location(name: "Khovd", country: "Mongolia", image:"Flag_of_Mongolia", timezoneIdentifier: "Asia/Hovd", utcInformation:"UTC+7", isCity: true),
                Location(name: "Uvs", country: "Mongolia", image:"Flag_of_Mongolia", timezoneIdentifier: "Asia/Hovd", utcInformation:"UTC+7", isCity: true),
                Location(name: "Bayan-Ölgii", country: "Mongolia", image:"Flag_of_Mongolia", timezoneIdentifier: "Asia/Hovd", utcInformation:"UTC+7", isCity: true),
                Location(name: "Ulaanbaatar", country: "Mongolia", image:"Flag_of_Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Darkhan", country: "Mongolia", image:"Flag_of_Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Erdenet", country: "Mongolia", image:"Flag_of_Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"UTC+8", isCity: true),
                Location(name: "Lisbon", country: "Portugal", image:"Flag_of_Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation:"UTC+0", isCity: true),
                Location(name: "Porto", country: "Portugal", image:"Flag_of_Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation:"UTC+0", isCity: true),
                Location(name: "Braga", country: "Portugal", image:"Flag_of_Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation:"UTC+0", isCity: true),
                Location(name: "Ponta Delgada", country: "Portugal", image:"Flag_of_Portugal", timezoneIdentifier: "Atlantic/Azores", utcInformation:"UTC-1", isCity: true),
                Location(name: "Angra do Heroísmo", country: "Portugal", image:"Flag_of_Portugal", timezoneIdentifier: "Atlantic/Azores", utcInformation:"UTC-1", isCity: true),
                Location(name: "Madrid", country: "Spain", image:"Flag_of_Spain", timezoneIdentifier: "Europe/Madrid", utcInformation:"UTC+1", isCity: true),
                Location(name: "Barcelona", country: "Spain", image:"Flag_of_Spain", timezoneIdentifier: "Europe/Madrid", utcInformation:"UTC+1", isCity: true),
                Location(name: "Valencia", country: "Spain", image:"Flag_of_Spain", timezoneIdentifier: "Europe/Madrid", utcInformation:"UTC+1", isCity: true),
                Location(name: "Las Palmas", country: "Spain", image:"Flag_of_Spain", timezoneIdentifier: "Atlantic/Canary", utcInformation:"UTC+0", isCity: true),
                Location(name: "Santa Cruz de Tenerife", country: "Spain", image:"Flag_of_Spain", timezoneIdentifier: "Atlantic/Canary", utcInformation:"UTC+0", isCity: true),
                Location(name: "Johannesburg", country: "South Africa", image:"Flag_of_South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"UTC+2", isCity: true),
                Location(name: "Cape Town", country: "South Africa", image:"Flag_of_South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"UTC+2", isCity: true),
                Location(name: "Pretoria", country: "South Africa", image:"Flag_of_South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"UTC+2", isCity: true),
                Location(name: "Marion Island", country: "South Africa", image:"Flag_of_South_Africa", timezoneIdentifier: "Indian/Marion", utcInformation:"UTC+2", isCity: true),
                Location(name: "Prince Edward Islands", country: "South Africa", image:"Flag_of_South_Africa", timezoneIdentifier: "Indian/Marion", utcInformation:"UTC+2", isCity: true),
                Location(name: "Santiago", country: "Chile", image:"Flag_of_Chile", timezoneIdentifier: "America/Santiago", utcInformation:"UTC-4", isCity: true),
                Location(name: "Easter Island", country: "Chile", image:"Flag_of_Chile", timezoneIdentifier: "Pacific/Easter", utcInformation:"UTC-6", isCity: true),
                Location(name: "Valparaíso", country: "Chile", image:"Flag_of_Chile", timezoneIdentifier: "America/Santiago", utcInformation:"UTC-4", isCity: true),
                Location(name: "Concepción", country: "Chile", image:"Flag_of_Chile", timezoneIdentifier: "America/Santiago", utcInformation:"UTC-4", isCity: true),
                Location(name: "Magallanes", country: "Chile", image:"Flag_of_Chile", timezoneIdentifier: "America/Punta_Arenas", utcInformation:"UTC-3", isCity: true),
                Location(name: "Kinshasa", country: "DRC", image:"Flag_of_Flag_of_Democratic_Republic_of_Congo", timezoneIdentifier: "Africa/Kinshasa", utcInformation:"UTC+1", isCity: true),
                Location(name: "Lubumbashi", country: "DRC", image:"Flag_of_Flag_of_Democratic_Republic_of_Congo", timezoneIdentifier: "Africa/Lubumbashi", utcInformation:"UTC+2", isCity: true),
                Location(name: "Nuuk", country: "Greenland", image:"Flag_of_Greenland", timezoneIdentifier: "America/Godthab", utcInformation:"UTC-3", isCity: true),
                Location(name: "Danmarkshavn", country: "Greenland", image:"Flag_of_Greenland", timezoneIdentifier: "America/Danmarkshavn", utcInformation:"UTC+0", isCity: true),
                Location(name: "Pituffik", country: "Greenland", image:"Flag_of_Greenland", timezoneIdentifier: "America/Thule", utcInformation:"UTC-4", isCity: true),
                Location(name: "Malé", country: "Maldives", image:"Flag_of_Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation:"UTC+5", isCity: true),
                Location(name: "Resorts & Atolls", country: "Maldives", image:"Flag_of_Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation:"UTC+5", isCity: true),
                
                
                Location(name: "Kazan", country: "Russia", image: "Flag_of_Russia", timezoneIdentifier: "Europe/Moscow", utcInformation: "UTC+3", isCity: true),
                Location(name: "Nizhny Novgorod", country: "Russia", image: "Flag_of_Russia", timezoneIdentifier: "Europe/Moscow", utcInformation: "UTC+3", isCity: true),
                Location(name: "Tyumen", country: "Russia", image: "Flag_of_Russia", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation: "UTC+5", isCity: true),
                Location(name: "Khabarovsk", country: "Russia", image: "Flag_of_Russia", timezoneIdentifier: "Asia/Vladivostok", utcInformation: "UTC+10", isCity: true),
                Location(name: "Seattle", country: "USA", image: "Flag_of_United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation: "UTC-8", isCity: true),
                Location(name: "San Diego", country: "USA", image: "Flag_of_United_States", timezoneIdentifier: "America/Los_Angeles", utcInformation: "UTC-8", isCity: true),
                Location(name: "Salt Lake City", country: "USA", image: "Flag_of_United_States", timezoneIdentifier: "America/Denver", utcInformation: "UTC-7", isCity: true),
                Location(name: "Austin", country: "USA", image: "Flag_of_United_States", timezoneIdentifier: "America/Chicago", utcInformation: "UTC-6", isCity: true),
                Location(name: "Nashville", country: "USA", image: "Flag_of_United_States", timezoneIdentifier: "America/Chicago", utcInformation: "UTC-6", isCity: true),
                Location(name: "Miami", country: "USA", image: "Flag_of_United_States", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: true),
                Location(name: "Boston", country: "USA", image: "Flag_of_United_States", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: true),
                Location(name: "Victoria", country: "Canada", image: "Flag_of_Canada", timezoneIdentifier: "America/Vancouver", utcInformation: "UTC-8", isCity: true),
                Location(name: "Calgary", country: "Canada", image: "Flag_of_Canada", timezoneIdentifier: "America/Edmonton", utcInformation: "UTC-7", isCity: true),
                Location(name: "Charlottetown", country: "Canada", image: "Flag_of_Canada", timezoneIdentifier: "America/Halifax", utcInformation: "UTC-4", isCity: true),
                Location(name: "Rio de Janeiro", country: "Brazil", image: "Flag_of_Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: true),
                Location(name: "Curitiba", country: "Brazil", image: "Flag_of_Brazil", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: true),
                Location(name: "Yogyakarta", country: "Indonesia", image: "Flag_of_Indonesia", timezoneIdentifier: "Asia/Jakarta", utcInformation: "UTC+7", isCity: true),
                Location(name: "Manado", country: "Indonesia", image: "Flag_of_Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Sorong", country: "Indonesia", image: "Flag_of_Indonesia", timezoneIdentifier: "Asia/Jayapura", utcInformation: "UTC+9", isCity: true),
                Location(name: "Ensenada", country: "Mexico", image: "Flag_of_Mexico", timezoneIdentifier: "America/Tijuana", utcInformation: "UTC-8", isCity: true),
                Location(name: "Oaxaca City", country: "Mexico", image: "Flag_of_Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: true),
                Location(name: "Mérida", country: "Mexico", image: "Flag_of_Mexico", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: true),
                Location(name: "Karagandy", country: "Kazakhstan", image: "Flag_of_Kazakhstan", timezoneIdentifier: "Asia/Almaty", utcInformation: "UTC+6", isCity: true),
                Location(name: "Erdenet", country: "Mongolia", image: "Flag_of_Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Faro", country: "Portugal", image: "Flag_of_Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
                Location(name: "Coimbra", country: "Portugal", image: "Flag_of_Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
                Location(name: "Seville", country: "Spain", image: "Flag_of_Spain", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: true),
                Location(name: "Bilbao", country: "Spain", image: "Flag_of_Spain", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: true),
                Location(name: "Valdivia", country: "Chile", image: "Flag_of_Chile", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: true),
                Location(name: "La Serena", country: "Chile", image: "Flag_of_Chile", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: true),
                Location(name: "Ilulissat", country: "Greenland", image: "Flag_of_Greenland", timezoneIdentifier: "America/Godthab", utcInformation: "UTC-3", isCity: true),
                Location(name: "Kisangani", country: "DRC", image: "Flag_of_Flag_of_Democratic_Republic_of_Congo", timezoneIdentifier: "Africa/Kinshasa", utcInformation: "UTC+1", isCity: true),
                Location(name: "Gold Coast", country: "Australia", image: "Flag_of_Australia", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: true),
                Location(name: "Canberra", country: "Australia", image: "Flag_of_Australia", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: true),
                Location(name: "Lyon", country: "France", image: "Flag_of_France", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: true),
                Location(name: "Nice", country: "France", image: "Flag_of_France", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: true),
                Location(name: "Edinburgh", country: "United Kingdom", image: "Flag_of_United_Kingdom", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: true),
                Location(name: "Manchester", country: "United Kingdom", image: "Flag_of_United_Kingdom", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: true),
                Location(name: "Queenstown", country: "New Zealand", image: "Flag_of_New_Zealand", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: true),
                Location(name: "Christchurch", country: "New Zealand", image: "Flag_of_New_Zealand", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: true),
                Location(name: "Durban", country: "South Africa", image: "Flag_of_South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
                Location(name: "Stellenbosch", country: "South Africa", image: "Flag_of_South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
                Location(name: "Maafushi", country: "Maldives", image: "Flag_of_Maldives", timezoneIdentifier: "Indian/Maldives", utcInformation: "UTC+5", isCity: true),
                Location(name: "Tarawa", country: "Kiribati", image: "Flag_of_Kiribati", timezoneIdentifier: "Pacific/Tarawa", utcInformation: "UTC+12", isCity: true),
                Location(name: "Weno", country: "Micronesia", image: "Flag_of_Micronesia", timezoneIdentifier: "Pacific/Chuuk", utcInformation: "UTC+10", isCity: true),
                Location(name: "Lae", country: "Papua New Guinea", image: "Flag_of_Papua_New_Guinea", timezoneIdentifier: "Pacific/Port_Moresby", utcInformation: "UTC+10", isCity: true),
                Location(name: "Pokhara", country: "Nepal", image: "Flag_of_Nepal", timezoneIdentifier: "Asia/Kathmandu", utcInformation: "UTC+5:45", isCity: true),
                Location(name: "Herat", country: "Afghanistan", image: "Flag_of_Afghanistan", timezoneIdentifier: "Asia/Kabul", utcInformation: "UTC+4:30", isCity: true),
                Location(name: "Isfahan", country: "Iran", image: "Flag_of_Iran", timezoneIdentifier: "Asia/Tehran", utcInformation: "UTC+3:30", isCity: true),
                Location(name: "Ubud", country: "Indonesia", image: "Flag_of_Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Canggu", country: "Indonesia", image: "Flag_of_Indonesia", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
                Location(name: "Chiang Mai", country: "Thailand", image: "Flag_of_Thailand", timezoneIdentifier: "Asia/Bangkok", utcInformation: "UTC+7", isCity: true),
                Location(name: "Medellín", country: "Colombia", image: "Flag_of_Colombia", timezoneIdentifier: "America/Bogota", utcInformation: "UTC-5", isCity: true),
                Location(name: "Lisbon", country: "Portugal", image: "Flag_of_Portugal", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
                Location(name: "Tbilisi", country: "Georgia", image: "Flag_of_Georgia", timezoneIdentifier: "Asia/Tbilisi", utcInformation: "UTC+4", isCity: true),
                Location(name: "Budapest", country: "Hungary", image: "Flag_of_Hungary", timezoneIdentifier: "Europe/Budapest", utcInformation: "UTC+1", isCity: true),
                Location(name: "Ho Chi Minh City", country: "Vietnam", image: "Flag_of_Vietnam", timezoneIdentifier: "Asia/Ho_Chi_Minh", utcInformation: "UTC+7", isCity: true),
                Location(name: "Buenos Aires", country: "Argentina", image: "Flag_of_Argentina", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: true),
                Location(name: "Cape Town", country: "South Africa", image: "Flag_of_South_Africa", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
                Location(name: "Reykjavik", country: "Iceland", image: "Flag_of_Iceland", timezoneIdentifier: "Atlantic/Reykjavik", utcInformation: "UTC+0", isCity: true),
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
