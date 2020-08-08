//
//  CoreDataManager.swift
//  Lighter
//
//  Created by Devin Green on 8/3/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager: NSObject{
    var managedObjectContext: NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var lights = [CDMLight]()
    var groups = [CDMLightGroup]()
    
    override init() {
        super.init()
        managedObjectContext = appDelegate?.persistentContainer.viewContext
        fetch()
    }
    
    private func fetch(){
        let lightsRequest: NSFetchRequest<CDMLight> = CDMLight.fetchRequest()
        let groupsRequest: NSFetchRequest<CDMLightGroup> = CDMLightGroup.fetchRequest()
        
        lightsRequest.sortDescriptors = [NSSortDescriptor(key: "registeredName", ascending: false)]
        groupsRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        do {
            try lights = managedObjectContext.fetch(lightsRequest)
            try groups = managedObjectContext.fetch(groupsRequest)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func registerLight(light: Light){
        let cdm = CDMLight(context: managedObjectContext)
        cdm.peripheralName = light.peripheralName
        cdm.peripheralUUID = light.peripheralUUID
        cdm.registeredName = light.registeredName
        
        cdm.state = Int16(light.state.rawValue)
        
        cdm.red = Int16(light.color?.redComponent ?? 0)
        cdm.green = Int16(light.color?.greenComponent ?? 0)
        cdm.blue = Int16(light.color?.blueComponent ?? 0)
        
        cdm.effect = Int16(light.effect?.rawValue ?? 0)
        cdm.speed = Int16(light.speed ?? 0)
        
        appDelegate?.saveContext()
        fetch()
    }
    
    func createGroup(group: LightGroup){
        let cdm = CDMLightGroup(context: managedObjectContext)
        cdm.name = group.name
        cdm.uuid = group.UUID
        
        cdm.state = Int16(group.state.rawValue)
        
        cdm.red = Int16(group.color?.redComponent ?? 0)
        cdm.green = Int16(group.color?.greenComponent ?? 0)
        cdm.blue = Int16(group.color?.blueComponent ?? 0)
        
        cdm.effect = Int16(group.effect?.rawValue ?? 0)
        cdm.speed = Int16(group.speed ?? 0)
        
        for light in group.lights{
            if let cdmLight = self.lights.first(where: { $0.peripheralUUID == light.peripheralUUID }){
                cdm.addToLights(cdmLight)
            }
        }
        
        appDelegate?.saveContext()
        fetch()
    }
    
    func updateLight(light: Light){
        if let cdm = self.lights.first(where: { $0.peripheralUUID == light.peripheralUUID }){
            cdm.registeredName = light.registeredName
            
            cdm.state = Int16(light.state.rawValue)
            
            cdm.red = Int16(light.color?.redComponent ?? 0)
            cdm.green = Int16(light.color?.greenComponent ?? 0)
            cdm.blue = Int16(light.color?.blueComponent ?? 0)
            
            cdm.effect = Int16(light.effect?.rawValue ?? 0)
            cdm.speed = Int16(light.speed ?? 0)
            
            appDelegate?.saveContext()
            fetch()
        }
    }
    
    func updateGroup(group: LightGroup){
        if let cdm = self.groups.first(where: { $0.uuid == group.UUID }) {
            cdm.name = group.name
            
            cdm.state = Int16(group.state.rawValue)
            
            cdm.red = Int16(group.color?.redComponent ?? 0)
            cdm.green = Int16(group.color?.greenComponent ?? 0)
            cdm.blue = Int16(group.color?.blueComponent ?? 0)
            
            cdm.effect = Int16(group.effect?.rawValue ?? 0)
            cdm.speed = Int16(group.speed ?? 0)
            
            cdm.removeFromLights(cdm.lights ?? NSSet())
            for light in group.lights{
                if let cdmLight = self.lights.first(where: { $0.peripheralUUID == light.peripheralUUID }){
                    cdm.addToLights(cdmLight)
                }
            }
            
            appDelegate?.saveContext()
            fetch()
        }
    }
    
    func unregisterLight(light: Light) {
        if let cdm = self.lights.first(where: { $0.peripheralUUID == light.peripheralUUID }){
            managedObjectContext.delete(cdm)
            
            appDelegate?.saveContext()
            fetch()
        }
    }
    
    func deleteGroup(group: LightGroup) {
        if let cdm = self.groups.first(where: { $0.uuid == group.UUID }){
            managedObjectContext.delete(cdm)
            
            appDelegate?.saveContext()
            fetch()
        }
    }
}
