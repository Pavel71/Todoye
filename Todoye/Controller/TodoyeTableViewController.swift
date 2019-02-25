//
//  ViewController.swift
//  Todoye
//
//  Created by PavelM on 22/02/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class TodoyeTableViewController: UITableViewController {
    

    var itemArray = ["Find Mike", "Buy Eggos", "Destory"]
    
    // Здесь я попробую сделать через класс
    
    var itemExemplArray = [Item]()
    
    // ["Find Mike", "Buy Eggos", "Destory Demogorgon","a","b","d","f","g","h","j","q","w","e","r","a","s","9"]
    

    
    // Plist который сохраняет данные в корне телефона по id приложения
    let defaults = UserDefaults.standard
    
    
    // Создаем свой Plist c данными
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
        
        // Загрузка данных из собственного Plist
        
        
        
        
        

        

        
        // так как TableViewController  Delegate Datasorce не надо прописывать
        
    }
    
    // Загрузим данные из своего Plist
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do {
                
                itemExemplArray = try decoder.decode([Item].self, from: data)
            } catch {
                
                print(error)
            }
            
 
        }


    }
    
    func loadDataUserDeafaults () {
        
        
            if let item  = defaults.array(forKey: "TodoListArray") as? [String] {
    
                itemArray = item
    
            }
    }
    
  
    
    //MARK: - TableViewDataSource Methods
    
    // Сколько строчек в секторе
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return itemExemplArray.count
    }
    
    // Какой тип ячейки отобразить
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        let text = itemExemplArray[indexPath.row].value
        
        cell.textLabel?.text = text
        
        // Сделал так чтобы отображалиьс ячейки с выбранными элементами через добавление этих элементов в Set! Но это будет работать только в случае если каждый элемент уникален

        
        cell.accessoryType = itemExemplArray[indexPath.row].done ? .checkmark : .none
        

        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // Срабатывает когда мы выбираем строку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Поставить марку что выбрали переключаем флаг
        itemExemplArray[indexPath.row].done = !itemExemplArray[indexPath.row].done
        
        // Не забываем сохранить эти изменения в Plist
        
        saveItem()
        
        
        // Не нужно проставлять марки так как этот метод запросит обновить перезапуск cellForRowAt
        tableView.reloadData()

        
        // Снять выбор со строчки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // при нажате на + Добавим новые данные в таблицу! Используем Алерт Контроллер
        
        let controller = UIAlertController(title: "Добавим в таблицу", message: "Напишите задание", preferredStyle: .alert)
        
        // 2 По нажатию кнопку запускается это замыкание
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            let item = Item()
            item.value = textField.text!
            
                
            self.itemExemplArray.append(item)
            
            //Сохраним данные в свой Plist
            
            self.saveItem()
            
            
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
    
    
    //MARK: - EncodeData
    
    func saveItem() {
        // Функция принимает данные и добавляет их в свой plist
        
        let encoder = PropertyListEncoder()
        
        do {
            // преобразовали данные
            let dataEncode = try encoder.encode(self.itemExemplArray)
            // Записали по указанному адресу
            try dataEncode.write(to: dataFilePath!)
        } catch {
            
            print(error)
        }
        
        
        
    }
    
}

