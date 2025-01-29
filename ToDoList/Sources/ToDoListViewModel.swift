import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType

    // MARK: - Init
//Pour créer la dépendance avec le repository
    init(repository: ToDoListRepositoryType) {
        self.repository = repository //crée le lien entre le repository et le viewmodel
        self.toDoItems = repository.loadToDoItems() //charge les éléments de la liste à la création du viewmodel
    }

    // MARK: - Outputs
//OUTPUTS: vers la vue
	
    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] { //propriété modifiée par l'utilisateur dans la vue
        didSet {
            repository.saveToDoItems(toDoItems) //qd modif dans le view model, le model est maj
        }
    }

    // MARK: - Inputs
//INPUTS: infos reçues de la vue
	
    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle() //inversion du isDone de false à true
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        // TODO: - Implement the logic for filtering
    }
}
