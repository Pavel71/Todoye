//
//  ViewController.swift
//  Todoye
//
//  Created by PavelM on 22/02/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit
import CoreData

class TodoyeTableViewController: UITableViewController {
    
    
    @IBOutlet var searchBarOutlet: UISearchBar!
    
    @IBOutlet var addItemButton: UIBarButtonItem!
    
    
    
    var categoryItemsString: String!
    
    
    // MARK: - CategoryObject
    var selectedCategory: Category? {
        
        didSet {
            
            categoryItemsString = selectedCategory!.name
            
            loadItems()

            self.navigationItem.title = categoryItemsString
        }
        
    }
    
    // Здесь я попробую сделать через класс
    
    var itemExemplArray = [Item]()

    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        //DELETE
        
//        context.delete(itemExemplArray[indexPath.row])
//        itemExemplArray.remove(at: indexPath.row)
        
        
        // UPDATE значение просто по ключу!
        
//        itemExemplArray[indexPath.row].setValue("Completed", forKey: "value")

        // Не забываем сохранить эти изменения в Plist
        
        saveItem()

        // Снять выбор со строчки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var nameTextField = UITextField()
        
        // при нажате на + Добавим новые данные в таблицу! Используем Алерт Контроллер
        
        let controller = UIAlertController(title: "Добавим в таблицу", message: "Напишите задание", preferredStyle: .alert)
        
        // 2 По нажатию кнопку запускается это замыкание
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in

//            let item = Item()
            let item = Item(context: self.context)
            

            item.value = nameTextField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            
                
            self.itemExemplArray.append(item)
            
            //Сохраним данные в свой Plist
            
            self.saveItem()

        }
        
        // 1 Создается поле в контроллере Название продукта
        controller.addTextField { (controllerTextField) in
            controllerTextField.placeholder = "Название продукта"
            
            // присваиваем локальной переменной ссылк на объект
            nameTextField = controllerTextField
        }

  
        controller.addAction(action)
        
        present(controller,animated: true,completion: nil)
    }
    
    
    //MARK: - SaveData and Load
    
    func saveItem() {
        // Функция принимает данные и добавляет их в свой plist
        
        
        do {
            // преобразовали данные
            try context.save()
  
        } catch {
            
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
//    func loadCategoryItems() {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        if categoryItemsString != "Все продукты" {
//
//            request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryItemsString)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
//
//        } else {
//            // Не даем добавлять товары в режиме все товары
//            addItemButton.isEnabled = false
//        }
//
//        loadItems(with: request)
//    }
    
    
// with request: NSFetchRequest<Item> = Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),with predicate : NSPredicate? = nil) {
        
        var finalPredict = predicate
        
        if categoryItemsString != "Все продукты" {
            
            let categoryPredicat = NSPredicate(format: "parentCategory.name MATCHES %@", categoryItemsString)
            
            finalPredict = categoryPredicat
            
            if let pred = predicate {
                
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicat,pred])
                
                finalPredict = compoundPredicate
            }
            
            
        }
        // если здесь будет nil то будет обычный поиск всех возможных
        request.predicate = finalPredict
        
        do {
       
            itemExemplArray =  try context.fetch(request)
        } catch {
            
            print("Error Fetch in Database \(error)")
        }
        
        self.tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension TodoyeTableViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // если написанна хоть 1 буква
        if searchBar.text!.count > 0 {
            
            let predicate = NSPredicate(format: "value CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
            
            loadItems(with: request, with: predicate)
        }

        
    }
        

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        
        if searchBar.text?.count == 0 {
            
            loadItems()

            DispatchQueue.main.async {
                
                // Убрать клавиатуру
                searchBar.resignFirstResponder()
            }
            
            
        }
            
            
    }
        
        
        
}
    
    

// Plist который сохраняет данные в корне телефона по id приложения
// сохранить и достать данные легко set .array
//    let defaults = UserDefaults.standard


// Создаем свой Plist c данными
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")


// сохранение и загрузка в Plist ///////////



//func saveItem() {
//    // Функция принимает данные и добавляет их в свой plist
//
//    let encoder = PropertyListEncoder()
//
//    do {
//        // преобразовали данные
//        let dataEncode = try encoder.encode(self.itemExemplArray)
//        // Записали по указанному адресу
//        try dataEncode.write(to: dataFilePath!)
//    } catch {
//
//        print(error)
//    }
//
//
//
//}
//
//
//// Загрузим данные из своего Plist
//func loadItems() {
//
//    if let data = try? Data(contentsOf: dataFilePath!) {
//
//        let decoder = PropertyListDecoder()
//        do {
//
//            itemExemplArray = try decoder.decode([Item].self, from: data)
//        } catch {
//
//            print(error)
//        }
//
//
//    }
//
//
//}

