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
    
    // Хочу записать сюда запрос из Категориального viewControllera чтобы при переходе загружать сюда теп продукты которые относятся к этой категории
    var request: NSFetchRequest<Item>!
    var categoryItemsString: String!
    
    // Здесь я попробую сделать через класс
    
    var itemExemplArray = [Item]()

    // Plist который сохраняет данные в корне телефона по id приложения
    // сохранить и достать данные легко set .array
//    let defaults = UserDefaults.standard
    
    
    // Создаем свой Plist c данными
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    
    
    
    // Создадим контекст для Core Data тот самый который в AppDelegate
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = categoryItemsString
        
        
        // Если пользоватся навигатором то он хочет зарегистирровать ячейки
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        loadItems()

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
            
            // Просто как обойтись с всеми товарами если мы захотим создать товар там! Можно просто убрать кнопочку Добавления!
            item.namecategory = self.categoryItemsString
            item.value = nameTextField.text!
            item.done = false
            
                
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
        
        // 2 название категории
//        controller.addTextField { (controllerTextField) in
//            controllerTextField.placeholder = "Название категории"
//
//            // присваиваем локальной переменной ссылк на объект
//            categorytextField = controllerTextField
//        }
  
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
    
    
// with request: NSFetchRequest<Item> = Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
    
        // Вообщем в Core Data что то наподобие SQl запросов! Ведь база SQl
        // останется только изучить как получать конктретные данные из таблицы п оконткретным параметрам и все будет норм! но это уже интереснее! Ближе к моему проекту
        
        // Если в метод приходит катгория то нужно осуществить поиски и загрузку всех ее Items
        
        if categoryItemsString != "Все продукты" {
            
            //Скроем в этом случае кнопку добавления товара и разрешим добавлять товар только в своей категории чтобы не было ошибок при выборе категории
            
            // Получи все строки с этим условием
            request.predicate = NSPredicate(format: "namecategory CONTAINS[cd] %@", categoryItemsString)
            
            // Отсортируй этот результат
            request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
        } else {
            
            addItemButton.isEnabled = false
        }
        
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
        
        
        // Положи в реквест все что нашел по предикут
        request.predicate = NSPredicate(format: "value CONTAINS[cd] %@", searchBar.text!)

        // Отсортируй этот результат
        request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
        
        loadItems(with: request)
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

