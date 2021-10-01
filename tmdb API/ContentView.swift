//
//  ContentView.swift
//  tmdb API
//
//  Created by Gustavo Fernandes da Cruz Lima on 28/09/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MovieDetailView(movieId: 299534)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
