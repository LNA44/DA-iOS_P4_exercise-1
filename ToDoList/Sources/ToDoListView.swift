import SwiftUI

struct ToDoListView: View {
    @ObservedObject var viewModel: ToDoListViewModel //observedobject : classe partagée entre plusieurs vues
    @State private var newTodoTitle = "" //state : local à la vue
    @State private var isShowingAlert = false
    @State private var isAddingTodo = false
    
    // New state for filter index
    @State private var filterIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter selector
                // TODO: - Add a filter selector which will call the viewModel for updating the displayed data
                // List of tasks
                List {
                    ForEach(viewModel.toDoItems) { item in
                        HStack {
                            Button(action: {
                                viewModel.toggleTodoItemCompletion(item)
                            }) {
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(item.isDone ? .green : .primary)
                            }
                            Text(item.title)
                                .font(item.isDone ? .subheadline : .body)//si isDone est true alors police=subheadline sinon body
                                .strikethrough(item.isDone) //si isDone=true alors texte barré
                                .foregroundColor(item.isDone ? .gray : .primary) //si isDonne est true alors couleur police grise sinon noir
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            let item = viewModel.toDoItems[index]
                            viewModel.removeTodoItem(item)
                        }
                    }
                }
                
                // Sticky bottom view for adding todos
                if isAddingTodo { //si isAddingTodo = true
                    HStack { //on crée une HStack
                        TextField("Enter Task Title", text: $newTodoTitle) //$newToDoTitle : binding vers propriété newToDoTitle. Donc propriété maj
                            .padding(.leading)                             // qd utilisateur écrit qqe chose. Liaison bidirectionnelle

                        Spacer()
                        
                        Button(action: {
                            if newTodoTitle.isEmpty {
                                isShowingAlert = true
                            } else {
                                viewModel.add(
                                    item: .init( //création instance de ToDoItem
                                        title: newTodoTitle //avec pour titre ce qui a été écerit par l'utilisateur
                                    )
                                )
                                newTodoTitle = "" // Reset newTodoTitle to empty.
                                isAddingTodo = false // Close the bottom view after adding
                            }
                        }) {
                            Image(systemName: "plus.circle.fill") //visuel du bouton
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                
                // Button to toggle the bottom add view
                Button(action: {
                    isAddingTodo.toggle() //toggle()-> inverse la val de true à false ou inversement
                }) {
                    Text(isAddingTodo ? "Close" : "Add Task") //si isAddingToDo est true alors écrit close sinon add task
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()

            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(
            viewModel: ToDoListViewModel(
                repository: ToDoListRepository()
            )
        )
    }
}
