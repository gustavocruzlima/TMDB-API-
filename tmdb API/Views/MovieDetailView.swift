//
//  MovieDetailView.swift
//  tmdb API
//
//  Created by Gustavo Fernandes da Cruz Lima on 30/09/21.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movieId: Int
    @ObservedObject private var movieDetailState = MovieDetailState()
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId)
            }
            
            if movieDetailState.movie != nil {
                MovieDetailListView(movie: self.movieDetailState.movie!)
                
            }
        }.onAppear {
            self.movieDetailState.loadMovie(id: self.movieId)
        }
    }
}

struct MovieDetailListView: View {
    
    let movie: Movie
    let imageLoader = ImageLoader()
    
    var body: some View {
        NavigationView{
            List{
                MovieDetailImage(imageLoader: imageLoader, imageURL: self.movie.backdropURL)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                HStack {
                    Text(movie.yearText)
                    Text("·")
                    Text(movie.durationText)
                }
                
                Text(movie.title).font(.system(size: 30, weight: .heavy, design: .default))
                
                HStack(alignment: .top, spacing: 130){
                        Button(action: {
                                            print("")
                                        }) {
                                        Image(systemName: "play.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 36, height: 36)
                                    }
                        
                        Button(action: {
                                            print("")
                                        }) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 36, height: 36)
                        }.frame(alignment: .center)
                        
                        Button(action: {
                                            print("")
                                        }) {
                                        Image(systemName: "square.and.arrow.up")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 36, height: 36)
                        }.frame(alignment: .trailing)
                }
                
                HStack(alignment: .top, spacing: 4) {
                    if movie.cast != nil && movie.cast!.count > 0 {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            if movie.directors != nil && movie.directors!.count > 0 {
                                Text("Director(s)").font(.headline)
                                ForEach(self.movie.directors!.prefix(2)) { crew in
                                    Text(crew.name)
                                }
                            }
                            
                            if movie.producers != nil && movie.producers!.count > 0 {
                                Text("Producer(s)").font(.headline)
                                ForEach(self.movie.producers!.prefix(2)) { crew in
                                    Text(crew.name)
                                }
                            }
                            
                            if movie.screenWriters != nil && movie.screenWriters!.count > 0 {
                                Text("Screenwriter(s)").font(.headline)
                                    .padding(.top)
                                ForEach(self.movie.screenWriters!.prefix(2)) { crew in
                                    Text(crew.name)
                                }
                            }
                            
                            Text("Starring").font(.headline)
                            ForEach(self.movie.cast!.prefix(9)) { cast in
                                Text(cast.name)
                            }
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        
                    }
                    
                }
                
                HStack(alignment: .top, spacing: 4) {
                    VStack {
                        if !movie.ratingText.isEmpty {
                            Text("Avaliação").bold()
                            Text(movie.ratingText).foregroundColor(.yellow)
                        }
                    }
                    
                    
                    
                    VStack {
                        if !movie.scoreText.isEmpty{
                            Text("themoviedb.org").frame(width: 200, alignment: .trailing)
                            Text(movie.scoreText).frame(width: 100, alignment: .trailing)
                        }
                    }
                }
                
                Text(movie.overview)
                
                Divider()
                
                if(movie.releaseDate != nil) {
                    HStack(alignment: .top, spacing: 4){
                        VStack {
                            Text("Lançamento")
                        }
                        
                        VStack {
                            Text(movie.formatedReleaseDate).frame(width: 250, alignment: .trailing)
                        }
                    }
                }
                
                if(movie.runtime != nil) {
                    HStack(alignment: .top, spacing: 4){
                        VStack {
                            Text("Duração")
                        }
                        
                        VStack {
                            Text(movie.durationText).frame(width: 300, alignment: .trailing)
                        }
                    }
                }
            }.navigationBarTitle(Text(movie.title))
        }
    }
}

struct MovieDetailImage: View {
    
    @ObservedObject var imageLoader: ImageLoader
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(movieId: Movie.stubbedMovie.id)
        }
    }
}
