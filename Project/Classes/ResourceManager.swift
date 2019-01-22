//
//  ResourceManager.swift
//  Project
//
//  Created by Zeus on 21.01.2019.
//  Copyright © 2019 Zeus. All rights reserved.
//

import Foundation
import UIKit

enum FeedStatement
{
    case notImplement, inProcess, isImplement, isFailed
}

class DataCashItem
{
    var state: FeedStatement
    var data: Data?
    
    init()
    {
        state = .notImplement
        data = nil
    }
    
}

class ResourceManager
{
    var requirementsTable: [CustomTableViewCell : String] = [:] // таблциа требований [ячейка которой надо:что за ресурс ей нужен]
    // при переходе на след. индекс у ячейки меняется url, который ей нужен
    var dataCash : [String : DataCashItem] = [:] // таблица данных [url : данные, которые поступили от этого url]
    // заполняем ячейку по урлу1, т.е добавляем  в рекваирмент тейбл кустом табле вью целл и урл который ей нужен
    // проверяем есть ли  в кэше данных нужная картинка по нашему урлу
    // если уже есть то просто выкидываем картинку в нащ целл
    // если нету то что делаем? нам нужно создать таск, который будет ее загружать
    // а вдруг такой таск уже есть??? тогда надо дополнить dataCash, пусть там будет не только NSData но и еще состояние загрузки этой даты
    //
    
    init()
    {
        requirementsTable = [:]
        dataCash = [:]
    }
    
    func fetchImage(sender: CustomTableViewCell)
    {
        let url = requirementsTable[sender]
        if let url = url
        {
        var dataCashItem = DataCashItem()
        if let itemCashExist = dataCash[url]
        {
           dataCashItem = itemCashExist
        }
            else
        {
           dataCash.updateValue(DataCashItem(), forKey: url)
           dataCashItem = dataCash[url]!
        }
        switch (dataCashItem.state)
        {
        case .notImplement:
            let imageurl = URL(string: url)
            let tsk = URLSession.shared.dataTask(with: imageurl!)
            {
                (data,response,error) -> Void in
                dataCashItem.state = .inProcess
                guard error == nil else {
                    dataCashItem.state = .isFailed
                    return
                }
                if let data = data
                {
                    DispatchQueue.main.async {
                        [weak self] in
                        dataCashItem.data = data
                        dataCashItem.state = .isImplement
                        self?.fetchImage(sender: sender)
                    }
                }
            }
            tsk.resume()
        case .inProcess:
            return
        case .isImplement:
            if let data = dataCashItem.data
            {
                sender.imageCustom!.image = UIImage(data: data)
            }
        case .isFailed:
            // sender'у присваиваем картинку-null
            break
            }
            
        }
    }
    
    func feedImageView(sender: CustomTableViewCell, url: String)
    {
        if url != ""
        {
            requirementsTable.updateValue(url, forKey: sender)
            fetchImage(sender: sender)
        }
        else
        {
            return
        }
    }
    
}
