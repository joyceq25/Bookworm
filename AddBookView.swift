//
//  AddBookView.swift
//  Bookworm
//
//  Created by Ping Yun on 10/2/20.
//

import SwiftUI

struct AddBookView: View {
    //environment property to store managed object context
    @Environment(\.managedObjectContext) var moc
    
    //tracks current presentation mode 
    @Environment(\.presentationMode) var presentationMode
    
    //@State properties for each of book's values except id
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    //stores all possible genre options
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        Form {
            Section {
                //text fields for title and author
                TextField("Name of book", text: $title)
                TextField("Author's name", text: $author)
                
                //picker for genre 
                Picker("Genre", selection: $genre) {
                    ForEach(genres, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section {
                //shows RatingView
                RatingView(rating: $rating)
                
                //text field for review
                TextField("Write a review", text: $review)
            }
            
            Section {
                Button("Save") {
                    //creates instance of Book class using managed object context
                    let newBook = Book(context: self.moc)
                    
                    //copies in values from form
                    newBook.title = self.title
                    newBook.author = self.author
                    //converts rating to Int16 to match Core Data
                    newBook.rating = Int16(self.rating)
                    newBook.genre = self.genre
                    newBook.review = self.review
                    
                    //saved managed object context 
                    try? self.moc.save()
                    //call to dismiss()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitle("Add Book")
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
            .previewDevice("iPhone 11")
    }
}
