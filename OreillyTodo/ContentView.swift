//
//  ContentView.swift
//  OreillyTodo
//
//  Created by Andrew Gorbunov on 27.03.2024.
//

import SwiftUI

struct Item: Identifiable, Codable, Equatable {
    var id = UUID()
    var todo: String
    var isCompleted = false
}

struct ContentView: View {
    @State private var currentTodo = ""
    @State private var todos: [Item] = [Item(todo: "Образец заметки", isCompleted: true)]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Новая заметка...", text: $currentTodo)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("+") {
                        guard !currentTodo.isEmpty else { return }
                        todos.insert(Item(todo: currentTodo), at: 0)
                        currentTodo = ""
                        save()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                
                List {
                    ForEach(todos) { todo in
                        HStack {
                            Image(systemName: !todo.isCompleted ? "circle" : "circle.inset.filled")
                            Text(todo.todo)
                        }
                        .swipeActions(edge: .leading) {
                            Button("Отметить") {
                                //todo.isCompleted.toggle()
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.inset)
            }
            .navigationTitle("Список")
            .animation(.default, value: todos)
        }
        .onAppear(perform: load)
    }
    
    private func save() {
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(self.todos), forKey: "myTodosKey"
        )
    }
    
    private func load() {
        if let todosData = UserDefaults.standard.value(forKey: "myTodosKey") as? Data {
            if let todosList
                = try? PropertyListDecoder().decode(Array<Item>.self, from: todosData) {
                self.todos = todosList
            }
        }
    }
    
    private func delete(at offset: IndexSet) {
        todos.remove(atOffsets: offset)
        save()
    }
}

#Preview {
    ContentView()
}
