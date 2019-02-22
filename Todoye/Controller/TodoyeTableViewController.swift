//
//  ViewController.swift
//  Todoye
//
//  Created by PavelM on 22/02/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class TodoyeTableViewController: UITableViewController {
    


    var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon","a","b","d","f","g","h","j","q","w","e","r","a","s","9"]
    
    var markerValueSet = Set <String>()
    
    // Plist который сохраняет данные в корне телефона по id приложения
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        markerValueSet = Model().set
        
        // Пусть наш рабочий массив берет самые свежиы данные из Plist core
        
//        if let item  = defaults.array(forKey: "TodoListArray") as? [String] {
//
//            itemArray = item
//
//        }
        
        // так как TableViewController  Delegate Datasorce не надо прописывать
        
    }
    
    
    //MARK: - TableViewDataSource Methods
    
    // Сколько строчек в секторе
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    // Какой тип ячейки отобразить
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let text = itemArray[indexPath.row]
        cell.textLabel?.text = text
        
        // Сделал так чтобы отображалиьс ячейки с выбранными элементами через добавление этих элементов в Set! Но это будет работать только в случае если каждый элемент уникален
        cell.accessoryType = !markerValueSet.contains(text) ? .none : .checkmark
        

        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // Срабатывает когда мы выбираем строку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Поставить марку что выбрали
        
//        let markEnum = tableView.cellForRow(at: indexPath)?.accessoryType
        let labelCellText = tableView.cellForRow(at: indexPath)?.textLabel?.text

 
        if markerValueSet.contains(labelCellText!) {

            markerValueSet.remove(labelCellText!)

        } else {

            markerValueSet.insert(labelCellText!)

        }
        
        // Не нужно проставлять марки так как этот метод запросит обновить перезапуск cellForRowAt
        tableView.reloadData()
        
        
        // это помечает маркеором
//        tableView.cellForRow(at: indexPath)?.accessoryType = markEnum == .checkmark ? .none : .checkmark
        

        
        // Снять выбор со строчки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // при нажате на + Добавим новые данные в таблицу! Используем Алерт Контроллер
        
        let controller = UIAlertController(title: "Добавим в таблицу", message: "Напишите задание", preferredStyle: .alert)
        
        // 2 По нажатию кнопку запускается это замыкание
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            self.itemArray.append(textField.text!)
            
            // Сохраним данные в Plist приложения
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            

        }
        
        // 1 Создается поле в контроллере
        controller.addTextField { (controllerTextField) in
            controllerTextField.placeholder = "Пишите сюда"
            
            // присваиваем локальной переменной ссылк на объект
            textField = controllerTextField
            
        }
        
       
        
        controller.addAction(action)
        
        present(controller,animated: true,completion: nil)
    }
    
}

