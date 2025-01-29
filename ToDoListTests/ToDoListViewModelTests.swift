import XCTest
import Combine
@testable import ToDoList

final class ToDoListViewModelTests: XCTestCase {
    // MARK: - Properties
    
    private var viewModel: ToDoListViewModel! //! : optionnel implicite : on est sûr qu'il est initialisé (dans setUp)
    private var repository: MockToDoListRepository!
    
    // MARK: - Setup
    
    override func setUp() { //setUp : méthode de la classe XCTest donc override pour la modif
        super.setUp() //setUp classe parent
        repository = MockToDoListRepository()
        viewModel = ToDoListViewModel(repository: repository)
    }
    
    // MARK: - Tear Down
    //exécutée après chaque test pour nettoyer l'environnement et éviter les effets de bord d'un test à l'autre
    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testAddTodoItem() {
        // Given
        let item = ToDoItem(title: "Test Task")
        
        // When
        viewModel.add(item: item) //action testée
        
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 1) //vérifie que liste contient 1 élément
        XCTAssertTrue(viewModel.toDoItems[0].title == "Test Task")//vérifie titre 1er élément
    }
    
    func testToggleTodoItemCompletion() {
        // Given
        let item = ToDoItem(title: "Test Task")
        viewModel.add(item: item)
        
        // When
        viewModel.toggleTodoItemCompletion(item)
        
        // Then
        XCTAssertTrue(viewModel.toDoItems[0].isDone)
    }
    
    func testRemoveTodoItem() {
        // Given
        let item = ToDoItem(title: "Test Task")
        viewModel.toDoItems.append(item)
        
        // When
        viewModel.removeTodoItem(item)
        
        // Then
        XCTAssertTrue(viewModel.toDoItems.isEmpty)
    }
    
    func testFilteredToDoItems() {
        // Given
        let item1 = ToDoItem(title: "Task 1", isDone: true)
        let item2 = ToDoItem(title: "Task 2", isDone: false)
        viewModel.add(item: item1)
        viewModel.add(item: item2)
        
        // When
        viewModel.applyFilter(at: 0)
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 2)
        
        // When
        viewModel.applyFilter(at: 1)
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 1)
        
        // When
        viewModel.applyFilter(at: 2)
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 1)
    }
}
