//
//  ContentView.swift
//  Bookworm
//
//  Created by Ping Yun on 10/2/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //managed object context property
    @Environment(\.managedObjectContext) var moc
    //fetch request reading all the books we have, NSSortDescriptor sorts by title first, author second
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>

    //Boolean that tracks whether the add screen is showing or not
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    //points to DetailView
                    NavigationLink(destination: DetailView(book: book)) {
                        //shows emoji rating
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)

                        VStack(alignment: .leading) {
                            //shows title of book
                            Text(book.title ?? "Unknown Title")
                                .font(.headline)
                            //shows author of book
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                //swipe to delete
                .onDelete(perform: deleteBooks)
            }
                .navigationBarTitle("Bookworm")
                //edit/done button
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
                //sheet presented when showingAddScreen is true 
                .sheet(isPresented: $showingAddScreen) {
                    //writes values to environment
                    AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            //find this book in our fetch request
            let book = books[offset]
            
            //delete it from the context
            moc.delete(book)
        }
        
        //save the context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
