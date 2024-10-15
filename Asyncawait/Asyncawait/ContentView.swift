//
//  ContentView.swift
//  Asyncawait
//
//  Created by Nivedha Rajendran on 14.10.24.
//

import SwiftUI

struct ContentView: View {
    
    private let viewModel: ViewModel
        
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            //Download images asynchronously 
            AsyncImage(url: URL(string: "https://picsum.photos/id/237/300/300")) { phase in
                if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                        Text("No image available")
                    } else {
                        Image(systemName: "photo")
                    }
            }
            .frame(width: 250, height: 250)
            .border(Color.gray)
            
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
