import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ]) var books: [Book]
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            if hasValidBook(title: book.title, author: book.author, genre: book.genre, review: book.review) {
                                EmojiRatingView(rating: book.rating)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                        .foregroundStyle(book.rating == 1 ? Color.red : Color.black)
                                    
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                        .foregroundStyle(book.author == 1 ? Color.red : Color.black)
                                }
                            } else {
                                EmojiRatingView(rating: 4)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading) {
                                    Text("Илон Маск")
                                        .font(.headline)
                                    Text("Уолтер Айзексон")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
            // Переместили вызов навигации сюда
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }

    func hasValidBook(title: String, author: String, genre: String, review: String) -> Bool {
        if title.trimmingCharacters(in: .whitespaces).isEmpty &&
            author.trimmingCharacters(in: .whitespaces).isEmpty &&
            review.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
}

#Preview {
    ContentView()
}
