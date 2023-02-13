//
//  ContentView.swift
//

import SwiftUI
import UIKit

struct RepresentedMyView: UIViewRepresentable {
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
    @State private var pin: Int = 0
    @State private var showPin = true

    var body: some View {
        VStack(alignment: .center) {
            if showPin {
                HStack {
                    Text("Enter pin")
                        .font(.largeTitle)
                    TextField(
                        "",
                        value: $pin,
                        format: .number
                    ).font(.largeTitle.monospacedDigit())
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .fixedSize()
                        .keyboardType(.numberPad)
                }
                Button("Start") {
                    AppDelegate.instance.startUnbluView(pin)
                    self.showPin = false
                }.font(.largeTitle)
            } else {
                RepresentedMyView(AppDelegate.instance.getUnbluView())
                    .padding()
            }
        }.frame(maxWidth: .infinity)
    }
}



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
