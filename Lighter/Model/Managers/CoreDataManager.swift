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
    
    private(set) var lights = [CDMLight]()
    private(set) var groups = [CDMLightGroup]()
    
    enum ChangeMethod {
        case post, put, delete
    }
    
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
    
    func persist(light: Light, withMethod method: ChangeMethod){
        switch method{
        case .post:
            let cdm = CDMLight(context: managedObjectContext)
            cdm.peripheralName = light.peripheralName
            cdm.peripheralUUID = light.peripheralUUID
            cdm.registeredName = light.registeredName
            
            cdm.isOn = light.isOn
            cdm.state = light.state.rawValue
            
            cdm.red = Double(light.color?.components.red ?? 1)
            cdm.green = Double(light.color?.components.green ?? 1)
            cdm.blue = Double(light.color?.components.blue ?? 1)
            
            cdm.effect = light.effect?.index ?? 0
            cdm.speed = light.speed ?? 0
            
            appDelegate?.saveContext()
            
        case .put:
            guard let index = self.lights.firstIndex(where: { light.peripheralUUID == $0.peripheralUUID }) else { return }
            
            self.lights[index].registeredName = light.registeredName
            
            self.lights[index].isOn = light.isOn
            self.lights[index].state = light.state.rawValue
            
            self.lights[index].red = Double(light.color?.components.red ?? 1)
            self.lights[index].green = Double(light.color?.components.green ?? 1)
            self.lights[index].blue = Double(light.color?.components.blue ?? 1)
            
            self.lights[index].effect = light.effect?.index ?? 0
            self.lights[index].speed = light.speed ?? 0
            
            appDelegate?.saveContext()
            
        case .delete:
            if let index = self.lights.firstIndex(where: { light.peripheralUUID == $0.peripheralUUID }){
                managedObjectContext.delete(self.lights[index])
                self.lights.remove(at: index)
                
                appDelegate?.saveContext()
            }
        }
    }
    
    func persist(group: LightGroup, withMethod method: ChangeMethod){
        switch method {
        case .post:
            let cdm = CDMLightGroup(context: managedObjectContext)
            cdm.name = group.name
            cdm.uuid = group.UUID
            
            cdm.isOn = group.isOn
            cdm.state = group.state.rawValue
            
            cdm.red = Double(group.color?.components.red ?? 1)
            cdm.green = Double(group.color?.components.green ?? 1)
            cdm.blue = Double(group.color?.components.blue ?? 1)
            
            cdm.effect = group.effect?.index ?? 0
            cdm.speed = group.speed ?? 0
            
            for light in group.lights{
                if let cdmLight = self.lights.first(where: { $0.peripheralUUID == light.peripheralUUID }){
                    cdm.addToLights(cdmLight)
                }
            }
            
            appDelegate?.saveContext()
        case .put:
            guard let index = self.groups.firstIndex(where: { group.UUID == $0.uuid }) else { return }
            
            self.groups[index].name = group.name
            
            self.groups[index].isOn = group.isOn
            self.groups[index].state = group.state.rawValue
            
            self.groups[index].red = Double(group.color?.components.red ?? 1)
            self.groups[index].green = Double(group.color?.components.green ?? 1)
            self.groups[index].blue = Double(group.color?.components.blue ?? 1)
            
            self.groups[index].effect = group.effect?.index ?? 0
            self.groups[index].speed = group.speed ?? 0
            
            self.groups[index].removeFromLights(self.groups[index].lights ?? NSSet())
            for light in group.lights{
                if let cdmLight = self.lights.first(where: { $0.peripheralUUID == light.peripheralUUID }){
                    self.groups[index].addToLights(cdmLight)
                }
            }
            
            appDelegate?.saveContext()
            
        case .delete:
            if let index = self.groups.firstIndex(where: { group.UUID == $0.uuid }) {
                managedObjectContext.delete(self.groups[index])
                self.groups.remove(at: index)
                
                appDelegate?.saveContext()
            }
        }
    }
}
