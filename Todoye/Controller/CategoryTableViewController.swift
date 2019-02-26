//
//  CategoryTableViewController.swift
//  Todoye
//
//  Created by PavelM on 25/02/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//





/*
 
    Вообщем для обучения нужно прописать все разделы самостоятельно!
    Все делегаты, работу с базой данных, seque и тд!
 
 */

// 1. Создам категорию чтобы отображала все что есть в базе данных


import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    // Массив данных из БД
    var itemCategoryArray: [Category] = []
    var categoryItems: String!
    
    // Context Нашей БД
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
        
        // Поменяем название щаголовка на категорию
 
        
        

    

    }


    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCategoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = itemCategoryArray[indexPath.row].name
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // При нажатия на строку мы переходим ко всем продуктам этой категории
        
        // Нужно передать параметр category в следующий ViewController
        
        categoryItems = itemCategoryArray[indexPath.row].name
   
        
        // Осуществляю переход
        performSegue(withIdentifier: "goToTodoye", sender: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToTodoye" {
            
            let itemVC = segue.destination as! TodoyeTableViewController
            itemVC.categoryItemsString = categoryItems
        }


    }
    
    // При добавлении категории Создаем класси сохраняем изменени в БД
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        
        var textFieldAlert = UITextField()
        
        // Вызовем Алерт с текстовым полем
        
        let controller = UIAlertController(title: "Новая категория", message: "Добавьте категорию", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textFieldAlert.text
            
            self.itemCategoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        controller.addTextField { (textField) in
            textField.placeholder = "Название категории"
            textFieldAlert = textField
        }
        
        controller.addAction(action)
        
        present(controller,animated: true,completion: nil)
        
     
    }
    
    // Сохраняем категории в БД
    
    func saveCategory() {

        do {
            
            try context.save()
            
        } catch {
            
            print("Saving data Error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    // Подгружаем все данные из таблички
    func loadCategory() {
        // Возмем все что есть в табличке
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            // Положем все в наш массив Категорий
            itemCategoryArray = try context.fetch(request)
            
        }catch {
            
            print("Request error \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    
}



