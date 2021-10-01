//
//  MovieBAckdropCard.swift
//  tmdb API
//
//  Created by Gustavo Fernandes da Cruz Lima on 29/09/21.
//

import SwiftUI

struct MovieBackdropCard: View {
    
    let movie: Movie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
            VStack(alignment: .leading){
                ZStack{
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    
                    if self.imageLoader.image != nil{
                        Image(uiImage: self.imageLoader.image!)
                            .resizable()
                    }
                    
                }
            Text(movie.title)
        }
    }
}

struct MovieBackdropCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieBackdropCard(movie: Movie.stubbedMovie)
    }
}
