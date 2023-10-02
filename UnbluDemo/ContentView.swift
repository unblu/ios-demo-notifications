//
//  ContentView.swift
//

import SwiftUI
import UIKit



class UnbluUiState : ObservableObject {
    @Published var unbluView: UIView?
}

struct RepresentedUnbluView: UIViewRepresentable {
    typealias UIViewType = UIView
    let view: UIView
    
    init(_ view: UIView) {
        self.view = view
    }
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct ContentView: View {
    @State var unbluState =  UnbluUiState()
    @State private var isStarted = false
    @State private var loading = false
    var body: some View {
        VStack(alignment: .center) {
            if loading {
                ZStack{
                    ProgressView {
                        Text("Loading...")
                            .font(.title2)
                    }
                }.frame(width: 120, height: 120, alignment: .center)
            }
            if isStarted, let view = unbluState.unbluView {
                ZStack(alignment: .topTrailing) {
                    RepresentedUnbluView(view)
                        .padding(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
                }
            }
            Button(isStarted ? "Stop": "Start" ) {
                if !isStarted {
                    loading.toggle()
                    AppDelegate.instance.startUnbluView() {
                        loading.toggle()
                        self.unbluState.unbluView = AppDelegate.instance.unbluVisitor?.view
                        self.isStarted.toggle()
                    }
                } else {
                    loading.toggle()
                    AppDelegate.instance.stopUnbluView() {
                        loading.toggle()
                        unbluState.unbluView = nil
                        self.isStarted.toggle()
                    }
                }
            }.font(.largeTitle)
        }.padding(EdgeInsets(top: 5,leading: 5,bottom: 10,trailing: 5))
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .shadow(color: .gray, radius: 5, x: 0, y: 5)
    }
}



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
