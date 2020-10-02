//
//  DetailView.swift
//  Bookworm
//
//  Created by Ping Yun on 10/2/20.
//

import SwiftUI
import CoreData

struct DetailView: View {
    //stores book view should show
    let book: Book
    //holds Core Data managed object context
    @Environment(\.managedObjectContext) var moc
    //holds presentation mode
    @Environment(\.presentationMode) var presentationMode
    //controls whether we're showing delete confirmation alert or not
    @State private var showingDeleteAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    //shows category image
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    
                    //places genre name in bottom right corner of ZStack with background color, bold font, padding
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                //shows author
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                //shows review
                Text(self.book.review ?? "No review")
                    .padding()
                
                //shows rating, uses constant binding so user can't adjust rating
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                //pushes everything to top of view 
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        //alert() modifier that watches showingDeleteAlert
        .alert(isPresented: $showingDeleteAlert) {
            //.destructive button destroys data, .cancel() dismisses alert
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button(action: {
            //flips showingDeleteAlert Boolean 
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        //deletes current book from managed object context
        moc.delete(book)

        // uncomment this line if you want to make the deletion permanent
        // try? self.moc.save()
        //dismisses current view
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    //creates temporary managed object context
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    //uses it to create book, passes in example data to make preview look good
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        
        //uses test book to create detail view preview
        return NavigationView {
            DetailView(book: book)
        }
    }
}
