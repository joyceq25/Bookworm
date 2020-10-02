//
//  RatingView.swift
//  Bookworm
//
//  Created by Ping Yun on 10/2/20.
//

import SwiftUI

struct RatingView: View {
    //stores @Binding integer so we can report back user's selection to whatever is using the star rating
    @Binding var rating: Int
    
    //stores label placed before rating
    var label = ""
    
    //stores maximum integer rating
    var maximumRating = 5
    
    //store off/on images that dictate images to use when star is highlighted or not
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    //store off/on colors that dictate the colors to use when star is highlighted or not
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            //if label has any text, uses it
            if label.isEmpty == false {
                Text(label)
            }
            
            //counts from 1 to maximum rating +1 and calls image(for:) repeatedly 
            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
    
    //if number passed in > current rating, returns off image if it was set, otherwise returns on image
    //if number passed in <= current rating, returns on image
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else{
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
            .previewDevice("iPhone 11")
    }
}
